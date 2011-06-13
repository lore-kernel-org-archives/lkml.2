Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab1FMSjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 14:39:45 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:46676 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108Ab1FMSjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 14:39:39 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 2/8] scsi/mac: macscsi_detect() should be __init
Date: Mon, 13 Jun 2011 20:39:16 +0200
Message-Id: <1307990362-22768-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1307990362-22768-1-git-send-email-geert@linux-m68k.org>
References: <1307990362-22768-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: vmlinux.o(.text+0x1ecd3e): Section mismatch in reference from the function macscsi_detect() to the function .devinit.text:NCR5380_init()
WARNING: vmlinux.o(.text+0x1ecddc): Section mismatch in reference from the function macscsi_detect() to the function .init.text:NCR5380_print_options()
WARNING: vmlinux.o(.text+0x1ece60): Section mismatch in reference from the function macscsi_detect() to the function .init.text:NCR5380_print_options()

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/mac_scsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
index bf2a1c5..67eb758 100644
--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -233,7 +233,7 @@ static struct Scsi_Host *default_instance;
  *
  */
  
-int macscsi_detect(struct scsi_host_template * tpnt)
+int __init macscsi_detect(struct scsi_host_template * tpnt)
 {
     static int called = 0;
     int flags = 0;
-- 
1.7.0.4

