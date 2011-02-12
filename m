Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724Ab1BLN2e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 08:28:34 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:43565 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640Ab1BLN21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 08:28:27 -0500
Date: Sat, 12 Feb 2011 08:28:26 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL]
Message-ID: <20110212132826.GB2598@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20110211134058.GA4309@thunk.org>
 <AANLkTineDxntR0ZTXdgXrc6qx6pATTORgOwFR5+w5MLN@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTineDxntR0ZTXdgXrc6qx6pATTORgOwFR5+w5MLN@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 04:33:59PM -0800, Linus Torvalds wrote:
> This is a completely disgusting patch, and it causes warnings like this:

Mea culpa, mea culpa, mea maximum culpa.  Yes, sorry, I should have
caught the macro expansion bug and the cast warning.

I've fixed up the problems, and repushed the for_linus branch.  My
post -rc1 push came late due to travel and other business, and that no
doubt contributed to the lack of quality control, but I didn't want to
wait since they did fix a number of fairly serious regressions.  I
hope you'll take the pull with these problems fixed?

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

						- Ted

Curt Wohlgemuth (1):
      ext4: Fix data corruption with multi-block writepages support

Eric Sandeen (3):
      ext4: fix panic on module unload when stopping lazyinit thread
      ext4: make grpinfo slab cache names static
      ext4: serialize unaligned asynchronous DIO

Lukas Czerner (1):
      ext4: unregister features interface on module unload

Theodore Ts'o (2):
      ext4: fix up ext4 error handling
      jbd2: call __jbd2_log_start_commit with j_state_lock write locked

 fs/ext4/ext4.h        |   10 +++++
 fs/ext4/extents.c     |   10 +++--
 fs/ext4/file.c        |   60 +++++++++++++++++++++++++++++-
 fs/ext4/mballoc.c     |  100 +++++++++++++++++++++++++++++-------------------
 fs/ext4/page-io.c     |   36 +++++++++--------
 fs/ext4/super.c       |   66 ++++++++++++++++++++++----------
 fs/jbd2/journal.c     |    9 +++-
 fs/jbd2/transaction.c |   21 +++++++---
 8 files changed, 221 insertions(+), 91 deletions(-)
