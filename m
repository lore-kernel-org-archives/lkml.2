Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab1BPBn3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:43:29 -0500
Received: from kroah.org ([198.145.64.141]:38886 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756890Ab1BPATg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:19:36 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:31 2011
Message-Id: <20110216001431.031696860@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:11:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Felix Fietkau <nbd@openwrt.org>,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [059/272] ath9k: Fix bug in delimiter padding computation
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

commit 39ec2997c374b528cdbf65099b6d6b8593a67f7f upstream.

There is a roundng error in delimiter padding computation
which causes severe throughput drop with some of AR9003.

signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/ath9k.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -178,8 +178,8 @@ void ath_descdma_cleanup(struct ath_soft
 
 /* returns delimiter padding required given the packet length */
 #define ATH_AGGR_GET_NDELIM(_len)					\
-	(((((_len) + ATH_AGGR_DELIM_SZ) < ATH_AGGR_MINPLEN) ?           \
-	  (ATH_AGGR_MINPLEN - (_len) - ATH_AGGR_DELIM_SZ) : 0) >> 2)
+       (((_len) >= ATH_AGGR_MINPLEN) ? 0 :                             \
+        DIV_ROUND_UP(ATH_AGGR_MINPLEN - (_len), ATH_AGGR_DELIM_SZ))
 
 #define BAW_WITHIN(_start, _bawsz, _seqno) \
 	((((_seqno) - (_start)) & 4095) < (_bawsz))


