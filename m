Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab1GVKbG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 06:31:06 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:54361 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab1GVKbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 06:31:03 -0400
Date: Fri, 22 Jul 2011 12:30:59 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>, Denys Vlasenko <vda.linux@googlemail.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Merging ptrace branch into mainline
Message-ID: <20110722103059.GK2622@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Most of the changes that I had on mind when I wrote "Proposal for
ptrace improvements"[1] seem complete.  The details of course changed
quite a bit during implementation iterations but AFAICS all the
features and fixes described in the propsal are now in Oleg's tree
waiting to be pulled into mainline.  New features are still blocked by
the DEVEL flag indicating the API is not finalized yet and should be
used only for developement.

Remaining issues are

* Two different modes of trap notification - directly ptrace_notify()
  and force_sig(SIGTRAP), which makes SIGTRAP special w.r.t. ptrace.

  There are two alternatives.  One is converting SIGTRAP notifications
  into (async) ptrace_notify() notifications.  The other is to leave
  it alone and just declare that SIGTRAP indeed is special and
  userland programs playing with SIGTRAP won't behave transparently
  while ptraced.

  I haven't really looked at it too much but am currently leaning
  towards the latter.

* Somewhat related.  Some part of ptrace, especially breakpoint and
  singlestep handling, is more arch-specific than necessary and archs
  diverged on what is reported how.  Most of this should be unifiable
  or at least categorized.

Neither is very critical and we shouldn't be introducing drastic
userland visible behavior differences no matter which way we choose,
but given that this isn't an urgent thing, I think it would be best to
merge the pending ptrace changes with the DEVEL blocking enabled for
3.1, so that we can have more time settling down things and hopefully
seeing how it works with actual userland usage.

What do you guys think?

Thank you.

-- 
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/1107045
