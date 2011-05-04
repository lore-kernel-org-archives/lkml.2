Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab1EDQxw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 12:53:52 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:56252 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079Ab1EDQxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 12:53:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=RvAHBk/9iepowBsWBdaxMtUF8W2kEj1n42mj/sz9n0ID8Q7o5GbVYPhsWh9fWeasSO
         +26GEMaNcZ6em09qp+T3D+qNCYG42dKzAQe1pzZeinl1wRZaU4LYHe0f5UjtOAX014/2
         UEpSlB/lvH4FZw7fhDseKuIUmeZf0BkPixZ/s=
Subject: [PATCH] sched: Wrap nr_spread_over with CONFIG_SCHED_DEBUG.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 May 2011 22:53:46 +0600
Message-ID: <1304528026.15681.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 nr_spread_over is used when CONFIG_SCHED_DEBUG is set. So wrap nr_spread_over with CONFIG_SCHED_DEBUG.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

diff --git a/kernel/sched.c b/kernel/sched.c
index 8cb0a57..0b91adf 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -328,7 +328,9 @@ struct cfs_rq {
 	 */
 	struct sched_entity *curr, *next, *last, *skip;
 
+#ifdef	CONFIG_SCHED_DEBUG
 	unsigned int nr_spread_over;
+#endif
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	struct rq *rq;	/* cpu runqueue to which this cfs_rq is attached */


