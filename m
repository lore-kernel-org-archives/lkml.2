Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab0IXQxm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:53:42 -0400
Received: from kroah.org ([198.145.64.141]:38364 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932681Ab0IXQ22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:28:28 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:18 2010
Message-Id: <20100924162618.446483373@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:24:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        Thomas Winischhofer <thomas@winischhofer.net>
Subject: [41/80] drivers/video/sis/sis_main.c: prevent reading uninitialized stack memory
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Rosenberg <drosenberg@vsecurity.com>

commit fd02db9de73faebc51240619c7c7f99bee9f65c7 upstream.

The FBIOGET_VBLANK device ioctl allows unprivileged users to read 16 bytes
of uninitialized stack memory, because the "reserved" member of the
fb_vblank struct declared on the stack is not altered or zeroed before
being copied back to the user.  This patch takes care of it.

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/video/sis/sis_main.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/video/sis/sis_main.c
+++ b/drivers/video/sis/sis_main.c
@@ -1701,6 +1701,9 @@ static int	sisfb_ioctl(struct fb_info *i
 		break;
 
 	   case FBIOGET_VBLANK:
+
+		memset(&sisvbblank, 0, sizeof(struct fb_vblank));
+
 		sisvbblank.count = 0;
 		sisvbblank.flags = sisfb_setupvbblankflags(ivideo, &sisvbblank.vcount, &sisvbblank.hcount);
 


