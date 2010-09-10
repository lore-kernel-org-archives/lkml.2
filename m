Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab0IJCme (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 22:42:34 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:38116 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab0IJCmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 22:42:33 -0400
Date: Thu, 09 Sep 2010 21:42:06 -0500
From: Corey Minyard <minyard@acm.org>
To: Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Subject: [PATCH] ipmi: Fix __init and __exit attribute locations
Message-id: <20100910024206.GA5627@mail.minyard.local>
Reply-to: minyard@acm.org
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

__init and __exit belong after the return type on functions, not
before.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
---

Index: linux-2.6.32/drivers/char/ipmi/ipmi_msghandler.c
===================================================================
--- linux-2.6.32.orig/drivers/char/ipmi/ipmi_msghandler.c	2010-09-09 09:35:32.000000000 -0500
+++ linux-2.6.32/drivers/char/ipmi/ipmi_msghandler.c	2010-09-09 09:38:52.712232472 -0500
@@ -4442,13 +4442,13 @@
 	return 0;
 }
 
-static __init int ipmi_init_msghandler_mod(void)
+static int __init ipmi_init_msghandler_mod(void)
 {
 	ipmi_init_msghandler();
 	return 0;
 }
 
-static __exit void cleanup_ipmi(void)
+static void __exit cleanup_ipmi(void)
 {
 	int count;
 
Index: linux-2.6.32/drivers/char/ipmi/ipmi_si_intf.c
===================================================================
--- linux-2.6.32.orig/drivers/char/ipmi/ipmi_si_intf.c	2010-09-09 09:35:34.000000000 -0500
+++ linux-2.6.32/drivers/char/ipmi/ipmi_si_intf.c	2010-09-09 09:39:38.480979178 -0500
@@ -1832,7 +1832,7 @@
 	return rv;
 }
 
-static __devinit void hardcode_find_bmc(void)
+static void __devinit hardcode_find_bmc(void)
 {
 	int             i;
 	struct smi_info *info;
@@ -2016,7 +2016,7 @@
 	s8      spmi_id[1]; /* A '\0' terminated array starts here. */
 };
 
-static __devinit int try_init_spmi(struct SPMITable *spmi)
+static int __devinit try_init_spmi(struct SPMITable *spmi)
 {
 	struct smi_info  *info;
 
@@ -2099,7 +2099,7 @@
 	return 0;
 }
 
-static __devinit void spmi_find_bmc(void)
+static void __devinit spmi_find_bmc(void)
 {
 	acpi_status      status;
 	struct SPMITable *spmi;
@@ -2312,7 +2312,7 @@
 	return 0;
 }
 
-static __devinit void try_init_dmi(struct dmi_ipmi_data *ipmi_data)
+static void __devinit try_init_dmi(struct dmi_ipmi_data *ipmi_data)
 {
 	struct smi_info *info;
 
@@ -2999,7 +2999,7 @@
 	{ .port = 0 }
 };
 
-static __devinit void default_find_bmc(void)
+static void __devinit default_find_bmc(void)
 {
 	struct smi_info *info;
 	int             i;
@@ -3302,7 +3302,7 @@
 	return rv;
 }
 
-static __devinit int init_ipmi_si(void)
+static int __devinit init_ipmi_si(void)
 {
 	int  i;
 	char *str;
@@ -3514,7 +3514,7 @@
 	kfree(to_clean);
 }
 
-static __exit void cleanup_ipmi_si(void)
+static void __exit cleanup_ipmi_si(void)
 {
 	struct smi_info *e, *tmp_e;
 
Index: linux-2.6.32/drivers/char/ipmi/ipmi_devintf.c
===================================================================
--- linux-2.6.32.orig/drivers/char/ipmi/ipmi_devintf.c	2010-09-09 09:35:29.000000000 -0500
+++ linux-2.6.32/drivers/char/ipmi/ipmi_devintf.c	2010-09-09 09:38:52.722230238 -0500
@@ -915,7 +915,7 @@
 	.smi_gone = ipmi_smi_gone,
 };
 
-static __init int init_ipmi_devintf(void)
+static int __init init_ipmi_devintf(void)
 {
 	int rv;
 
@@ -953,7 +953,7 @@
 }
 module_init(init_ipmi_devintf);
 
-static __exit void cleanup_ipmi(void)
+static void __exit cleanup_ipmi(void)
 {
 	struct ipmi_reg_list *entry, *entry2;
 	mutex_lock(&reg_list_mutex);
