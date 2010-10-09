Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760542Ab0JIWkp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 18:40:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59949 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755753Ab0JIWko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 18:40:44 -0400
Date: Sun, 10 Oct 2010 00:40:41 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kyle@redhat.com, lacombar@gmail.com, mmarek@suse.cz,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] kconfig rc fixes
Message-ID: <20101009224041.GA901@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I have three fixes that should ideally go into 2.6.36:

1) Kyle's make oldnoconfig fix: make oldnoconfig was added and later got
   broken, all in 2.6.36-rc1.
2) Arnaud's fix for a crash in kconfig caused by a use-after-free bug.
   This fix has the unfortunate side effect that most configurations
   (e.g. make defconfig on x86) start printing warnings several lines
   long. These warnings are valid, but were not detected before. To
   avoid receiving tens of reports about this once 2.6.36 is out, I
   decided to comment out the warnings completely for the final release,
   as there is not enough time to fix the root causes.

Please consider for 2.6.36. Or if you are only willing to take either 1)
or 2), let me know and I'll prepare such branch.

Thanks,
Michal


The following changes since commit cb655d0f3d57c23db51b981648e452988c0223f9:

  Linux 2.6.36-rc7 (2010-10-06 13:39:52 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git rc-fixes

Arnaud Lacombe (1):
      kconfig: delay symbol direct dependency initialization

Kyle McMartin (1):
      kbuild: fix oldnoconfig to do the right thing

Michal Marek (1):
      kconfig: Temporarily disable dependency warnings

 scripts/kconfig/conf.c   |    2 +-
 scripts/kconfig/expr.h   |    1 -
 scripts/kconfig/menu.c   |    7 ++-----
 scripts/kconfig/symbol.c |    2 ++
 4 files changed, 5 insertions(+), 7 deletions(-)
