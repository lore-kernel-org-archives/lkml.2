Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab1FBSdH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 14:33:07 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:59646 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab1FBSdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 14:33:05 -0400
X-Greylist: delayed 512 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Jun 2011 14:33:05 EDT
Date: Thu, 2 Jun 2011 20:24:31 +0200
From: Andreas Mohr <andi@lisas.de>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>,
        Michal Marek <mmarek@suse.cz>, Waldo Bastian <bastian@kde.org>,
        Ryan Lortie <desrt@desrt.ca>,
        Lennart Poettering <lennart@poettering.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Heads-up: Linux make menuconfig .config vs. XDG_CONFIG_HOME
 ~/.config/ clash - perhaps resolve it while 3.0 appears?
Message-ID: <20110602182431.GA26282@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I just discovered a Linux kernel make menuconfig .config file
accidentally situated in the home directory of a shell account
(simply scp:d over without much thought, thus directly ending up in main
user home on that machine, something which can happen quite easily
for a number of other reasons as well).
I then realized the potentially fatal ramifications of this.

XXXXXX:/tmp$ touch mytest
XXXXXX:/tmp$ mkdir mytest
mkdir: cannot create directory `mytest': File exists


XDG Base Directory Specification
  http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html
says:

"$XDG_CONFIG_HOME defines the base directory relative to which user
specific configuration files should be stored. If $XDG_CONFIG_HOME is
either not set or empty, a default equal to $HOME/.config should be
used."
And that mechanism is exactly what a ton of Linux userspace apps
(and hopefully many more in future) are already making use of
to store their configuration data in a manner
that's more friendly to user home directories.


It may thus be strongly advisable to rename the default name of the
make menuconfig kernel .config file (perhaps .config_lx / .config_linux ?)
to completely sidestep such a (mostly user-triggered)
problematic clash in future.

And (I cannot help but think of this) now that lx 3.0 is in -rc
this might still be an especially appropriate moment to do it ;)
(one would have to think of potential compatibility issues though)

Thanks for listening,

Andreas Mohr
