Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511Ab2I3TkQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 15:40:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790Ab2I3TkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 15:40:15 -0400
Date: Sun, 30 Sep 2012 21:41:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] uprobes: register/unregister bugfixes
Message-ID: <20120930194119.GA11278@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Misc bugfixes, mostly register/unregister related.

Note: 4/7 and especially 6/7 are the really ugly (but hopefully
temporary) hacks. We already discussed this, we should inspect
the original insn in uprobe_register(). But this is not easy, and
we need something simple to fix (some of) the bugs right now.

Even 7/7 is ugly. Imho UPROBE_SKIP_SSTEP should die as well but
this is another story.

Oleg.

 arch/x86/kernel/uprobes.c |   16 +------
 include/linux/uprobes.h   |   10 ----
 kernel/events/uprobes.c   |  107 +++++++++++++++++++++++++++++++-------------
 3 files changed, 77 insertions(+), 56 deletions(-)

