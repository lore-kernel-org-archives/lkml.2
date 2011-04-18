Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab1DRNpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 09:45:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830Ab1DRNpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 09:45:12 -0400
Date: Mon, 18 Apr 2011 15:44:21 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 0/7] signal: sigprocmask fixes
Message-ID: <20110418134421.GA15951@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, please drop V1:

	signal-introduce-retarget_shared_pending.patch
	signal-retarget_shared_pending-consider-shared-unblocked-signals-only.patch
	signal-sigprocmask-narrow-the-scope-of-sigloc.patch
	signal-sigprocmask-should-do-retarget_shared_pending.patch
	x86-signal-handle_signal-should-use-sigprocmask.patch
	x86-signal-sys_rt_sigreturn-should-use-sigprocmask.patch

Changes in V2:

	- 2/7 change retarget_shared_pending() to accept mask, not ~mask

	- 3/7 is new, it adds the optimization promised in 2/7

	- 4/7 add the small comment about current->blocked as Matt
	      suggested

	- 5/7 add the new helper, set_current_blocked(), suggested
	      by Linus

	- 8/7 is the new and a bit off-topic cleanup, but sys_rt_sigprocmask()
	      looks so annoying

Matt, I didn't dare to keep your reviewed-by tags because of the
changes above, hopefully you can re-ack.

Once again: if we need this, then we need a lot more (trivial) changes
like 6/7 and 7/7. Basically every change of ->blocked should be converted
to use set_current_blocked(). OTOH, perhaps this makes sense by itself.

Oleg.

