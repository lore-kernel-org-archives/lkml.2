Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab2DSXQW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 19:16:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40297 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577Ab2DSXQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 19:16:18 -0400
Date: Fri, 20 Apr 2012 01:15:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Alexander Gordeev <agordeev@redhat.com>, Chris Zankel <chris@zankel.net>,
        David Smith <dsmith@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Kuo <rkuo@codeaurora.org>, Tejun Heo <tj@kernel.org>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 3/6] hexagon: do_notify_resume() needs
	tracehook_notify_resume()
Message-ID: <20120419231527.GC15828@redhat.com>
References: <20120419231431.GA15820@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120419231431.GA15820@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/hexagon/kernel/signal.c:do_notify_resume() forgets to call
tracehook_notify_resume() if TIF_NOTIFY_RESUME is set.

Cc: Richard Kuo <rkuo@codeaurora.org>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/hexagon/kernel/signal.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/hexagon/kernel/signal.c b/arch/hexagon/kernel/signal.c
index ecbab34..ab5f5ad 100644
--- a/arch/hexagon/kernel/signal.c
+++ b/arch/hexagon/kernel/signal.c
@@ -272,6 +272,7 @@ void do_notify_resume(struct pt_regs *regs, unsigned long thread_info_flags)
 
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
+		tracehook_notify_resume(regs);
 		if (current->replacement_session_keyring)
 			key_replace_session_keyring();
 	}
-- 
1.5.5.1


