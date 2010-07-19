Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965357Ab0GSSjl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 14:39:41 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:25902 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965267Ab0GSSje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 14:39:34 -0400
Subject: [PATCH 05/26] cciss: remove board_id parameter from
	cciss_interrupt_mode()
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Mon, 19 Jul 2010 13:45:05 -0500
Message-ID: <20100719184505.7908.28979.stgit@beardog.cce.hp.com>
In-Reply-To: <20100719184141.7908.26971.stgit@beardog.cce.hp.com>
References: <20100719184141.7908.26971.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

cciss: remove board_id parameter from cciss_interrupt_mode()

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 808d2a5..bb22a80 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -199,7 +199,7 @@ static void cciss_geometry_inquiry(int ctlr, int logvol,
 			sector_t total_size,
 			unsigned int block_size, InquiryData_struct *inq_buff,
 				   drive_info_struct *drv);
-static void __devinit cciss_interrupt_mode(ctlr_info_t *, __u32);
+static void __devinit cciss_interrupt_mode(ctlr_info_t *);
 static void start_io(ctlr_info_t *h);
 static int sendcmd_withirq(__u8 cmd, int ctlr, void *buff, size_t size,
 			__u8 page_code, unsigned char scsi3addr[],
@@ -3932,7 +3932,7 @@ clean_up:
  * controllers that are capable. If not, we use IO-APIC mode.
  */
 
-static void __devinit cciss_interrupt_mode(ctlr_info_t *c, __u32 board_id)
+static void __devinit cciss_interrupt_mode(ctlr_info_t *c)
 {
 #ifdef CONFIG_PCI_MSI
 	int err;
@@ -3941,9 +3941,8 @@ static void __devinit cciss_interrupt_mode(ctlr_info_t *c, __u32 board_id)
 	};
 
 	/* Some boards advertise MSI but don't really support it */
-	if ((board_id == 0x40700E11) ||
-	    (board_id == 0x40800E11) ||
-	    (board_id == 0x40820E11) || (board_id == 0x40830E11))
+	if ((c->board_id == 0x40700E11) || (c->board_id == 0x40800E11) ||
+	    (c->board_id == 0x40820E11) || (c->board_id == 0x40830E11))
 		goto default_int_mode;
 
 	if (pci_find_capability(c->pdev, PCI_CAP_ID_MSIX)) {
@@ -4052,7 +4051,7 @@ static int __devinit cciss_pci_init(ctlr_info_t *c)
 /* If the kernel supports MSI/MSI-X we will try to enable that functionality,
  * else we use the IO-APIC interrupt assigned to us by system ROM.
  */
-	cciss_interrupt_mode(c, c->board_id);
+	cciss_interrupt_mode(c);
 
 	/* find the memory BAR */
 	for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {

