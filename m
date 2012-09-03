Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323Ab2ICPXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 11:23:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932266Ab2ICPXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 11:23:22 -0400
Date: Mon, 3 Sep 2012 17:25:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] uprobes: single-step fixes
Message-ID: <20120903152525.GA9028@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

In short: uprobes should not use user_enable/disable_single_step().
This is unneeded and wrong.

Sebastian, I changed your patches a bit:

	1/7:

		- Change the subject and update the changelog. In particular,
		  s/utrace/uprobes/. I am wondering where this typo came from ;)

	2/7:

		- Rename UPROBE_TF_CHANGES to UPROBE_FIX_SETF to match other
		  *_FIX_* defines.

		- Update the changelog.

		- !!!REMOVE send_sig(SIGTRAP) from arch_uprobe_disable_step!!!
		  Didn't I ask you to make a separate patch for this change? ;)

		  This "else send_sig(SIGTRAP)" is very wrong. Just suppose an
		  application does asm ("pushf; popf") and the 2nd insn is probed.
		  And otoh this is not enough.

		  See 6/7.

please let me know if you disagree.

Oleg.

