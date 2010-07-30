Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760217Ab0G3SVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:21:44 -0400
Received: from kroah.org ([198.145.64.141]:58728 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759751Ab0G3R40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:56:26 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:44 2010
Message-Id: <20100730175143.997793284@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:52:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dmitry Torokhov <dtor@mail.ru>
Subject: [111/205] Input: gamecon - reference correct pad in gc_psx_command()
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit c25f7b763cc35a249232ce612a36a811b0e263f9 upstream.

Otherwise we won't see any events from the gamepad.
Addresses https://bugzilla.kernel.org/show_bug.cgi?id=16408

Reported-and-tested-by: Eugene Yudin <eugene.yudin@gmail.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/joystick/gamecon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/joystick/gamecon.c
+++ b/drivers/input/joystick/gamecon.c
@@ -578,7 +578,7 @@ static void gc_psx_command(struct gc *gc
 		read = parport_read_status(port) ^ 0x80;
 
 		for (j = 0; j < GC_MAX_DEVICES; j++) {
-			struct gc_pad *pad = &gc->pads[i];
+			struct gc_pad *pad = &gc->pads[j];
 
 			if (pad->type == GC_PSX || pad->type == GC_DDR)
 				data[j] |= (read & gc_status_bit[j]) ? (1 << i) : 0;


