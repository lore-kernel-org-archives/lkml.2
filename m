Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289Ab2LCUCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 15:02:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52015 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053Ab2LCUCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 15:02:47 -0500
Date: Mon, 3 Dec 2012 14:02:41 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-efi@vger.kernel.org,
        mfleming@intel.com, dwmw2@infradead.org
Subject: Re: Use PCI ROMs from EFI boot services
Message-ID: <20121203200241.GG5906@thinkpad-t410>
Mail-Followup-To: Bjorn Helgaas <bhelgaas@google.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org, linux-efi@vger.kernel.org,
	mfleming@intel.com, dwmw2@infradead.org
References: <1345739803-21017-1-git-send-email-mjg@redhat.com>
 <CAErSpo6dn_0b8Ngx9VT=ARs_UXQftEx=2Kczeqemtmo0XyKzuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo6dn_0b8Ngx9VT=ARs_UXQftEx=2Kczeqemtmo0XyKzuQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 11:35:57AM -0600, Bjorn Helgaas wrote:
> On Thu, Aug 23, 2012 at 10:36 AM, Matthew Garrett <mjg@redhat.com> wrote:
> > V3 just fixes all the casting issues and incorporates David's change in
> > search ordering.
> 
> I think there's still a section mismatch issue with these patches, so
> I haven't merged them yet.
> 
> I rebased my pci/mjg-pci-roms-from-efi branch to v3.7-rc2, and if we
> get this issue fixed I'll put it in -next as v3.8 material.

I still don't see this series in -next, so I take it the section
mismatch was never fixed? How about the following?

Thanks,
Seth


>From ece31852159a6b2cf9a059031638354e9817a6a6 Mon Sep 17 00:00:00 2001
From: Seth Forshee <seth.forshee@canonical.com>
Date: Mon, 3 Dec 2012 13:55:50 -0600
Subject: [PATCH] x86: Don't discard boot_params

boot_params is now used at runtime on EFI systems to stash option ROMs
that aren't available after exiting boot services, so it can no longer
be marked __initdata.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 arch/x86/kernel/setup.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 468e98d..6e13035 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -143,11 +143,7 @@ int default_check_phys_apicid_present(int phys_apicid)
 }
 #endif
 
-#ifndef CONFIG_DEBUG_BOOT_PARAMS
-struct boot_params __initdata boot_params;
-#else
 struct boot_params boot_params;
-#endif
 
 /*
  * Machine setup..
-- 
1.7.9.5

