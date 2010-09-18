Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704Ab0IRTO4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:14:56 -0400
Received: from kroah.org ([198.145.64.141]:43247 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755943Ab0IRTOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:14:54 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:12:59 2010
Message-Id: <20100918191259.143427215@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:12:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dmitry Torokhov <dtor@mail.ru>
Subject: [022/129] Revert "Input: appletouch - fix integer overflow issue"
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit 6e49c1a407c8af8d779a24fd2428857991514a7b upstream.

This reverts commit 04b4b88cca0ebe3813b4b6f014fb6a0db380b137.

While the original problem only caused a slight disturbance on the
edge of the touchpad, the commit above to "fix" it completely breaks
operation on some other models such as mine.

We'll sort this out separately, revert the patch for now.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/mouse/appletouch.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/input/mouse/appletouch.c
+++ b/drivers/input/mouse/appletouch.c
@@ -205,8 +205,8 @@ struct atp {
 	bool			overflow_warned;
 	int			x_old;		/* last reported x/y, */
 	int			y_old;		/* used for smoothing */
-	u8			xy_cur[ATP_XSENSORS + ATP_YSENSORS];
-	u8			xy_old[ATP_XSENSORS + ATP_YSENSORS];
+	signed char		xy_cur[ATP_XSENSORS + ATP_YSENSORS];
+	signed char		xy_old[ATP_XSENSORS + ATP_YSENSORS];
 	int			xy_acc[ATP_XSENSORS + ATP_YSENSORS];
 	int			idlecount;	/* number of empty packets */
 	struct work_struct	work;
@@ -531,7 +531,7 @@ static void atp_complete_geyser_1_2(stru
 
 	for (i = 0; i < ATP_XSENSORS + ATP_YSENSORS; i++) {
 		/* accumulate the change */
-		int change = dev->xy_old[i] - dev->xy_cur[i];
+		signed char change = dev->xy_old[i] - dev->xy_cur[i];
 		dev->xy_acc[i] -= change;
 
 		/* prevent down drifting */


