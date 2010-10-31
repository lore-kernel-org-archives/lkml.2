Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab0JaPSH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 11:18:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:52573 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755850Ab0JaPSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 11:18:05 -0400
Date: Sun, 31 Oct 2010 15:13:57 GMT
From: tip-bot for Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        arjan@infradead.org, jj@chaosbits.net, tglx@linutronix.de,
        wli@holomorphy.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        arjan@infradead.org, jj@chaosbits.net, tglx@linutronix.de,
        wli@holomorphy.com, mingo@elte.hu
In-Reply-To: <alpine.LNX.2.00.1010302150310.1572@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1010302150310.1572@swampdragon.chaosbits.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] profile: Use vzalloc() rather than vmalloc() & memset()
Message-ID: <tip-559fa6e76b271b98ff641fa2a968aa2439e43c28@git.kernel.org>
Git-Commit-ID: 559fa6e76b271b98ff641fa2a968aa2439e43c28
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 31 Oct 2010 15:15:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  559fa6e76b271b98ff641fa2a968aa2439e43c28
Gitweb:     http://git.kernel.org/tip/559fa6e76b271b98ff641fa2a968aa2439e43c28
Author:     Jesper Juhl <jj@chaosbits.net>
AuthorDate: Sat, 30 Oct 2010 21:56:26 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 31 Oct 2010 09:47:26 +0100

profile: Use vzalloc() rather than vmalloc() & memset()

There's no reason to memset() manually when we have vzalloc().

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: William Irwin <wli@holomorphy.com>
LKML-Reference: <alpine.LNX.2.00.1010302150310.1572@swampdragon.chaosbits.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/profile.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/profile.c b/kernel/profile.c
index 66f841b..14c9f87 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -126,11 +126,9 @@ int __ref profile_init(void)
 	if (prof_buffer)
 		return 0;
 
-	prof_buffer = vmalloc(buffer_bytes);
-	if (prof_buffer) {
-		memset(prof_buffer, 0, buffer_bytes);
+	prof_buffer = vzalloc(buffer_bytes);
+	if (prof_buffer)
 		return 0;
-	}
 
 	free_cpumask_var(prof_cpu_mask);
 	return -ENOMEM;
