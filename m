Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873Ab1EFAYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:24:50 -0400
Received: from kroah.org ([198.145.64.141]:36730 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932197Ab1EFAYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:24:41 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:09 2011
Message-Id: <20110506002209.260479393@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:20:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dhananjay Phadke <dhananjay@netxen.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [041/143] netxen: module firmware hints
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Dhananjay Phadke <dhananjay@netxen.com>

commit 7e8e5d9718744b817bfea6f020586d7035cc89f4 upstream.

Add MODULE_FIRMWARE hints for various firmware file types,
required by different chip revisions.

Signed-off-by: Dhananjay Phadke <dhananjay@netxen.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/netxen/netxen_nic.h      |    6 ++++++
 drivers/net/netxen/netxen_nic_init.c |    6 +++++-
 drivers/net/netxen/netxen_nic_main.c |    4 ++++
 3 files changed, 15 insertions(+), 1 deletion(-)

--- a/drivers/net/netxen/netxen_nic.h
+++ b/drivers/net/netxen/netxen_nic.h
@@ -487,6 +487,12 @@ struct status_desc {
 #define NX_P3_MN_ROMIMAGE	2
 #define NX_FLASH_ROMIMAGE	3
 
+#define NX_P2_MN_ROMIMAGE_NAME		"nxromimg.bin"
+#define NX_P3_CT_ROMIMAGE_NAME		"nx3fwct.bin"
+#define NX_P3_MN_ROMIMAGE_NAME		"nx3fwmn.bin"
+#define NX_UNIFIED_ROMIMAGE_NAME	"phanfw.bin"
+#define NX_FLASH_ROMIMAGE_NAME		"flash"
+
 extern char netxen_nic_driver_name[];
 
 /* Number of status descriptors to handle per interrupt */
--- a/drivers/net/netxen/netxen_nic_init.c
+++ b/drivers/net/netxen/netxen_nic_init.c
@@ -673,7 +673,11 @@ netxen_need_fw_reset(struct netxen_adapt
 }
 
 static char *fw_name[] = {
-	"nxromimg.bin", "nx3fwct.bin", "nx3fwmn.bin", "flash",
+	NX_P2_MN_ROMIMAGE_NAME,
+	NX_P3_CT_ROMIMAGE_NAME,
+	NX_P3_MN_ROMIMAGE_NAME,
+	NX_UNIFIED_ROMIMAGE_NAME,
+	NX_FLASH_ROMIMAGE_NAME,
 };
 
 int
--- a/drivers/net/netxen/netxen_nic_main.c
+++ b/drivers/net/netxen/netxen_nic_main.c
@@ -38,6 +38,10 @@
 MODULE_DESCRIPTION("NetXen Multi port (1/10) Gigabit Network Driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(NETXEN_NIC_LINUX_VERSIONID);
+MODULE_FIRMWARE(NX_P2_MN_ROMIMAGE_NAME);
+MODULE_FIRMWARE(NX_P3_CT_ROMIMAGE_NAME);
+MODULE_FIRMWARE(NX_P3_MN_ROMIMAGE_NAME);
+MODULE_FIRMWARE(NX_UNIFIED_ROMIMAGE_NAME);
 
 char netxen_nic_driver_name[] = "netxen_nic";
 static char netxen_nic_driver_string[] = "NetXen Network Driver version "


