Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255Ab0HKUti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 16:49:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51047 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753270Ab0HKUth convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 16:49:37 -0400
Date: Thu, 12 Aug 2010 06:49:26 +1000
From: Neil Brown <neilb@suse.de>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: Re: [REVISED PULL REQUEST] md updates for 2.6.36
Message-ID: <20100812064926.15dafbf7@notabene>
In-Reply-To: <1281482611.5887.38.camel@localhost>
References: <19552.39399.490494.51990@notabene.brown>
	<AANLkTinbCHAB3tPos1sp078maWaHAQbRM8oWMOiF1U8D@mail.gmail.com>
	<1281482611.5887.38.camel@localhost>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Aug 2010 00:23:31 +0100
David Woodhouse <dwmw2@infradead.org> wrote:

> On Tue, 2010-08-10 at 15:47 -0700, Linus Torvalds wrote:
> > 
> > Hmm. Why "lib/raid6/raid6sse2.c" and friends? Why "raid6" twice? You
> > don't mean "raid6+1" (mirrored raid6 ;), so why not just remove the
> > second "raid6", and call it "lib/raid6/sse2.c"
> > 
> > But I pulled. Just in case there was some logic to the duplication. 
> 
> No particular reason -- I just wanted the initial move to be as simple
> as possible. Since it all gets built into raid6_pq.ko and we never see
> these filenames even in module names, it does make sense to rename them.
> 
> If Neil approves, git://git.infradead.org/~dwmw2/libraid-2.6.git

Looks good,thanks.  There are a few comments still say "raid6xxx.c" and there
is a .h file (raid6x86.h) which you didn't rename but probably should be.

I've added a patch to clean these up.

> 
> The userspace test/ (neé raid6test/) directory doesn't build, but it
> didn't before. At least I fixed the awk incantations.
> 
Yep, there is some bit rot in there.  Fixed that too.

Linus, you can get all this from
    git://neil.brown.name/md for-linus

Thanks.

The following changes since commit 3d30701b58970425e1d45994d6cb82f828924fdd:

  Merge branch 'for-linus' of git://neil.brown.name/md (2010-08-10 15:38:19 -0700)

are available in the git repository at:

  git://neil.brown.name/md for-linus

David Woodhouse (1):
      Rename raid6 files now they're in a 'raid6' directory.

NeilBrown (2):
      Make lib/raid6/test build correctly.
      Further tidyup of raid6 naming in lib/raid6

 include/linux/raid/pq.h                   |    2 +
 lib/raid6/Makefile                        |   81 ++++++++++++++---------------
 lib/raid6/{raid6algos.c => algos.c}       |    4 +-
 lib/raid6/{raid6altivec.uc => altivec.uc} |    0
 lib/raid6/{raid6int.uc => int.uc}         |    0
 lib/raid6/{raid6mmx.c => mmx.c}           |    6 +-
 lib/raid6/raid6test/Makefile              |   75 --------------------------
 lib/raid6/{raid6recov.c => recov.c}       |    2 +-
 lib/raid6/{raid6sse1.c => sse1.c}         |    6 +-
 lib/raid6/{raid6sse2.c => sse2.c}         |    4 +-
 lib/raid6/test/Makefile                   |   72 +++++++++++++++++++++++++
 lib/raid6/{raid6test => test}/test.c      |    0
 lib/raid6/{raid6x86.h => x86.h}           |    2 +-
 13 files changed, 125 insertions(+), 129 deletions(-)
 rename lib/raid6/{raid6algos.c => algos.c} (99%)
 rename lib/raid6/{raid6altivec.uc => altivec.uc} (100%)
 rename lib/raid6/{raid6int.uc => int.uc} (100%)
 rename lib/raid6/{raid6mmx.c => mmx.c} (98%)
 delete mode 100644 lib/raid6/raid6test/Makefile
 rename lib/raid6/{raid6recov.c => recov.c} (99%)
 rename lib/raid6/{raid6sse1.c => sse1.c} (98%)
 rename lib/raid6/{raid6sse2.c => sse2.c} (99%)
 create mode 100644 lib/raid6/test/Makefile
 rename lib/raid6/{raid6test => test}/test.c (100%)
 rename lib/raid6/{raid6x86.h => x86.h} (99%)
