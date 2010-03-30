Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab0C3XJe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:09:34 -0400
Received: from kroah.org ([198.145.64.141]:48602 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972Ab0C3XJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:09:20 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:50:05 2010
Message-Id: <20100330225004.469667001@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:48:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Francesco Lavra <francescolavra@interfree.it>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [37/45] V4L/DVB (13961): em28xx-dvb: fix memleak in dvb_fini()
In-Reply-To: <20100330230410.GA28712@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Francesco Lavra <francescolavra@interfree.it>

commit 19f48cb105b7fa18d0dcab435919a3a29b7a7c4c upstream.

this patch fixes a memory leak which occurs when an em28xx card with DVB
extension is unplugged or its DVB extension driver is unloaded. In
dvb_fini(), dev->dvb must be freed before being set to NULL, as is done
in dvb_init() in case of error.
Note that this bug is also present in the latest stable kernel release.

Signed-off-by: Francesco Lavra <francescolavra@interfree.it>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/em28xx/em28xx-dvb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/video/em28xx/em28xx-dvb.c
+++ b/drivers/media/video/em28xx/em28xx-dvb.c
@@ -501,6 +501,7 @@ static int dvb_fini(struct em28xx *dev)
 
 	if (dev->dvb) {
 		unregister_dvb(dev->dvb);
+		kfree(dev->dvb);
 		dev->dvb = NULL;
 	}
 


