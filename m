Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933213Ab0HLAO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:14:29 -0400
Received: from kroah.org ([198.145.64.141]:47869 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933158Ab0HLAIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:08:34 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:06:16 2010
Message-Id: <20100812000616.181969463@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:05:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: [38/67] drbd: Disable delay probes for the upcomming release
In-Reply-To: <20100812000641.GA6348@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Philipp Reisner <philipp.reisner@linbit.com>

commit 6710a5760355be8f2e51682f41b0d3fc76550309 upstream.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/block/drbd/drbd_main.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2371,11 +2371,7 @@ static int _drbd_send_zc_ee(struct drbd_
 
 static void consider_delay_probes(struct drbd_conf *mdev)
 {
-	if (mdev->state.conn != C_SYNC_SOURCE || mdev->agreed_pro_version < 93)
-		return;
-
-	if (mdev->dp_volume_last + mdev->sync_conf.dp_volume * 2 < mdev->send_cnt)
-		drbd_send_delay_probes(mdev);
+	return;
 }
 
 static int w_delay_probes(struct drbd_conf *mdev, struct drbd_work *w, int cancel)


