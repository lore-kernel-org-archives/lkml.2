Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760899Ab2KBQ6s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 12:58:48 -0400
Received: from mail.windriver.com ([147.11.1.11]:52586 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759255Ab2KBQ6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 12:58:47 -0400
Date: Fri, 2 Nov 2012 12:58:35 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.6.5-rt14
Message-ID: <20121102165835.GI25658@windriver.com>
References: <alpine.LFD.2.02.1211012148170.2756@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1211012148170.2756@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[[ANNOUNCE] 3.6.5-rt14] On 01/11/2012 (Thu 21:57) Thomas Gleixner wrote:

> Dear RT Folks,
> 
> I'm pleased to announce the 3.6.5-rt14 release. 3.6.4-rt12 is an
> intermediate release with a few changes. 3.6.5-rt13 is an update to
> 3.6.5 and 3.6.5-rt14 has a fix for my stupidity to release from the
> wrong tree missing a fix for x86-32.

The rt14 content is available at the split queue repo on the master
branch.  I've also created a 3.6.5-rt14-fixes branch, which contains:

1) another %cx --> %ecx mismatch warning fix
2) fixes a bogus PREEMPT_LAZE in a select line
3) pointless newline removal fix carried over from 3.6.4-rt11-fixes

All patches are fixed in-place directly within the existing patches
without changing the series file (vs adding a separate patch for
later folding).  So they should be a drop in for integration even
if folks aren't using this git repo to provide history tracking.
Patches on the 3.6.5-rt14-fixes pass a basic boot test on x86_32 UP.

For those who didn't catch one of the earlier posts[1] about the split
patch queue repo, it is a history tracking repo of all the releases of
the patches-3.6.X-rtY.tar.xz  (X=gregkh stable, Y=rt version).

Having the history repo allows you to track how each patch evolves,
how the ordering changes and so on.

You can use it just like a split queue tarball, in that you git am (or
git quiltimport) the patches in the repo onto a gregkh stable tree, and
then you can run "git blame path/to/somefile" to see seamless history
across rt and back into stable/mainline as to who mangled what lines.

The plus is, that rather than download and untar each time, you just go
into where you've cloned this repo, and issue a "git pull" to get the
latest update.  Go to your kernel tree, checkout the appropriate gregkh
stable baseline and reapply the patches and you are done.

Folks can browse the repo at:

http://git.kernel.org/?p=linux/kernel/git/paulg/3.6-rt-patches.git

Paul.

[1] http://permalink.gmane.org/gmane.linux.rt.user/8864
---

The following changes since commit 3f2b22edd602ef42f77abf345a0a777ccd4033ac:

  patches-3.6.5-rt14.tar.xz (2012-11-02 11:52:35 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulg/3.6-rt-patches.git v3.6.5-rt14-fixes

for you to fetch changes up to a1221218459505df9a2d6c63d29432c637804a91:

  x86_32: fix %cx -> %ecx mismatch on testl (2012-11-02 12:27:51 -0400)

----------------------------------------------------------------
Paul Gortmaker (3):
      preempt-lazy-support.patch: delete trailing newline addition
      fix bogus HAVE_PREEMPT_LAZE in preempt-lazy-support.patch
      x86_32: fix %cx -> %ecx mismatch on testl

 preempt-lazy-support.patch | 7 ++-----
 x86-preempt-lazy.patch     | 2 +-
 2 files changed, 3 insertions(+), 6 deletions(-)
