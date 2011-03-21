Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab1CUXyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:54:13 -0400
Received: from kroah.org ([198.145.64.141]:49221 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755256Ab1CUXPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:15:02 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:07:09 2011
Message-Id: <20110321230709.686711669@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:06:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [05/87] mtd: mtd_blkdevs: fix double free on error path
In-Reply-To: <20110321230732.GA26510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Maxim Levitsky <maximlevitsky@gmail.com>

commit bd637f6f22235b4613f9ab6555e8088a455c1ed4 upstream.

This one liner patch fixes double free that will occur if add_mtd_blktrans_dev
fails. On failure it frees the input argument, but all its users also free it
on error which is natural thing to do. Thus don't free it.

All credit for finding that bug belongs to reporters of the bug in the android bugzilla
http://code.google.com/p/android/issues/detail?id=13761

Commit message tweaked by Artem.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mtd/mtd_blkdevs.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -413,7 +413,6 @@ error3:
 error2:
 	list_del(&new->list);
 error1:
-	kfree(new);
 	return ret;
 }
 


