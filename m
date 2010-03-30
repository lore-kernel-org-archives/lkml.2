Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab0C3Qme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 12:42:34 -0400
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:43974 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab0C3Qmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 12:42:32 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4BB22A90.6070801@cam.ac.uk>
Date: Tue, 30 Mar 2010 17:45:04 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] Fix staging:iio:ring_sw: Fix incorrect test on successful
 read of last value, causes infinite loop
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---

 This is a bad one. The test means that almost no reads of the last
 value ever succeed!  Result is an infinite loop.

 Another one for the 'oops' category.

 Patch is post the spin lock fix:
 [PATCH] Staging: IIO: Fix uses of spinlocks prior to init in ring implementations


 drivers/staging/iio/ring_sw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/iio/ring_sw.c b/drivers/staging/iio/ring_sw.c
index 7dff2bf..5abba8c 100644
--- a/drivers/staging/iio/ring_sw.c
+++ b/drivers/staging/iio/ring_sw.c
@@ -296,7 +296,7 @@ again:
 		return -EAGAIN;
 	memcpy(data, last_written_p_copy, ring->buf.bpd);
 
-	if (unlikely(ring->last_written_p >= last_written_p_copy))
+	if (unlikely(ring->last_written_p != last_written_p_copy))
 		goto again;
 
 	iio_unmark_sw_rb_in_use(&ring->buf);
-- 
1.6.4.4

