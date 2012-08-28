Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab2H1NPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 09:15:10 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:35421 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab2H1NPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 09:15:08 -0400
MIME-Version: 1.0
Date: Tue, 28 Aug 2012 21:15:08 +0800
Message-ID: <CAPgLHd_fh-vz4kjz-fuyHxK5N1EzojFAoQ0xK60fEtFmQqCv_Q@mail.gmail.com>
Subject: [PATCH] audit: remove pointless conditional before kfree_skb()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: viro@zeniv.linux.org.uk, eparis@redhat.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove pointless conditional before kfree_skb().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 kernel/audit.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index ea3b7b6..ba9dd4d 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1024,8 +1024,7 @@ static void audit_buffer_free(struct audit_buffer *ab)
 	if (!ab)
 		return;
 
-	if (ab->skb)
-		kfree_skb(ab->skb);
+	kfree_skb(ab->skb);
 
 	spin_lock_irqsave(&audit_freelist_lock, flags);
 	if (audit_freelist_count > AUDIT_MAXFREE)

