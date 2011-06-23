Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934328Ab1FWS3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:29:38 -0400
Received: from mail.windriver.com ([147.11.1.11]:63006 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932622Ab1FWRWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:22:16 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 018/247] USB: io_edgeport: fix the reported firmware major and minor
Date: Thu, 23 Jun 2011 13:17:41 -0400
Message-Id: <1308849690-14530-19-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjørn Mork <bjorn@mork.no>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 271c1150b4f8e1685e5a8cbf76e329ec894481da upstream.

The major and minor number saved in the product_info structure
were copied from the address instead of the data, causing an
inconsistency in the reported versions during firmware loading:

 usb 4-1: firmware: requesting edgeport/down.fw
 /usr/src/linux/drivers/usb/serial/io_edgeport.c: downloading firmware version (930) 1.16.4
 [..]
 /usr/src/linux/drivers/usb/serial/io_edgeport.c: edge_startup - time 3 4328191260
 /usr/src/linux/drivers/usb/serial/io_edgeport.c:   FirmwareMajorVersion  0.0.4

This can cause some confusion whether firmware loaded successfully
or not.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/io_edgeport.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/io_edgeport.c b/drivers/usb/serial/io_edgeport.c
index 3ef8df0..ac3f4c3 100644
--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -2894,8 +2894,8 @@ static void load_application_firmware(struct edgeport_serial *edge_serial)
 
 	dbg("%s %d.%d.%d", fw_info, rec->data[0], rec->data[1], build);
 
-	edge_serial->product_info.FirmwareMajorVersion = fw->data[0];
-	edge_serial->product_info.FirmwareMinorVersion = fw->data[1];
+	edge_serial->product_info.FirmwareMajorVersion = rec->data[0];
+	edge_serial->product_info.FirmwareMinorVersion = rec->data[1];
 	edge_serial->product_info.FirmwareBuildNumber = cpu_to_le16(build);
 
 	for (rec = ihex_next_binrec(rec); rec;
-- 
1.7.4.4

