Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934324Ab1ESS0I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:26:08 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:33871 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934100Ab1ESS0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:26:05 -0400
X-Sasl-enc: zCLCHPu+PlpAOJpPB0e+VRDos40HdgA+LivmaE1cvr70 1305829564
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:24:38 2011
Message-Id: <20110519182438.374119619@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:23:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [21/21] netxen: Remove references to unified firmware file
In-Reply-To: <20110519182446.GA23751@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------


Commit c23a103f0d9c2560c6839ed366feebec4cd5e556 wrongly introduced
references to the unified firmware file "phanfw.bin", which is not
supported by netxen in 2.6.32.  The driver reports this filename when
loading firmware from flash, and includes a MODULE_FIRMWARE hint for
the filename even though it will never use it.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/netxen/netxen_nic.h      |    1 -
 drivers/net/netxen/netxen_nic_init.c |    1 -
 drivers/net/netxen/netxen_nic_main.c |    1 -
 3 files changed, 3 deletions(-)

--- a/drivers/net/netxen/netxen_nic.h
+++ b/drivers/net/netxen/netxen_nic.h
@@ -490,7 +490,6 @@ struct status_desc {
 #define NX_P2_MN_ROMIMAGE_NAME		"nxromimg.bin"
 #define NX_P3_CT_ROMIMAGE_NAME		"nx3fwct.bin"
 #define NX_P3_MN_ROMIMAGE_NAME		"nx3fwmn.bin"
-#define NX_UNIFIED_ROMIMAGE_NAME	"phanfw.bin"
 #define NX_FLASH_ROMIMAGE_NAME		"flash"
 
 extern char netxen_nic_driver_name[];
--- a/drivers/net/netxen/netxen_nic_init.c
+++ b/drivers/net/netxen/netxen_nic_init.c
@@ -676,7 +676,6 @@ static char *fw_name[] = {
 	NX_P2_MN_ROMIMAGE_NAME,
 	NX_P3_CT_ROMIMAGE_NAME,
 	NX_P3_MN_ROMIMAGE_NAME,
-	NX_UNIFIED_ROMIMAGE_NAME,
 	NX_FLASH_ROMIMAGE_NAME,
 };
 
--- a/drivers/net/netxen/netxen_nic_main.c
+++ b/drivers/net/netxen/netxen_nic_main.c
@@ -41,7 +41,6 @@ MODULE_VERSION(NETXEN_NIC_LINUX_VERSIONI
 MODULE_FIRMWARE(NX_P2_MN_ROMIMAGE_NAME);
 MODULE_FIRMWARE(NX_P3_CT_ROMIMAGE_NAME);
 MODULE_FIRMWARE(NX_P3_MN_ROMIMAGE_NAME);
-MODULE_FIRMWARE(NX_UNIFIED_ROMIMAGE_NAME);
 
 char netxen_nic_driver_name[] = "netxen_nic";
 static char netxen_nic_driver_string[] = "NetXen Network Driver version "


