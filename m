Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab0IOPeI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 11:34:08 -0400
Received: from usmamail.tilera.com ([72.1.168.231]:33380 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600Ab0IOPeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 11:34:07 -0400
Message-ID: <4C90E768.3070607@tilera.com>
Date: Wed, 15 Sep 2010 11:34:00 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.9) Gecko/20100825 Thunderbird/3.1.3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL] arch/tile fixes for 2.6.36
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Linus,

Please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git stable

to get bug fixes for arch/tile/ for 2.6.36.  The first one listed
below completes the change to use "const" arguments for sys_execve(),
which was only partially applied to arch/tile.  The second change is a
minor public-header change that we decided to do to make porting glibc
easier.  The remaining three changes fix bugs that have been discovered
internally.

Thanks!

Chris Metcalf (5):
      arch/tile: finish const-ifying sys_execve()
      arch/tile: Change struct sigcontext to be more useful
      arch/tile: Save and restore extra user state for tilegx
      arch/tile: fix memcpy_fromio()/memcpy_toio() signatures
      arch/tile: fix formatting bug in register dumps

 arch/tile/include/arch/chip_tile64.h  |    3 +++
 arch/tile/include/arch/chip_tilepro.h |    3 +++
 arch/tile/include/asm/compat.h        |    5 +++--
 arch/tile/include/asm/io.h            |    8 ++++----
 arch/tile/include/asm/processor.h     |   12 ++++++++++++
 arch/tile/include/asm/ptrace.h        |   15 ++++++---------
 arch/tile/include/asm/sigcontext.h    |   18 +++++++++++++-----
 arch/tile/include/asm/signal.h        |    1 +
 arch/tile/include/asm/syscalls.h      |   21 +++++++++++++--------
 arch/tile/kernel/process.c            |   30 ++++++++++++++++++++----------
 arch/tile/kernel/signal.c             |   27 +++++++++++++++------------
 arch/tile/kernel/stack.c              |    2 +-
 12 files changed, 94 insertions(+), 51 deletions(-)


-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

