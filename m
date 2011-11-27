Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab1K0Fih (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 00:38:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755769Ab1K0Fie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 00:38:34 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Cong Wang <amwang@redhat.com>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        James Morris <jmorris@namei.org>,
        linux-security-module@vger.kernel.org
Subject: [PATCH 56/62] tomoyo: remove the second argument of k[un]map_atomic()
Date: Sun, 27 Nov 2011 13:27:36 +0800
Message-Id: <1322371662-26166-57-git-send-email-amwang@redhat.com>
In-Reply-To: <1322371662-26166-1-git-send-email-amwang@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Cong Wang <amwang@redhat.com>
---
 security/tomoyo/domain.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/tomoyo/domain.c b/security/tomoyo/domain.c
index 9027ac1..3865145 100644
--- a/security/tomoyo/domain.c
+++ b/security/tomoyo/domain.c
@@ -886,12 +886,12 @@ bool tomoyo_dump_page(struct linux_binprm *bprm, unsigned long pos,
 		 * But remove_arg_zero() uses kmap_atomic()/kunmap_atomic().
 		 * So do I.
 		 */
-		char *kaddr = kmap_atomic(page, KM_USER0);
+		char *kaddr = kmap_atomic(page);
 
 		dump->page = page;
 		memcpy(dump->data + offset, kaddr + offset,
 		       PAGE_SIZE - offset);
-		kunmap_atomic(kaddr, KM_USER0);
+		kunmap_atomic(kaddr);
 	}
 	/* Same with put_arg_page(page) in fs/exec.c */
 #ifdef CONFIG_MMU
-- 
1.7.4.4

