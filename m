Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab1KCCWL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 22:22:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50241 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754499Ab1KCBcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:32:20 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:51 2011
Message-Id: <20111102221451.194182696@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:13:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Marek Marczykowski <marmarek@mimuw.edu.pl>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [012/107] xen-blkfront: fix data size for xenbus_gather in blkfront_connect
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Marek Marczykowski <marmarek@mimuw.edu.pl>

commit 4352b47ab7918108b389a48d2163c9a4c2aaf139 upstream.

barrier variable is int, not long. This overflow caused another variable
override: "err" (in PV code) and "binfo" (in xenlinux code -
drivers/xen/blkfront/blkfront.c). The later caused incorrect device
flags (RO/removable etc).

Signed-off-by: Marek Marczykowski <marmarek@mimuw.edu.pl>
Acked-by: Ian Campbell <Ian.Campbell@citrix.com>
[v1: Changed title]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/block/xen-blkfront.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -889,7 +889,7 @@ static void blkfront_connect(struct blkf
 	}
 
 	err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
-			    "feature-barrier", "%lu", &info->feature_barrier,
+			    "feature-barrier", "%d", &info->feature_barrier,
 			    NULL);
 	if (err)
 		info->feature_barrier = 0;


