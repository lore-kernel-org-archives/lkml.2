Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531Ab0GBMKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 08:10:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:57189 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753298Ab0GBMKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 08:10:23 -0400
Date: Fri, 2 Jul 2010 14:10:21 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mmarek@suse.cz, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       dmitry.torokhov@gmail.com
Subject: [GIT] kbuild setlocalversion fix
Message-ID: <20100702121021.GA10458@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

There is a fix to the Makefile not to run scripts/setlocalversion and
various git commands on every invocation. This was also the case
previously with CONFIG_LOCALVERSION_AUTO=y, but after 85a256d (kbuild:
improve version string logic) it happens during every build. Dmitry
Torokhov complained that make install in a sshfs-mounted tree takes
extremely long, it also goes against the idea that root should only run
the necessary minimum of commands. The first patch has been in
linux-next for a couple of days and I got no complaints, the second one
is just a minor fix over it and should be safe.

Michal

The following changes since commit d5eda75f3a6a08f5a3644764a88d288e62e7823d:

  kbuild: fix LOCALVERSION handling to match description (2010-06-15 12:45:40 +0200)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git rc-fixes

Michal Marek (3):
      kbuild: Clean up and speed up the localversion logic
      kbuild: Propagate LOCALVERSION= down to scripts/setlocalversion
      Merge branch 'setlocalversion-speedup' into kbuild/rc-fixes

 Makefile                 |   72 +------------------
 scripts/package/Makefile |    2 +-
 scripts/setlocalversion  |  179 ++++++++++++++++++++++++++++++++++------------
 3 files changed, 134 insertions(+), 119 deletions(-)
