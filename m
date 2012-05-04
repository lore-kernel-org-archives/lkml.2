Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932676Ab2EDUrq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:47:46 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:61380 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932656Ab2EDUrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:47:39 -0400
Message-Id: <20120504204230.424224741@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:43:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Grazvydas Ignotas <notasas@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 71/75] wl1251: fix crash on remove due to leftover work item
In-Reply-To: <20120504204258.GA12552@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Grazvydas Ignotas <notasas@gmail.com>

commit 4c1bcdb5a3354b250b82a67549f57ac27a3bb85f upstream.

This driver currently leaves elp_work behind when stopping, which
occasionally results in data corruption because work function ends
up accessing freed memory, typical symptoms of this are various
worker_thread crashes. Fix it by cancelling elp_work.

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/wl1251/main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/wl1251/main.c
+++ b/drivers/net/wireless/wl1251/main.c
@@ -479,6 +479,7 @@ static void wl1251_op_stop(struct ieee80
 	cancel_work_sync(&wl->irq_work);
 	cancel_work_sync(&wl->tx_work);
 	cancel_work_sync(&wl->filter_work);
+	cancel_delayed_work_sync(&wl->elp_work);
 
 	mutex_lock(&wl->mutex);
 


