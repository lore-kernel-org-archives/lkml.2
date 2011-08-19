Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab1HSEb3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 00:31:29 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49884 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab1HSEb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 00:31:28 -0400
Date: Fri, 19 Aug 2011 05:31:20 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Richard Weinberger <richard@nod.at>
Cc: Al Viro <viro@ftp.linux.org.uk>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: Subject: [PATCH 00/91] pending uml patches
Message-ID: <20110819043120.GY2203@ZenIV.linux.org.uk>
References: <E1Qu7nv-0007OP-3E@ZenIV.linux.org.uk>
 <4E4D642F.3010909@nod.at>
 <20110818191946.GW2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110818191946.GW2203@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 08:19:46PM +0100, Al Viro wrote:
> On Thu, Aug 18, 2011 at 09:12:47PM +0200, Richard Weinberger wrote:
> > Have you touched your patches since yesterday?
> > I've already pulled and uploaded them to my shiny new git repo at:
> > git://git.kernel.org/pub/scm/linux/kernel/git/rw/linux-um.git unstable
> 
> Reordered and added missing S-o-b on a couple, split one commit.

Umm...  One comment after looking at your tree: you probably want to rebase
for-3.2 on top of fixes (and presumably feed it to sfr for inclusion into
linux-next).

And for pity sake, do *not* merge from Linus every day; that's one sure
way to get yourself flamed into crisp.  Just trying to figure out
what's in your tree is a _hard_ exercise.  git cherry between Linus'
tree and e.g. #fixes in yours gives a long list of commits, most of them
_probably_ duplicates of the stuff in mainline.  What are bnx2 patches
doing in there, for example?

I've tried to figure out what's going on in there; AFAICS, your #fixes
is mainline plus
Al Viro (6):
      um: fix oopsable race in line_close()
      um: winch_interrupt() can happen inside of free_winch()
      um: fix free_winch() mess
      um: PTRACE_[GS]ETFPXREGS had been wired on the wrong subarch
      um: fix strrchr problems
      um: clean arch_ptrace() up a bit

Ingo van Lil (1):
      um: Save FPU registers between task switches

Jonathan Neusch<C3><A4>fer (3):
      UserModeLinux-HOWTO.txt: fix a typo
      um: drivers/xterm.c: fix a file descriptor leak
      UserModeLinux-HOWTO.txt: remove ^H characters

Thadeu Lima de Souza Cascardo (1):
      um: disable CMPXCHG_DOUBLE as it breaks UML build

	I've cherry-picked those on top of the same branchpoint; see
#cleaned-fixes in um-headers.git.  AFAICS, that's the same contents as
your #fixes, with clean history.  Diff against your #fixes consists of
-       .irq_set_type = pmic_irq_type, <<<<<<< HEAD
-       .irq_bus_lock           = pmic_irq_buslock,
+       .irq_set_type           = pmic_irq_type,
+       .irq_bus_lock           = pmic_bus_lock,
in drivers/platform/x86/intel_pmic_gpio.c, which is an obvious mismerge
(AFAICS, on May 29).

IME the sane policy is to keep for-linus, pulling into it when Linus
pulls from you.  At that point it's a fast-forward and all previous
history is not cluttering the things up anymore.  for-next I rebase and
reorder at will, TBH, but generally I start it at the current tip of
for-linus.

Beyond what you've got in #for-3.2 I have a couple of commits, but that
can wait until the history is sorted out.  As it is, I 100% guarantee
that pull request on your #fixes as it is will result in pyrotechnical
effects from hell (OK, from Linus, actually, but in this case there won't
be any real difference).

