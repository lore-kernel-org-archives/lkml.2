Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933203Ab1FWTnO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 15:43:14 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:59393 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932726Ab1FWTnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 15:43:13 -0400
Subject: [PATCH 10/11] Remove PSEUDOSZ, use sizeof(struct pseudo_hdr) instead.
To: "Greg Kroah-Hartman" <greg@kroah.com>
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
From: Ondrej Zary <linux@rainbow-software.org>
Date: Thu, 23 Jun 2011 21:43:04 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201106232143.06127.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PSEUDOSZ seems to define struct pseudo_hdr size.
Remove it and use sizeof(struct pseudo_hdr) directly.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000.h    |    2 --
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c |    8 ++++----
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h b/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
index e1aa528..ba6f87d 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
@@ -202,8 +202,6 @@ struct pseudo_hdr {
 #define MAX_DSP_SESS_REC	1024
 
 #define DSP_QID_OFFSET	4
-#define PSEUDOSZ	16
-#define PSEUDOSZWRD	8
 
 /* Maximum number of occurrence of pseudo header errors before resetting PC Card. */
 #define MAX_PH_ERR	300
diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
index 23854e0..990b2af 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -795,7 +795,7 @@ void ft1000_send_cmd (struct net_device *dev, u16 *ptempbuffer, int size, u16 qt
 	u16 tempword;
 	unsigned long flags;
 
-	size += PSEUDOSZ;
+	size += sizeof(struct pseudo_hdr);
 	// check for odd byte and increment to 16-bit word align value
 	if ((size & 0x0001)) {
 		size++;
@@ -883,12 +883,12 @@ bool ft1000_receive_cmd(struct net_device *dev, u16 * pbuffer, int maxsz, u16 *p
 	unsigned long flags;
 
 	if (info->AsicID == ELECTRABUZZ_ID) {
-		size = ( ft1000_read_dpram(dev, *pnxtph) ) + PSEUDOSZ;
+		size = ( ft1000_read_dpram(dev, *pnxtph) ) + sizeof(struct pseudo_hdr);
 	} else {
 		size =
 			ntohs(ft1000_read_dpram_mag_16
 			  (dev, FT1000_MAG_PH_LEN,
-			   FT1000_MAG_PH_LEN_INDX)) + PSEUDOSZ;
+			   FT1000_MAG_PH_LEN_INDX)) + sizeof(struct pseudo_hdr);
 	}
 	if (size > maxsz) {
 		DEBUG(1,
@@ -1317,7 +1317,7 @@ int ft1000_parse_dpram_msg(struct net_device *dev)
 		}
 		DEBUG(1, "FT1000:ft1000_parse_dpram_msg:total length = %d\n",
 			  total_len);
-		if ((total_len < MAX_CMD_SQSIZE) && (total_len > PSEUDOSZ)) {
+		if ((total_len < MAX_CMD_SQSIZE) && (total_len > sizeof(struct pseudo_hdr))) {
             total_len += nxtph;
             cnt = 0;
             // ft1000_read_reg will return a value that needs to be byteswap
-- 
Ondrej Zary

