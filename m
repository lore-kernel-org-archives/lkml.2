Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab0KDPYB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 11:24:01 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:43236 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab0KDPYA convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:4:1>);
	Thu, 4 Nov 2010 11:24:00 -0400
Message-Id: <4CD2DE1E0200007800020990@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 04 Nov 2010 15:23:58 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "Yinghai Lu" <yinghai@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: adjust section annotations in AMD Fam10 MMCONF
	 enabling code
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

check_enable_amd_mmconf_dmi() gets called only for the BSP, hence
everything hanging off of it can be __init*.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/mmconf-fam10h_64.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- linux-2.6.37-rc1/arch/x86/kernel/mmconf-fam10h_64.c
+++ 2.6.37-rc1-x86_64-mmconf-fam10h-sections/arch/x86/kernel/mmconf-fam10h_64.c
@@ -217,13 +217,13 @@ void __cpuinit fam10h_check_enable_mmcfg
 	wrmsrl(address, val);
 }
 
-static int __devinit set_check_enable_amd_mmconf(const struct dmi_system_id *d)
+static int __init set_check_enable_amd_mmconf(const struct dmi_system_id *d)
 {
         pci_probe |= PCI_CHECK_ENABLE_AMD_MMCONF;
         return 0;
 }
 
-static const struct dmi_system_id __cpuinitconst mmconf_dmi_table[] = {
+static const struct dmi_system_id __initconst mmconf_dmi_table[] = {
         {
                 .callback = set_check_enable_amd_mmconf,
                 .ident = "Sun Microsystems Machine",
@@ -234,7 +234,8 @@ static const struct dmi_system_id __cpui
 	{}
 };
 
-void __cpuinit check_enable_amd_mmconf_dmi(void)
+/* Called from a __cpuinit function, but only on the BSP. */
+void __ref check_enable_amd_mmconf_dmi(void)
 {
 	dmi_check_system(mmconf_dmi_table);
 }



