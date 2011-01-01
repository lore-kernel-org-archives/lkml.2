Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389Ab1AAPg1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jan 2011 10:36:27 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63732 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab1AAPg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jan 2011 10:36:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=OrQlSo7mE+Gg7XLVXnqQ0iZgV1ADHRf3308uKM7cmUu8wU9Pp6L+qOyPMAkYldMy5K
         X79qIu+Uy/UvA5CQiqQknPzY/1dsyQHoObu0fj6RAg74hsvIZ0gEuU6NELyJJJad2HDE
         I7W4FeO+PcaPqmI1j3ad1DjvLVPT6aF5NIl3M=
Message-ID: <4D1F49F7.7010401@gmail.com>
Date: Sat, 01 Jan 2011 16:36:23 +0100
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, mchehab@redhat.com
Subject: [PATCH] V4L/DVB: &&/|| confusion in medusa_set_decoderduration()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since VDEC_A is defined less than VDEC_H the if-branch was always taken.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/staging/cx25821/cx25821-medusa-video.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

See drivers/staging/cx25821/cx25821-medusa-defines.h:27 for VDEC_* definitions:
#define VDEC_A		0
...
#define VDEC_H		7

diff --git a/drivers/staging/cx25821/cx25821-medusa-video.c b/drivers/staging/cx25821/cx25821-medusa-video.c
index 1e11e0c..00fb56f 100644
--- a/drivers/staging/cx25821/cx25821-medusa-video.c
+++ b/drivers/staging/cx25821/cx25821-medusa-video.c
@@ -564,7 +564,7 @@ static void medusa_set_decoderduration(struct cx25821_dev *dev, int decoder,
 	mutex_lock(&dev->lock);
 
 	/* no support */
-	if (decoder < VDEC_A && decoder > VDEC_H) {
+	if (decoder < VDEC_A || decoder > VDEC_H) {
 		mutex_unlock(&dev->lock);
 		return;
 	}
