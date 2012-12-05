Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab2LEUJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 15:09:49 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:56806 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab2LEUJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 15:09:47 -0500
MIME-Version: 1.0
In-Reply-To: <20121203200241.GG5906@thinkpad-t410>
References: <1345739803-21017-1-git-send-email-mjg@redhat.com>
 <CAErSpo6dn_0b8Ngx9VT=ARs_UXQftEx=2Kczeqemtmo0XyKzuQ@mail.gmail.com> <20121203200241.GG5906@thinkpad-t410>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 5 Dec 2012 13:09:25 -0700
Message-ID: <CAErSpo7S2+Vt+9bkGLx_=AY9aSGCvAnkHfqu01gTj=eKs7btNw@mail.gmail.com>
Subject: Re: Use PCI ROMs from EFI boot services
To: Bjorn Helgaas <bhelgaas@google.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-efi@vger.kernel.org, mfleming@intel.com, dwmw2@infradead.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 3, 2012 at 1:02 PM, Seth Forshee <seth.forshee@canonical.com> wrote:
> On Thu, Oct 25, 2012 at 11:35:57AM -0600, Bjorn Helgaas wrote:
>> On Thu, Aug 23, 2012 at 10:36 AM, Matthew Garrett <mjg@redhat.com> wrote:
>> > V3 just fixes all the casting issues and incorporates David's change in
>> > search ordering.
>>
>> I think there's still a section mismatch issue with these patches, so
>> I haven't merged them yet.
>>
>> I rebased my pci/mjg-pci-roms-from-efi branch to v3.7-rc2, and if we
>> get this issue fixed I'll put it in -next as v3.8 material.
>
> I still don't see this series in -next, so I take it the section
> mismatch was never fixed? How about the following?

That's right; nobody stepped up to fix the section mismatch.  I'm
happy to fold in your fix, especially if Matthew acks it.

David, Eric, what about the kexec question?  It looks to me like this
wouldn't make things worse than they are today.  If I understand
correctly, today we don't use ROM data from EFI on either an initial
boot or a kexec.  After this patch, we could use EFI ROM data on the
initial boot, but not after a kexec.  So it's worse in the sense that
the kexec case doesn't match the initial boot, but at least it's not
something that used to work and is now broken.

> From ece31852159a6b2cf9a059031638354e9817a6a6 Mon Sep 17 00:00:00 2001
> From: Seth Forshee <seth.forshee@canonical.com>
> Date: Mon, 3 Dec 2012 13:55:50 -0600
> Subject: [PATCH] x86: Don't discard boot_params
>
> boot_params is now used at runtime on EFI systems to stash option ROMs
> that aren't available after exiting boot services, so it can no longer
> be marked __initdata.
>
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---
>  arch/x86/kernel/setup.c |    4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 468e98d..6e13035 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -143,11 +143,7 @@ int default_check_phys_apicid_present(int phys_apicid)
>  }
>  #endif
>
> -#ifndef CONFIG_DEBUG_BOOT_PARAMS
> -struct boot_params __initdata boot_params;
> -#else
>  struct boot_params boot_params;
> -#endif
>
>  /*
>   * Machine setup..
> --
> 1.7.9.5
>
