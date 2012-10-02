Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745Ab2JBX76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 19:59:58 -0400
Received: from smtp.outflux.net ([198.145.64.163]:35883 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932732Ab2JBX75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 19:59:57 -0400
Date: Tue, 2 Oct 2012 16:49:34 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Minchan Kim <minchan@kernel.org>,
        Joe Perches <joe@perches.com>, Kautuk Consul <consul.kautuk@gmail.com>,
        linux-mm@kvack.org, Brad Spengler <spender@grsecurity.net>
Subject: [PATCH] mm: use %pK for /proc/vmallocinfo
Message-ID: <20121002234934.GA9194@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the paranoid case of sysctl kernel.kptr_restrict=2, mask the kernel
virtual addresses in /proc/vmallocinfo too.

Reported-by: Brad Spengler <spender@grsecurity.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 2bb90b1..9c871db 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2572,7 +2572,7 @@ static int s_show(struct seq_file *m, void *p)
 {
 	struct vm_struct *v = p;
 
-	seq_printf(m, "0x%p-0x%p %7ld",
+	seq_printf(m, "0x%pK-0x%pK %7ld",
 		v->addr, v->addr + v->size, v->size);
 
 	if (v->caller)
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
