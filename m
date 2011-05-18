Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072Ab1ERKnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 06:43:16 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34082 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756955Ab1ERKnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 06:43:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=fqF6XNY5xRCkx9LIZdpjsWqKrcryJfULbVvu8Lnv9b8ssTVqrr76yV1co+iYWMIFN9
         s+0fttUiDPBJHACg/5ZlUXs/voNh1qZQTdNe8qx0hWyhLw8qWH+LUDAG+gr0frEbbVGg
         HuxHgRz7EwlJa2nUu1Q6PtDA3V31tXWJ3CXto=
From: "Cho, Yu-Chen" <acho@novell.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, segooon@gmail.com, huajun.li.lee@gmail.com,
        kkatuev@gmail.com, jj@chaosbits.net, imirkin@alum.mit.edu,
        devel@driverdev.osuosl.org, jlee@novell.com, acho@novell.com
Subject: [PATCH 7/7] staging/keucr : fix transport other code style
Date: Wed, 18 May 2011 18:40:15 +0800
Message-Id: <2282da69f10c9ce719ce08d17cbd10c047e1b028.1305714525.git.acho@novell.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1305714525.git.acho@novell.com>
References: <cover.1305714525.git.acho@novell.com>
In-Reply-To: <cover.1305714525.git.acho@novell.com>
References: <cover.1305714525.git.acho@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix keucr transport.c other coding style but not from checkpatch.pl.
replace ternary conditional "?:" with if/else

Signed-off-by: Cho, Yu-Chen <acho@novell.com>
---
 drivers/staging/keucr/transport.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/keucr/transport.c b/drivers/staging/keucr/transport.c
index d48f592..0274cb0 100644
--- a/drivers/staging/keucr/transport.c
+++ b/drivers/staging/keucr/transport.c
@@ -629,8 +629,12 @@ int usb_stor_Bulk_transport(struct scsi_cmnd *srb, struct us_data *us)
 
 	/*  R/W data */
 	if (transfer_length) {
-		unsigned int pipe = srb->sc_data_direction ==
-		DMA_FROM_DEVICE ? us->recv_bulk_pipe : us->send_bulk_pipe;
+		unsigned int pipe;
+		if (srb->sc_data_direction == DMA_FROM_DEVICE)
+			pipe = us->recv_bulk_pipe;
+		else
+			pipe = us->send_bulk_pipe;
+
 		result = usb_stor_bulk_srb(us, pipe, srb);
 		/* pr_info("Bulk data transfer result 0x%x\n", result); */
 		if (result == USB_STOR_XFER_ERROR)
-- 
1.7.1

