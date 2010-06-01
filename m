Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab0FATBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 15:01:05 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:33194 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab0FATBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 15:01:03 -0400
Date: Tue, 1 Jun 2010 20:00:50 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: x86@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]X86:reboot.c Add some dmi entries to
	pci_reboot_dmi_table.
Message-ID: <20100601190050.GA14667@srcf.ucam.org>
References: <1275114371-5329-1-git-send-email-justinmattock@gmail.com> <20100531170745.GA21225@srcf.ucam.org> <4C03F5EF.8080302@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C03F5EF.8080302@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you try with this patch? From what I can see of Apple ACPI tables, 
it should be functionally equivalent but less hate inducing.

commit 9c8c25fda1b993a81b1a3a9bc4e9e8b0d7ac4062
Author: Matthew Garrett <mjg@redhat.com>
Date:   Tue Jun 1 14:40:55 2010 -0400

    x86: Default to using ACPI for reboot
    
    Running a hacked qemu with a modified seabios image that declares support
    for reboot via ACPI shows that Windows will use the ACPI reboot vector
    before falling back to hitting i8042. Change the default reboot method to
    match this. This looks like it should improve life for Apples, which
    declare the cf9 reboot method via ACPI, don't have a competent i8042
    emulation and currently have a large DMI whitelist.
    
    Signed-off-by: Matthew Garrett <mjg@redhat.com>

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 8e1aac8..0a04c4b 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -34,7 +34,7 @@ EXPORT_SYMBOL(pm_power_off);
 
 static const struct desc_ptr no_idt = {};
 static int reboot_mode;
-enum reboot_type reboot_type = BOOT_KBD;
+enum reboot_type reboot_type = BOOT_ACPI;
 int reboot_force;
 
 #if defined(CONFIG_X86_32) && defined(CONFIG_SMP)

-- 
Matthew Garrett | mjg59@srcf.ucam.org
