Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172Ab1LSAXb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 19:23:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42338 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010Ab1LSAX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 19:23:28 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 19 Dec 2011 11:20:22 +1100
Subject: [PATCH 2/2] leds-tca6507 - fix off by one error.
Cc: rpurdie@rpsys.net, linux-kernel@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Message-ID: <20111219002022.23170.29061.stgit@notabene.brown>
In-Reply-To: <20111219001806.23170.14518.stgit@notabene.brown>
References: <20111219001806.23170.14518.stgit@notabene.brown>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When walking the list of possible time codes we can fall off the end.
Fix that, and also improved the commentary.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/leds/leds-tca6507.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/leds-tca6507.c b/drivers/leds/leds-tca6507.c
index c9cc3f7..75dc5e4 100644
--- a/drivers/leds/leds-tca6507.c
+++ b/drivers/leds/leds-tca6507.c
@@ -165,7 +165,8 @@ MODULE_DEVICE_TABLE(i2c, tca6507);
 static int choose_times(int msec, int *c1p, int *c2p)
 {
 	/* Chose two timecodes which add to 'msec' as near as possible.
-	 * The first returned should be the larger.
+	 * The first returned should be the larger and is the 'on' of 'off' time.
+	 * The second will be used as a 'fade-on' or 'fade-off' time.
 	 * If cannot get within 1/8, fail.
 	 * If two possibilities are equally good (e.g. 512+0, 256+256), choose
 	 * the first pair so there is more change-time visible (i.e. it is softer).
@@ -175,7 +176,10 @@ static int choose_times(int msec, int *c1p, int *c2p)
 	int tmin = msec * 7 / 8;
 	int diff = 65536;
 
-	for (c1 = 1; c1 <= TIMECODES; c1++) {
+	/* We start at '1' to ensure we never even think of choosing a
+	 * total time of '0'.
+	 */
+	for (c1 = 1; c1 < TIMECODES; c1++) {
 		int t = time_codes[c1];
 		if (t*2 < tmin)
 			continue;


