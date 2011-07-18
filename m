Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593Ab1GRUpb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 16:45:31 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44028 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab1GRUp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 16:45:29 -0400
Date: Mon, 18 Jul 2011 13:45:25 -0700
From: Phil Oester <kernel@linuxace.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH][RESEND] PCI: correct nic order on Dell PowerEdge systems
Message-ID: <20110718204525.GA32439@linuxace.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

<Resending due to lack of response from PCI maintainer.  This problem
 still afflicts 3.0-rc and 2.6.39>

In commit 6e8af08dfa40b747002207d3ce8e8b43a050d99f ("PCI: enable pci=bfsort
by default on future Dell systems"), the callback added was placed at the
top of the list, before the specific PowerEdge models.  This ends up
breaking the more specific models listed, since the new callback handles
all Dell systems but the older systems don't have the new 0xB1 smbios
entry.

Fix this by placing the new check _after_ the more specific PowerEdge
sytems.

Phil Oester

Signed-off-by: Phil Oester <kernel@linuxace.com>


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-bfsort

diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 5fe7502..92df322 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -247,13 +247,6 @@ static const struct dmi_system_id __devinitconst pciprobe_dmi_table[] = {
 	},
 #endif		/* __i386__ */
 	{
-		.callback = find_sort_method,
-		.ident = "Dell System",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
-		},
-	},
-	{
 		.callback = set_bf_sort,
 		.ident = "Dell PowerEdge 1950",
 		.matches = {
@@ -294,6 +287,13 @@ static const struct dmi_system_id __devinitconst pciprobe_dmi_table[] = {
 		},
 	},
 	{
+		.callback = find_sort_method,
+		.ident = "Dell System",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
+		},
+	},
+	{
 		.callback = set_bf_sort,
 		.ident = "HP ProLiant BL20p G3",
 		.matches = {

--J2SCkAp4GZ/dPZZf--
