Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760673Ab1D1P1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 11:27:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755156Ab1D1P1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 11:27:33 -0400
Date: Thu, 28 Apr 2011 17:26:13 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: [PATCHSET] signals-review branch
Message-ID: <20110428152613.GA14174@redhat.com>
References: <20110418134421.GA15951@redhat.com> <20110418134501.GC15951@redhat.com> <20110425105229.GE17734@mtj.dyndns.org> <20110425152040.GA14934@redhat.com> <20110425161951.GA30828@mtj.dyndns.org> <20110425170200.GA18363@redhat.com> <BANLkTi=oksQFYtyS1+RA5c_4E22yjik90g@mail.gmail.com> <20110426194536.GA7590@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110426194536.GA7590@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I collected the patches which were acked by Tejun and Matt and (I hope)
Linus agrees with,

	git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc.git signals-review

	[PATCH 01/13] signal: introduce retarget_shared_pending()
	[PATCH 02/13] signal: retarget_shared_pending: consider shared/unblocked signals only
	[PATCH 03/13] signal: retarget_shared_pending: optimize while_each_thread() loop
	[PATCH 04/13] signal: sigprocmask: narrow the scope of ->siglock
	[PATCH 05/13] signal: sigprocmask() should do retarget_shared_pending()
	[PATCH 06/13] x86: signal: handle_signal() should use set_current_blocked()
	[PATCH 07/13] x86: signal: sys_rt_sigreturn() should use set_current_blocked()
	[PATCH 08/13] signal: cleanup sys_rt_sigprocmask()
	[PATCH 09/13] signal: sys_rt_sigtimedwait: simplify the timeout logic
	[PATCH 10/13] signal: introduce do_sigtimedwait() to factor out compat/native code
	[PATCH 11/13] signal: do_sigtimedwait() needs retarget_shared_pending()
	[PATCH 12/13] signal: rename signandsets() to sigandnsets()
	[PATCH 13/13] signal: cleanup sys_sigprocmask()

I do not want to spam lkml again, all changes are purely cosmetic and hopefully
address the comments from you and Matt:

	all: rediff against ptrace branch

	[PATCH 02/13] signal: retarget_shared_pending: consider shared/unblocked signals only
	commit f646e227b88a164a841d6b6dd969d8a45272dd83

		retarget_shared_pending:
		
			s/set/which/, s/shared_pending/retarget

		exit_signals:

			s/set/unblocked

	[PATCH 03/13] signal: retarget_shared_pending: optimize while_each_thread() loop
	commit fec9993db093acfc3999a364e31f8adae41fcb28

		retarget_shared_pending:

			remove the unnecessary () in "if ((t->flags & PF_EXITING))"

			add the small comment

	[PATCH 05/13] signal: sigprocmask() should do retarget_shared_pending()
	commit e6fa16ab9c1e9b344428e6fea4d29e3cc4b28fb0

		set_current_blocked:

			add some comments

	[PATCH 07/13] x86: signal: sys_rt_sigreturn() should use set_current_blocked()
	commit e9bd3f0faa90084f188830d77723bafe422e486b

		no changes. I was asked to add the comment, but I have no
		idea what should be documented. The patch and the code are
		trivial.

	[PATCH 08/13] signal: cleanup sys_rt_sigprocmask()
	commit bb7efee2ca63b08795ffb3cda96fc89d2e641b79

		do not touch the "XXX" comment which I misunderstood

	[PATCH 10/13] signal: introduce do_sigtimedwait() to factor out compat/native code
	commit 943df1485a8ff0e600729e082e568ece04d4de9e

		Well. As it was suggested, I added the docbook coment to the
		new helper. Trivial copy-and-paste from sys_rt_sigtimedwait(),
		not sure we need these extra 6 lines.

Unless you have other comments, I'll merge this into ptrace branch.

Oleg.

