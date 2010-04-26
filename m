Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab0DZT2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 15:28:51 -0400
Received: from ppsw-33.csi.cam.ac.uk ([131.111.8.133]:51646 "EHLO
	ppsw-33.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775Ab0DZT2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 15:28:34 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: iio-linux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
       Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 17/19] staging:iio:ring_sw: Fix incorrect test on successful read of last value, causes infinite loop
Date: Mon, 26 Apr 2010 20:31:19 +0100
Message-Id: <1272310281-7418-18-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1272310281-7418-17-git-send-email-jic23@cam.ac.uk>
References: <1272310281-7418-1-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-2-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-3-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-4-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-5-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-6-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-7-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-8-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-9-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-10-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-11-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-12-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-13-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-14-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-15-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-16-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-17-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/staging/iio/ring_sw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/iio/ring_sw.c b/drivers/staging/iio/ring_sw.c
index 4e5134c..8d2f7cd 100644
--- a/drivers/staging/iio/ring_sw.c
+++ b/drivers/staging/iio/ring_sw.c
@@ -297,7 +297,7 @@ again:
 		return -EAGAIN;
 	memcpy(data, last_written_p_copy, ring->buf.bpd);
 
-	if (unlikely(ring->last_written_p >= last_written_p_copy))
+	if (unlikely(ring->last_written_p != last_written_p_copy))
 		goto again;
 
 	iio_unmark_sw_rb_in_use(&ring->buf);
-- 
1.6.4.4

