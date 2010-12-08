Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683Ab0LHAgY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:36:24 -0500
Received: from kroah.org ([198.145.64.141]:54918 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755528Ab0LHAe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:34:56 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:06:43 2010
Message-Id: <20101208000643.725317786@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:04:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        Andy Walls <awalls@md.metrocast.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [41/44] V4L/DVB: ivtvfb: prevent reading uninitialized stack memory
In-Reply-To: <20101208003205.GA4286@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Rosenberg <drosenberg@vsecurity.com>

commit 405707985594169cfd0b1d97d29fcb4b4c6f2ac9 upstream.

The FBIOGET_VBLANK device ioctl allows unprivileged users to read 16
bytes of uninitialized stack memory, because the "reserved" member of
the fb_vblank struct declared on the stack is not altered or zeroed
before being copied back to the user.  This patch takes care of it.

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Signed-off-by: Andy Walls <awalls@md.metrocast.net>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/ivtv/ivtvfb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/video/ivtv/ivtvfb.c
+++ b/drivers/media/video/ivtv/ivtvfb.c
@@ -460,6 +460,8 @@ static int ivtvfb_ioctl(struct fb_info *
 			struct fb_vblank vblank;
 			u32 trace;
 
+			memset(&vblank, 0, sizeof(struct fb_vblank));
+
 			vblank.flags = FB_VBLANK_HAVE_COUNT |FB_VBLANK_HAVE_VCOUNT |
 					FB_VBLANK_HAVE_VSYNC;
 			trace = read_reg(0x028c0) >> 16;


