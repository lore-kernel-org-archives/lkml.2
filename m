Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746Ab1HNQGN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:06:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36280 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753650Ab1HNQGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:06:07 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:52 2011
Message-Id: <20110812210552.901413143@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:03:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Ivo van Doorn <IvDoorn@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [09/90] rt2x00: rt2800: fix zeroing skb structure
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit b52398b6e4522176dd125722c72c301015d24520 upstream.

We should clear skb->data not skb itself. Bug was introduced by:
commit 0b8004aa12d13ec750d102ba4082a95f0107c649 "rt2x00: Properly
reserve room for descriptors in skbs".

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/rt2x00/rt2800lib.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -784,8 +784,7 @@ void rt2800_write_beacon(struct queue_en
 	/*
 	 * Add space for the TXWI in front of the skb.
 	 */
-	skb_push(entry->skb, TXWI_DESC_SIZE);
-	memset(entry->skb, 0, TXWI_DESC_SIZE);
+	memset(skb_push(entry->skb, TXWI_DESC_SIZE), 0, TXWI_DESC_SIZE);
 
 	/*
 	 * Register descriptor details in skb frame descriptor.


