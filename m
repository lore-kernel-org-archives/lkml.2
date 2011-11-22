Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab1KVVJe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 16:09:34 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:45683 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab1KVVJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 16:09:33 -0500
Date: Tue, 22 Nov 2011 21:09:30 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs fix
Message-ID: <20111122210930.GJ2203@ZenIV.linux.org.uk>
References: <20111122174419.GI2203@ZenIV.linux.org.uk>
 <CA+55aFz+9TN2z+q9vH2g0wMq6_X8AfYANrntGQd_et+U5+c74Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz+9TN2z+q9vH2g0wMq6_X8AfYANrntGQd_et+U5+c74Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 09:48:36AM -0800, Linus Torvalds wrote:
> On Tue, Nov 22, 2011 at 9:44 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > Really embarrassing braino; kudos to jlayton for catching that one.
> > Please, pull from
> > git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus
> >
> > Al Viro (1):
> > ? ? ?mount_subtree() pointless use-after-free
> 
> Hmm. That's not at all what I get.
> 
> Or rather, that's just *one* of the commits I get. I also get these two:
> 
>       microblaze: bury asm/namei.h
>       iio: fix a leak due to improper use of anon_inode_getfd()
> 
> which look like they may be valid, but for all I know you meant to
> leave them for the next merge window. So not pulled. Please check your
> tree,

Umm...  OK, I see what happened - buggered script generating
shortlog/diffstat plus me not noticing that it hadn't reported a couple
of fixes I'd put there yesterday.  All 3 are intended to be sent;
iio is an outright bugfix, microblaze one could wait, in theory, but
it's guaranteed to be safe (removal of header nothing includes, done on
all architectures years ago, with microblaze tree apparently copying it
from sparc and keeping all along) and the sooner such things are buried,
the fewer places will copy that *again*...

Anyway, consider that a pull request for all 3 commits.  Proper shortlog
and diffstat follow.

Shortlog:
Al Viro (3):
      microblaze: bury asm/namei.h
      iio: fix a leak due to improper use of anon_inode_getfd()
      mount_subtree() pointless use-after-free

Diffstat:
 arch/microblaze/include/asm/namei.h     |   22 ----------------------
 drivers/staging/iio/industrialio-core.c |   10 +++++++++-
 fs/namespace.c                          |    6 ++++--
 3 files changed, 13 insertions(+), 25 deletions(-)


FWIW, the fixed form of script follows; if you see any potential problems in
it, please tell:
echo Shortlog:
base=`git merge-base origin "$1"`
git log --pretty=short "$base..$1" | git shortlog
echo Diffstat:
git diff --stat -M "$base..$1"
