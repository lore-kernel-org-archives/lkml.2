Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab1GHFEY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:04:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42347 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754567Ab1GHFEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:04:21 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:59 2011
Message-Id: <20110708001659.762014700@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:16:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hans Petter Selasky <hselasky@c2i.net>, Dmitry Torokhov <dtor@mail.ru>
Subject: [072/107] Input: properly assign return value of clamp() macro.
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hans Petter Selasky <hselasky@c2i.net>

commit 8c127f0717b438e6abc3d92d4ae248c4224b9dcb upstream.

[dtor@mail.ru: added mousedev changes]
Signed-off-by: Hans Petter Selasky <hselasky@c2i.net>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/input.c    |    2 +-
 drivers/input/mousedev.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -1757,7 +1757,7 @@ static unsigned int input_estimate_event
 	} else if (test_bit(ABS_MT_TRACKING_ID, dev->absbit)) {
 		mt_slots = dev->absinfo[ABS_MT_TRACKING_ID].maximum -
 			   dev->absinfo[ABS_MT_TRACKING_ID].minimum + 1,
-		clamp(mt_slots, 2, 32);
+		mt_slots = clamp(mt_slots, 2, 32);
 	} else if (test_bit(ABS_MT_POSITION_X, dev->absbit)) {
 		mt_slots = 2;
 	} else {
--- a/drivers/input/mousedev.c
+++ b/drivers/input/mousedev.c
@@ -187,7 +187,7 @@ static void mousedev_abs_event(struct in
 		if (size == 0)
 			size = xres ? : 1;
 
-		clamp(value, min, max);
+		value = clamp(value, min, max);
 
 		mousedev->packet.x = ((value - min) * xres) / size;
 		mousedev->packet.abs_event = 1;
@@ -201,7 +201,7 @@ static void mousedev_abs_event(struct in
 		if (size == 0)
 			size = yres ? : 1;
 
-		clamp(value, min, max);
+		value = clamp(value, min, max);
 
 		mousedev->packet.y = yres - ((value - min) * yres) / size;
 		mousedev->packet.abs_event = 1;


