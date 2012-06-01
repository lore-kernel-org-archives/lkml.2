Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965501Ab2FAQWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 12:22:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965407Ab2FAQWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 12:22:43 -0400
Message-ID: <4FC8EC51.5040200@redhat.com>
Date: Fri, 01 Jun 2012 17:22:41 +0100
From: "Bryn M. Reeves" <bmr@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Silence noisy per-disk messages output by cciss_read_capacity_16
X-Enigmail-Version: 1.4
Content-Type: multipart/mixed;
 boundary="------------000308070106000603060402"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000308070106000603060402
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This patch mirrors the change made to cciss_read_capacity in commit
983333c. Emitting device and block size information at KERN_INFO on
each read_capacity() leads to a lot of log noise.

Signed-off-by: Bryn M. Reeves <bmr@redhat.com>


--------------000308070106000603060402
Content-Type: text/x-patch;
 name="0001-Silence-noisy-per-disk-messages-output-by-cciss_read.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Silence-noisy-per-disk-messages-output-by-cciss_read.pa";
 filename*1="tch"

>From 92d39715bdbe8c3c12aa0fe6b04237fe56f47c68 Mon Sep 17 00:00:00 2001
From: "Bryn M. Reeves" <bmr@errorists.org>
Date: Fri, 1 Jun 2012 17:11:24 +0100
Subject: [PATCH] Silence noisy per-disk messages output by
 cciss_read_capacity_16

This patch mirrors the change made to cciss_read_capacity in commit
983333c. Emitting device and block size information at KERN_INFO on
each read_capacity() leads to a lot of log noise.

Signed-off-by: Bryn M. Reeves <bmr@redhat.com>
---
 drivers/block/cciss.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index b0f553b..ea6853d 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -2934,8 +2934,6 @@ static void cciss_read_capacity_16(ctlr_info_t *h, int logvol,
 		*total_size = 0;
 		*block_size = BLOCK_SIZE;
 	}
-	dev_info(&h->pdev->dev, "      blocks= %llu block_size= %d\n",
-	       (unsigned long long)*total_size+1, *block_size);
 	kfree(buf);
 }
 
-- 
1.7.6.5


--------------000308070106000603060402--
