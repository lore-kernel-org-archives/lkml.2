Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932835Ab1FWRWs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:22:48 -0400
Received: from mail.windriver.com ([147.11.1.11]:63254 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932760Ab1FWRWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:22:45 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 030/247] ath9k: Fix bug in delimiter padding computation
Date: Thu, 23 Jun 2011 13:17:53 -0400
Message-Id: <1308849690-14530-31-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 39ec2997c374b528cdbf65099b6d6b8593a67f7f upstream.

There is a roundng error in delimiter padding computation
which causes severe throughput drop with some of AR9003.

signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 83c7ea4..7f36731 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -172,8 +172,8 @@ void ath_descdma_cleanup(struct ath_softc *sc, struct ath_descdma *dd,
 
 /* returns delimiter padding required given the packet length */
 #define ATH_AGGR_GET_NDELIM(_len)					\
-	(((((_len) + ATH_AGGR_DELIM_SZ) < ATH_AGGR_MINPLEN) ?           \
-	  (ATH_AGGR_MINPLEN - (_len) - ATH_AGGR_DELIM_SZ) : 0) >> 2)
+       (((_len) >= ATH_AGGR_MINPLEN) ? 0 :                             \
+        DIV_ROUND_UP(ATH_AGGR_MINPLEN - (_len), ATH_AGGR_DELIM_SZ))
 
 #define BAW_WITHIN(_start, _bawsz, _seqno) \
 	((((_seqno) - (_start)) & 4095) < (_bawsz))
-- 
1.7.4.4

