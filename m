Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab1HSNjf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:39:35 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:58735 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021Ab1HSN3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:29:14 -0400
X-IronPort-AV: E=Sophos;i="4.68,251,1312171200"; 
   d="scan'208";a="159732384"
From: Ian Campbell <ian.campbell@citrix.com>
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        Ursula Braun <ursula.braun@de.ibm.com>,
        Frank Blaschka <blaschka@linux.vnet.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org
Subject: [PATCH 41/75] qeth: convert to SKB paged frag API.
Date: Fri, 19 Aug 2011 14:27:13 +0100
Message-ID: <1313760467-8598-41-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Ursula Braun <ursula.braun@de.ibm.com>
Cc: Frank Blaschka <blaschka@linux.vnet.ibm.com>
Cc: linux390@de.ibm.com
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-s390@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/s390/net/qeth_core_main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 4550573..91d87ba 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -3204,7 +3204,8 @@ static inline void __qeth_fill_buffer(struct sk_buff *skb,
 
 	for (cnt = 0; cnt < skb_shinfo(skb)->nr_frags; cnt++) {
 		frag = &skb_shinfo(skb)->frags[cnt];
-		buffer->element[element].addr = (char *)page_to_phys(frag->page)
+		buffer->element[element].addr = (char *)
+			page_to_phys(skb_frag_page(frag))
 			+ frag->page_offset;
 		buffer->element[element].length = frag->size;
 		buffer->element[element].eflags = SBAL_EFLAGS_MIDDLE_FRAG;
-- 
1.7.2.5

