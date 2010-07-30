Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932724Ab0G3SVv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:21:51 -0400
Received: from kroah.org ([198.145.64.141]:58718 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759762Ab0G3R4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:56:25 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:43 2010
Message-Id: <20100730175143.888499488@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:52:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dmitry Torokhov <dtor@mail.ru>
Subject: [110/205] Input: gamecon - reference correct input device in NES mode
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 7b5d3312fbfbb21d2fc7de94e0db66cfdf8b0055 upstream.

We moved input devices from 'struct gc' to individial pads (struct
gc-pad), but gc_nes_process_packet() was still trying to use old
ones and crashing.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/joystick/gamecon.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/input/joystick/gamecon.c
+++ b/drivers/input/joystick/gamecon.c
@@ -89,7 +89,6 @@ struct gc_pad {
 struct gc {
 	struct pardevice *pd;
 	struct gc_pad pads[GC_MAX_DEVICES];
-	struct input_dev *dev[GC_MAX_DEVICES];
 	struct timer_list timer;
 	int pad_count[GC_MAX];
 	int used;
@@ -387,7 +386,7 @@ static void gc_nes_process_packet(struct
 	for (i = 0; i < GC_MAX_DEVICES; i++) {
 
 		pad = &gc->pads[i];
-		dev = gc->dev[i];
+		dev = pad->dev;
 		s = gc_status_bit[i];
 
 		switch (pad->type) {


