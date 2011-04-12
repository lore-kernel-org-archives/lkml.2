Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498Ab1DLOrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:47:00 -0400
Received: from kroah.org ([198.145.64.141]:57639 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932327Ab1DLOib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:38:31 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:55 2011
Message-Id: <20110412143555.356021526@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:34:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Ivo van Doorn <IvDoorn@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [069/105] rt2x00: fix cancelling uninitialized work
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 37f4ee0b6b39640828dac5937a482c20e8ac794f upstream.

{rx,tx}done_work's are only initialized for usb devices.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1031,8 +1031,10 @@ void rt2x00lib_remove_dev(struct rt2x00_
 	 * Stop all work.
 	 */
 	cancel_work_sync(&rt2x00dev->intf_work);
-	cancel_work_sync(&rt2x00dev->rxdone_work);
-	cancel_work_sync(&rt2x00dev->txdone_work);
+	if (rt2x00_is_usb(rt2x00dev)) {
+		cancel_work_sync(&rt2x00dev->rxdone_work);
+		cancel_work_sync(&rt2x00dev->txdone_work);
+	}
 
 	/*
 	 * Free the tx status fifo.


