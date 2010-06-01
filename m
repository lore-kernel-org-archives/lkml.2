Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab0FATOj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 15:14:39 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:63031 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab0FATOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 15:14:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=puCAyK2mpfH1KzPfNLiLxGXW660U2n7Va5OIVMO8H/bqhcW/yysKyv6Xc1Ldy3Loa7
         RmTrTj5J6/2HPT4x7yOPpUiR10qWUhCw4JoiaJINCyLRTFtVqmxrJzesAZNxfANfkpyb
         hw3rRJs+x6uy4KoN8ioNGvIjMj/s+BllzBick=
Message-ID: <4C055BFF.8090800@gmail.com>
Date: Tue, 01 Jun 2010 12:14:07 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: x86@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]X86:reboot.c Add some dmi entries to	pci_reboot_dmi_table.
References: <1275114371-5329-1-git-send-email-justinmattock@gmail.com> <20100531170745.GA21225@srcf.ucam.org> <4C03F5EF.8080302@gmail.com> <20100601190050.GA14667@srcf.ucam.org>
In-Reply-To: <20100601190050.GA14667@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2010 12:00 PM, Matthew Garrett wrote:
> Can you try with this patch? From what I can see of Apple ACPI tables,
> it should be functionally equivalent but less hate inducing.
>
> commit 9c8c25fda1b993a81b1a3a9bc4e9e8b0d7ac4062
> Author: Matthew Garrett<mjg@redhat.com>
> Date:   Tue Jun 1 14:40:55 2010 -0400
>
>      x86: Default to using ACPI for reboot
>
>      Running a hacked qemu with a modified seabios image that declares support
>      for reboot via ACPI shows that Windows will use the ACPI reboot vector
>      before falling back to hitting i8042. Change the default reboot method to
>      match this. This looks like it should improve life for Apples, which
>      declare the cf9 reboot method via ACPI, don't have a competent i8042
>      emulation and currently have a large DMI whitelist.
>
>      Signed-off-by: Matthew Garrett<mjg@redhat.com>
>
> diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
> index 8e1aac8..0a04c4b 100644
> --- a/arch/x86/kernel/reboot.c
> +++ b/arch/x86/kernel/reboot.c
> @@ -34,7 +34,7 @@ EXPORT_SYMBOL(pm_power_off);
>
>   static const struct desc_ptr no_idt = {};
>   static int reboot_mode;
> -enum reboot_type reboot_type = BOOT_KBD;
> +enum reboot_type reboot_type = BOOT_ACPI;
>   int reboot_force;
>
>   #if defined(CONFIG_X86_32)&&  defined(CONFIG_SMP)
>


o.k. applied.. unfortunately
I get init telling me it's rebooting,
then, nothing but a black screen.

Justin P. Mattock
