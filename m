Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab2BQBHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 20:07:48 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:44516 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756299Ab2BQA7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 19:59:39 -0500
X-Sasl-enc: y04E2doSJ1wpjv71NcXnQe5hXWkUHECQrTX6fsg4WDnt 1329440378
X-Mailbox-Line: From gregkh@linuxfoundation.org Thu Feb 16 16:55:10 2012
Message-Id: <20120217005510.862619400@linuxfoundation.org>
User-Agent: quilt/0.51-15.1
Date: Thu, 16 Feb 2012 16:55:16 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eliad Peller <eliad@wizery.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [07/15] mac80211: timeout a single frame in the rx reorder buffer
In-Reply-To: <20120217005650.GA17119@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eliad Peller <eliad@wizery.com>

commit 07ae2dfcf4f7143ce191c6436da1c33f179af0d6 upstream.

The current code checks for stored_mpdu_num > 1, causing
the reorder_timer to be triggered indefinitely, but the
frame is never timed-out (until the next packet is received)

Signed-off-by: Eliad Peller <eliad@wizery.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -610,7 +610,7 @@ static void ieee80211_sta_reorder_releas
 	index = seq_sub(tid_agg_rx->head_seq_num, tid_agg_rx->ssn) %
 						tid_agg_rx->buf_size;
 	if (!tid_agg_rx->reorder_buf[index] &&
-	    tid_agg_rx->stored_mpdu_num > 1) {
+	    tid_agg_rx->stored_mpdu_num) {
 		/*
 		 * No buffers ready to be released, but check whether any
 		 * frames in the reorder buffer have timed out.


