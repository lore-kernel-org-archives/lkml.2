Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab1HBUzz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 16:55:55 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:11001 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254Ab1HBUzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 16:55:49 -0400
Message-ID: <4E386454.1090502@tilera.com>
Date: Tue, 2 Aug 2011 16:55:48 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL] arch/tile updates for 3.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull for 3.1 from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git master

These are a set of relatively minor changes for arch/tile, including a
new character driver to support the standard boot device (a SPI flash ROM).
Thanks!

Chris Metcalf (6):
      tile: use generic-y format for one-line asm-generic headers
      ioctl-number.txt: add the tile hardwall ioctl range
      arch/tile: add hypervisor-based character driver for SPI flash ROM
      arch/tile: remove useless set_fixmap_nocache() macro

John Stultz (1):
      clocksource: tile: convert to use clocksource_register_hz

Julia Lawall (1):
      arch/tile/mm/init.c: trivial: use BUG_ON

 Documentation/ioctl/ioctl-number.txt      |    1 +
 arch/tile/include/asm/Kbuild              |   38 +++
 arch/tile/include/asm/bug.h               |    1 -
 arch/tile/include/asm/bugs.h              |    1 -
 arch/tile/include/asm/cputime.h           |    1 -
 arch/tile/include/asm/device.h            |    1 -
 arch/tile/include/asm/div64.h             |    1 -
 arch/tile/include/asm/emergency-restart.h |    1 -
 arch/tile/include/asm/errno.h             |    1 -
 arch/tile/include/asm/fb.h                |    1 -
 arch/tile/include/asm/fcntl.h             |    1 -
 arch/tile/include/asm/fixmap.h            |    6 -
 arch/tile/include/asm/ioctl.h             |    1 -
 arch/tile/include/asm/ioctls.h            |    1 -
 arch/tile/include/asm/ipc.h               |    1 -
 arch/tile/include/asm/ipcbuf.h            |    1 -
 arch/tile/include/asm/irq_regs.h          |    1 -
 arch/tile/include/asm/kdebug.h            |    1 -
 arch/tile/include/asm/local.h             |    1 -
 arch/tile/include/asm/module.h            |    1 -
 arch/tile/include/asm/msgbuf.h            |    1 -
 arch/tile/include/asm/mutex.h             |    1 -
 arch/tile/include/asm/param.h             |    1 -
 arch/tile/include/asm/parport.h           |    1 -
 arch/tile/include/asm/poll.h              |    1 -
 arch/tile/include/asm/posix_types.h       |    1 -
 arch/tile/include/asm/resource.h          |    1 -
 arch/tile/include/asm/scatterlist.h       |    1 -
 arch/tile/include/asm/sembuf.h            |    1 -
 arch/tile/include/asm/serial.h            |    1 -
 arch/tile/include/asm/shmbuf.h            |    1 -
 arch/tile/include/asm/shmparam.h          |    1 -
 arch/tile/include/asm/socket.h            |    1 -
 arch/tile/include/asm/sockios.h           |    1 -
 arch/tile/include/asm/statfs.h            |    1 -
 arch/tile/include/asm/termbits.h          |    1 -
 arch/tile/include/asm/termios.h           |    1 -
 arch/tile/include/asm/types.h             |    1 -
 arch/tile/include/asm/ucontext.h          |    1 -
 arch/tile/include/asm/xor.h               |    1 -
 arch/tile/include/hv/drv_srom_intf.h      |   41 +++
 arch/tile/kernel/time.c                   |    5 +-
 arch/tile/mm/init.c                       |    3 +-
 drivers/char/Kconfig                      |   11 +
 drivers/char/Makefile                     |    2 +
 drivers/char/tile-srom.c                  |  481 +++++++++++++++++++++++++++++
 46 files changed, 576 insertions(+), 49 deletions(-)
 delete mode 100644 arch/tile/include/asm/bug.h
 delete mode 100644 arch/tile/include/asm/bugs.h
 delete mode 100644 arch/tile/include/asm/cputime.h
 delete mode 100644 arch/tile/include/asm/device.h
 delete mode 100644 arch/tile/include/asm/div64.h
 delete mode 100644 arch/tile/include/asm/emergency-restart.h
 delete mode 100644 arch/tile/include/asm/errno.h
 delete mode 100644 arch/tile/include/asm/fb.h
 delete mode 100644 arch/tile/include/asm/fcntl.h
 delete mode 100644 arch/tile/include/asm/ioctl.h
 delete mode 100644 arch/tile/include/asm/ioctls.h
 delete mode 100644 arch/tile/include/asm/ipc.h
 delete mode 100644 arch/tile/include/asm/ipcbuf.h
 delete mode 100644 arch/tile/include/asm/irq_regs.h
 delete mode 100644 arch/tile/include/asm/kdebug.h
 delete mode 100644 arch/tile/include/asm/local.h
 delete mode 100644 arch/tile/include/asm/module.h
 delete mode 100644 arch/tile/include/asm/msgbuf.h
 delete mode 100644 arch/tile/include/asm/mutex.h
 delete mode 100644 arch/tile/include/asm/param.h
 delete mode 100644 arch/tile/include/asm/parport.h
 delete mode 100644 arch/tile/include/asm/poll.h
 delete mode 100644 arch/tile/include/asm/posix_types.h
 delete mode 100644 arch/tile/include/asm/resource.h
 delete mode 100644 arch/tile/include/asm/scatterlist.h
 delete mode 100644 arch/tile/include/asm/sembuf.h
 delete mode 100644 arch/tile/include/asm/serial.h
 delete mode 100644 arch/tile/include/asm/shmbuf.h
 delete mode 100644 arch/tile/include/asm/shmparam.h
 delete mode 100644 arch/tile/include/asm/socket.h
 delete mode 100644 arch/tile/include/asm/sockios.h
 delete mode 100644 arch/tile/include/asm/statfs.h
 delete mode 100644 arch/tile/include/asm/termbits.h
 delete mode 100644 arch/tile/include/asm/termios.h
 delete mode 100644 arch/tile/include/asm/types.h
 delete mode 100644 arch/tile/include/asm/ucontext.h
 delete mode 100644 arch/tile/include/asm/xor.h
 create mode 100644 arch/tile/include/hv/drv_srom_intf.h
 create mode 100644 drivers/char/tile-srom.c


-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

