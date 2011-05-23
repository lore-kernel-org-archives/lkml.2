Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934097Ab1EWUEw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 16:04:52 -0400
Received: from mailfe04.c2i.net ([212.247.154.98]:44888 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934065Ab1EWUEs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 16:04:48 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 May 2011 16:04:48 EDT
X-Cloudmark-Score: 0.000000 []
X-Cloudmark-Analysis: v=1.1 cv=wd7fLirDSts22yawIUsTeMUS9lsm8Llc0grT6RvpTjU= c=1 sm=1 a=SvYTsOw2Z4kA:10 a=0ITRkXdWOPwA:10 a=WQU8e4WWZSUA:10 a=kj9zAlcOel0A:10 a=CL8lFSKtTFcA:10 a=i9M/sDlu2rpZ9XS819oYzg==:17 a=8kQB0OdkAAAA:8 a=Ge1dfN6ZZMybT1CZK3IA:9 a=CjuIK1q_8ugA:10 a=9aOQ2cSd83gA:10 a=i9M/sDlu2rpZ9XS819oYzg==:117
From: Hans Petter Selasky <hselasky@c2i.net>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Properly assign return value of clamp() macro.
Date: Mon, 23 May 2011 21:58:34 +0200
User-Agent: KMail/1.13.5 (FreeBSD/8.2-STABLE; KDE/4.4.5; amd64; ; )
X-Face: *nPdTl_}RuAI6^PVpA02T?$%Xa^>@hE0uyUIoiha$pC:9TVgl.Oq,NwSZ4V"|LR.+tj}g5
	%V,x^qOs~mnU3]Gn;cQLv&.N>TrxmSFf+p6(30a/{)KUU!s}w\IhQBj}[g}bj0I3^glmC(
	:AuzV9:.hESm-x4h240C`9=w
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105232158.34929.hselasky@c2i.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2b7fc579e802357b7b0742bf6bbbabdaf9e40c1e Mon Sep 17 00:00:00 2001
From: Hans Petter Selasky <hselasky@c2i.net>
Date: Mon, 23 May 2011 21:54:42 +0200
Subject: [PATCH] Properly assign return value of clamp() macro.

Signed-off-by: Hans Petter Selasky <hselasky@c2i.net>
---
 drivers/input/input.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index ebbceed..e3c88fc 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -1757,7 +1757,7 @@ static unsigned int 
input_estimate_events_per_packet(struct input_dev *dev)
 	} else if (test_bit(ABS_MT_TRACKING_ID, dev->absbit)) {
 		mt_slots = dev->absinfo[ABS_MT_TRACKING_ID].maximum -
 			   dev->absinfo[ABS_MT_TRACKING_ID].minimum + 1,
-		clamp(mt_slots, 2, 32);
+		mt_slots = clamp(mt_slots, 2, 32);
 	} else if (test_bit(ABS_MT_POSITION_X, dev->absbit)) {
 		mt_slots = 2;
 	} else {
-- 
1.7.1.1

