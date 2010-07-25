Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab0GYViN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 17:38:13 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:59212 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab0GYViM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 17:38:12 -0400
Date: Sun, 25 Jul 2010 23:38:08 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Roman Zippel <zippel@linux-m68k.org>, Michal Marek <mmarek@suse.cz>,
        Uwe Kleine-Koig <u.kleine-koenig@pengutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: [RFC] kconfig: introduce alldefconfig + savedefconfig
Message-ID: <20100725213808.GA5814@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After reading some of the mails about the
defconfig files I decided to take a look at kconfig.

We already decided to go for a solution where the defconfig
files contains only the minimal configuration.
Uwe developed a script to assist but having native support
in kconfig is preferable.

This patch set introduce "alldefconfig".
alldefconfig create a configuration with all values set
to default values.
This can be usefull when we check if we do have a sane
set of default values. Rhe config can be inspected
using menuconfig.

The patches also introduce "savedefconfig" which
reads the current configuration and save it
as a minimal configuration.

In my testing I benchmarked it with one
of the arm defconfings and the final result is
the same (symbols appear in different order).

The first two patches is not relevant to the above.
They was just stuff I had pending.


The patches has seen only light testing for now,
and any feedback is welcome.

After finishing off these patches I will take a closer
look at the patch form Stephen that introduce
a more advanced select.

Note: Anyone that have heard from Roman Zippel recently?

The patches:

Roman Zippel (1):
      kconfig: print more info when we see a recursive dependency

Sam Ravnborg (3):
      kconfig: save location of config symbols
      kconfig: add alldefconfig
      kconfig: add savedefconfig


 Documentation/kbuild/kconfig.txt |    2 +-
 scripts/kconfig/Makefile         |   13 ++-
 scripts/kconfig/conf.c           |   46 ++++++--
 scripts/kconfig/confdata.c       |   94 +++++++++++++++
 scripts/kconfig/expr.h           |    1 +
 scripts/kconfig/lkc.h            |    2 +
 scripts/kconfig/lkc_proto.h      |    1 +
 scripts/kconfig/menu.c           |    2 +
 scripts/kconfig/symbol.c         |  242 +++++++++++++++++++++++++++++++++++---
 9 files changed, 373 insertions(+), 30 deletions(-)

	Sam
