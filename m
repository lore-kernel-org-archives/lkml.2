Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab0F0NV5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 09:21:57 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47857 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157Ab0F0NVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 09:21:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BoSkNyV136ou3HlkLJXrTX6sbNdU8meJL2U0w9cg5o9r72wXtw77yvc+SpzB32kIQ4
         q3XG3AtyVbfk8f5D/scJ0VKimgwRhMXiimW7fzxfwC/so6tObgL1FcnrAaLPzTNvyjxU
         0Ta5y3Fm/FUn2YTcul9x+J5k9gHszxLzV9Me0=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Lior Dotan <liodot@gmail.com>, <charrer@alacritech.com>,
       Denis Kirjanov <kirjanov@gmail.com>,
       "David S. Miller" <davem@davemloft.net>, Jiri Pirko <jpirko@redhat.com>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] staging: slicoss: Move NULL pointer assertion to else branch
Date: Sun, 27 Jun 2010 17:20:45 +0400
Message-Id: <1277644847-16292-3-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1277644847-16292-1-git-send-email-segooon@gmail.com>
References: <1277644847-16292-1-git-send-email-segooon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move NULL pointer assertion to else branch because it can
become NULL only here.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/slicoss/slicoss.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index 102d3ea..86bc733 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -2263,11 +2263,11 @@ static u32 slic_card_locate(struct adapter *adapter)
 				break;
 			card = card->next;
 		}
+		ASSERT(card);
+		if (!card)
+			return -ENOMEM;
 	}
 
-	ASSERT(card);
-	if (!card)
-		return -ENOMEM;
 	/* Put the adapter in the card's adapter list */
 	ASSERT(card->adapter[adapter->port] == NULL);
 	if (!card->adapter[adapter->port]) {
-- 
1.7.0.4

