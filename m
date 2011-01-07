Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab1AGPhp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 10:37:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:36930 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986Ab1AGPhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 10:37:43 -0500
Date: Fri, 7 Jan 2011 15:37:19 GMT
From: tip-bot for Hillf Danton <dhillf@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        dhillf@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dhillf@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <AANLkTinOPuYsVovrZpbuCCmG5deEyc8WgA_A1RJx_YK7@mail.gmail.com>
References: <AANLkTinOPuYsVovrZpbuCCmG5deEyc8WgA_A1RJx_YK7@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix strncmp operation
Message-ID: <tip-524429c31b486c05449666b94613f59f729c0a84@git.kernel.org>
Git-Commit-ID: 524429c31b486c05449666b94613f59f729c0a84
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 07 Jan 2011 15:37:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  524429c31b486c05449666b94613f59f729c0a84
Gitweb:     http://git.kernel.org/tip/524429c31b486c05449666b94613f59f729c0a84
Author:     Hillf Danton <dhillf@gmail.com>
AuthorDate: Thu, 6 Jan 2011 20:58:12 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 7 Jan 2011 15:55:10 +0100

sched: Fix strncmp operation

One of the operands, buf, is incorrect, since it is stripped and the
correct address for subsequent string comparing could change if
leading white spaces, if any, are removed from buf.

It is fixed by replacing buf with cmp.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <AANLkTinOPuYsVovrZpbuCCmG5deEyc8WgA_A1RJx_YK7@mail.gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index a8478a2..a0eb094 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -741,7 +741,7 @@ sched_feat_write(struct file *filp, const char __user *ubuf,
 	buf[cnt] = 0;
 	cmp = strstrip(buf);
 
-	if (strncmp(buf, "NO_", 3) == 0) {
+	if (strncmp(cmp, "NO_", 3) == 0) {
 		neg = 1;
 		cmp += 3;
 	}
