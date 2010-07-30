Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760246Ab0G3Se2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:34:28 -0400
Received: from kroah.org ([198.145.64.141]:58048 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759828Ab0G3Ryu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:54:50 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:37 2010
Message-Id: <20100730175137.555871502@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:51:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dave Airlie <airlied@redhat.com>
Subject: [044/205] fb: fix colliding defines for fb flags.
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit b26c949755c06ec79e55a75817210083bd78fc9a upstream.

When I added the flags I must have been using a 25 line terminal and missed the following flags.

The collided with flag has one user in staging despite being in-tree for 5 years.

I'm happy to push this via my drm tree unless someone really wants to do it.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/fb.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -787,8 +787,6 @@ struct fb_tile_ops {
 #define FBINFO_MISC_USEREVENT          0x10000 /* event request
 						  from userspace */
 #define FBINFO_MISC_TILEBLITTING       0x20000 /* use tile blitting */
-#define FBINFO_MISC_FIRMWARE           0x40000 /* a replaceable firmware
-						  inited framebuffer */
 
 /* A driver may set this flag to indicate that it does want a set_par to be
  * called every time when fbcon_switch is executed. The advantage is that with
@@ -802,6 +800,8 @@ struct fb_tile_ops {
  */
 #define FBINFO_MISC_ALWAYS_SETPAR   0x40000
 
+/* where the fb is a firmware driver, and can be replaced with a proper one */
+#define FBINFO_MISC_FIRMWARE        0x80000
 /*
  * Host and GPU endianness differ.
  */


