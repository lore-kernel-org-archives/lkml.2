Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab1HPShh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 14:37:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500Ab1HPShg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 14:37:36 -0400
Date: Tue, 16 Aug 2011 20:34:05 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Matt Fleming <matt@console-pimps.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] tomoyo: remove tomoyo_gc_thread()->daemonize()
Message-ID: <20110816183405.GA3257@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

daemonize() is only needed when a user-space task does kernel_thread().

tomoyo_gc_thread() is kthread_create()'ed and thus it doesn't need
the soon-to-be-deprecated daemonize().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 security/tomoyo/gc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 3.1/security/tomoyo/gc.c~1_daemonize_tomoyo	2011-08-12 16:02:18.000000000 +0200
+++ 3.1/security/tomoyo/gc.c	2011-08-16 20:18:52.000000000 +0200
@@ -660,7 +660,7 @@ static int tomoyo_gc_thread(void *unused
 	static DEFINE_MUTEX(tomoyo_gc_mutex);
 	if (!mutex_trylock(&tomoyo_gc_mutex))
 		goto out;
-	daemonize("GC for TOMOYO");
+
 	do {
 		tomoyo_collect_entry();
 		if (list_empty(&tomoyo_gc_list))

