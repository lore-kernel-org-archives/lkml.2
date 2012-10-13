Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab2JMCf0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 22:35:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28011 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218Ab2JMC3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 22:29:55 -0400
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=tKOusvB8I0cA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=JYkqpZBvdvAA:10 a=iqiRxA-Joy1I7mqeAqkA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121013022632.024527228@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 12 Oct 2012 22:26:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 00/25] asm-generic: Convert all to use Kbuild file
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently I suggested to someone that was adding a new asm file that
currently only contained an x86 change to add a header in all archs
that was just a wrapper to point to the asm-generic version. I suggested
this because that's the way we use to do it and just to refresh my
memory, I looked at div64.h in a few archs and saw that was the case.

After having the change done and just after finishing testing it, I was
notified that the "proper" way of doing this is to add it to the

  arch/*/include/asm/Kbuild

file, as 'generic-y += foo.h' and it will reference the asm-generic
file automatically. Well it would have been nice if I knew this before
and wasn't confused by seeing the incorrect method.

Thus, out of frustration, I went and cleaned up all the archs to have
them use the Kbuild method and deleted the empty files. I spent
a bit of time to make sure the only thing the file did was include
the generic header and not add anything else. So if it only included
the generic header and sometimes added the wrapper #ifndef _HEADER_H
notations, I deleted the file and added it to Kbuild.

What I would really like to do is get rid of the adding of these
files all together (from even the Kbuild file), and just have
by default, if the file does not exist in arch/*/include/asm/ but does
in include/asm-generic/ then use the generic version. Why don't we
do that now? I can look into doing this when I have more time.

I tested these changes by cross compiling the defconfig for everything
but:

  c6x, hexagon, microblaze, score, unicore

because cross compilers for these archs are not available to me.

Note, I first did the change against 3.6 but found that there's
some isses with the check header but is fixed by David Howells changes
in the current merge window. But it seems that the current merge
window caused:

  frv, openrisc, ia64 and xtensa

not to compile correctly (before adding these patches). I tested
anyway, just to see if they added more errors.

 h8300 I have yet to get to compile (never ever compiled for me).

But everything else has been crossed compiled by a defconfig and
seems to work.

 Kudos to m68k and sh, those two were fully up-to-date with
the new Kbuild method.

 Honorable mention goes to:

  blackfin, c6x, hexagon, openrisc, tile, um and unicore2

for being almost totally up to the new method, but it seems that
kvm_para.h was added the old way.

Please feel free to pluck these patches into your architecture and
run them to make sure that they boot as well (I only had the compiler
and not the box... Also I only tested with defconfig, I may have
broken other configs).

One note, the best thing about these changes is:

 390 files changed, 369 insertions(+), 1378 deletions(-)

-- Steve

Steven Rostedt (25):
      alpha: Use Kbuild infrastructure to handle asm-generic headers
      arm: Use Kbuild infrastructure to handle asm-generic headers
      avr32: Use Kbuild infrastructure to handle asm-generic headers
      blackfin: Use Kbuild infrastructure for kvm_para.h
      c6x: Use Kbuild infrastructure for kvm_para.h
      cris: Use Kbuild infrastructure to handle asm-generic headers
      frv: Use Kbuild infrastructure to handle asm-generic headers
      h8300: Use Kbuild infrastructure to handle asm-generic headers
      hexagon: Use Kbuild infrastructure for kvm_para.h
      ia64: Use Kbuild infrastructure to handle asm-generic headers
      m32r: Use Kbuild infrastructure to handle asm-generic headers
      microblaze: Use Kbuild infrastructure to handle asm-generic headers
      mips: Use Kbuild infrastructure to handle asm-generic headers
      mn10300: Use Kbuild infrastructure to handle asm-generic headers
      openrisc: Use Kbuild infrastructure for kvm_para.h
      parisc: Use Kbuild infrastructure to handle asm-generic headers
      powerpc: Use Kbuild infrastructure to handle asm-generic headers
      s390: Use Kbuild infrastructure to handle asm-generic headers
      score: Use Kbuild infrastructure to handle asm-generic headers
      sparc: Use Kbuild infrastructure to handle asm-generic headers
      tile: Use Kbuild infrastructure for kvm_para.h
      um: Use Kbuild infrastructure for kvm_para.h
      unicore32: Use Kbuild infrastructure for kvm_para.h
      x86: Use Kbuild infrastructure to handle asm-generic headers
      xtensa: Use Kbuild infrastructure to handle asm-generic headers

----
 arch/alpha/include/asm/Kbuild                   |   12 ++++++
 arch/alpha/include/asm/cputime.h                |    6 ---
 arch/alpha/include/asm/device.h                 |    7 ----
 arch/alpha/include/asm/div64.h                  |    1 -
 arch/alpha/include/asm/emergency-restart.h      |    6 ---
 arch/alpha/include/asm/ipcbuf.h                 |    1 -
 arch/alpha/include/asm/irq_regs.h               |    1 -
 arch/alpha/include/asm/kdebug.h                 |    1 -
 arch/alpha/include/asm/kvm_para.h               |    1 -
 arch/alpha/include/asm/local64.h                |    1 -
 arch/alpha/include/asm/poll.h                   |    1 -
 arch/alpha/include/asm/scatterlist.h            |    6 ---
 arch/alpha/include/asm/sections.h               |    7 ----
 arch/arm/include/asm/Kbuild                     |    2 +
 arch/arm/include/asm/kvm_para.h                 |    1 -
 arch/avr32/include/asm/Kbuild                   |   27 +++++++++++++
 arch/avr32/include/asm/bitsperlong.h            |    1 -
 arch/avr32/include/asm/cputime.h                |    6 ---
 arch/avr32/include/asm/delay.h                  |    1 -
 arch/avr32/include/asm/device.h                 |    7 ----
 arch/avr32/include/asm/div64.h                  |    6 ---
 arch/avr32/include/asm/emergency-restart.h      |    6 ---
 arch/avr32/include/asm/errno.h                  |    6 ---
 arch/avr32/include/asm/fcntl.h                  |    6 ---
 arch/avr32/include/asm/futex.h                  |    6 ---
 arch/avr32/include/asm/ioctl.h                  |    6 ---
 arch/avr32/include/asm/ioctls.h                 |    6 ---
 arch/avr32/include/asm/ipcbuf.h                 |    1 -
 arch/avr32/include/asm/irq_regs.h               |    1 -
 arch/avr32/include/asm/kvm_para.h               |    1 -
 arch/avr32/include/asm/local.h                  |    6 ---
 arch/avr32/include/asm/local64.h                |    1 -
 arch/avr32/include/asm/mman.h                   |    1 -
 arch/avr32/include/asm/percpu.h                 |    6 ---
 arch/avr32/include/asm/poll.h                   |    1 -
 arch/avr32/include/asm/resource.h               |    6 ---
 arch/avr32/include/asm/scatterlist.h            |    6 ---
 arch/avr32/include/asm/sections.h               |    6 ---
 arch/avr32/include/asm/siginfo.h                |    6 ---
 arch/avr32/include/asm/statfs.h                 |    6 ---
 arch/avr32/include/asm/topology.h               |    6 ---
 arch/avr32/include/asm/xor.h                    |    6 ---
 arch/blackfin/include/asm/Kbuild                |    1 +
 arch/blackfin/include/asm/kvm_para.h            |    1 -
 arch/c6x/include/asm/Kbuild                     |    1 +
 arch/c6x/include/asm/kvm_para.h                 |    1 -
 arch/cris/include/asm/Kbuild                    |   24 ++++++++++++
 arch/cris/include/asm/bitsperlong.h             |    1 -
 arch/cris/include/asm/cputime.h                 |    6 ---
 arch/cris/include/asm/device.h                  |    7 ----
 arch/cris/include/asm/div64.h                   |    1 -
 arch/cris/include/asm/emergency-restart.h       |    6 ---
 arch/cris/include/asm/errno.h                   |    6 ---
 arch/cris/include/asm/fcntl.h                   |    1 -
 arch/cris/include/asm/futex.h                   |    6 ---
 arch/cris/include/asm/ioctl.h                   |    1 -
 arch/cris/include/asm/ipcbuf.h                  |    1 -
 arch/cris/include/asm/irq_regs.h                |    1 -
 arch/cris/include/asm/kdebug.h                  |    1 -
 arch/cris/include/asm/kmap_types.h              |   10 -----
 arch/cris/include/asm/local.h                   |    1 -
 arch/cris/include/asm/local64.h                 |    1 -
 arch/cris/include/asm/mman.h                    |    1 -
 arch/cris/include/asm/percpu.h                  |    6 ---
 arch/cris/include/asm/poll.h                    |    1 -
 arch/cris/include/asm/resource.h                |    6 ---
 arch/cris/include/asm/scatterlist.h             |    6 ---
 arch/cris/include/asm/sections.h                |    7 ----
 arch/cris/include/asm/siginfo.h                 |    6 ---
 arch/cris/include/asm/statfs.h                  |    6 ---
 arch/cris/include/asm/topology.h                |    6 ---
 arch/frv/include/asm/Kbuild                     |   19 ++++++++++
 arch/frv/include/asm/bitsperlong.h              |    1 -
 arch/frv/include/asm/cputime.h                  |    6 ---
 arch/frv/include/asm/device.h                   |    7 ----
 arch/frv/include/asm/div64.h                    |    1 -
 arch/frv/include/asm/emergency-restart.h        |    6 ---
 arch/frv/include/asm/errno.h                    |    7 ----
 arch/frv/include/asm/fcntl.h                    |    1 -
 arch/frv/include/asm/ioctl.h                    |    1 -
 arch/frv/include/asm/ipcbuf.h                   |    1 -
 arch/frv/include/asm/kdebug.h                   |    1 -
 arch/frv/include/asm/kvm_para.h                 |    1 -
 arch/frv/include/asm/local.h                    |    6 ---
 arch/frv/include/asm/local64.h                  |    1 -
 arch/frv/include/asm/mman.h                     |    1 -
 arch/frv/include/asm/percpu.h                   |    6 ---
 arch/frv/include/asm/resource.h                 |    7 ----
 arch/frv/include/asm/scatterlist.h              |    6 ---
 arch/frv/include/asm/statfs.h                   |    7 ----
 arch/frv/include/asm/xor.h                      |    1 -
 arch/h8300/include/asm/Kbuild                   |   23 ++++++++++++
 arch/h8300/include/asm/bitsperlong.h            |    1 -
 arch/h8300/include/asm/cputime.h                |    6 ---
 arch/h8300/include/asm/device.h                 |    7 ----
 arch/h8300/include/asm/div64.h                  |    1 -
 arch/h8300/include/asm/emergency-restart.h      |    6 ---
 arch/h8300/include/asm/errno.h                  |    6 ---
 arch/h8300/include/asm/futex.h                  |    6 ---
 arch/h8300/include/asm/ioctl.h                  |    1 -
 arch/h8300/include/asm/ipcbuf.h                 |    1 -
 arch/h8300/include/asm/irq_regs.h               |    1 -
 arch/h8300/include/asm/kdebug.h                 |    1 -
 arch/h8300/include/asm/kmap_types.h             |    6 ---
 arch/h8300/include/asm/kvm_para.h               |    1 -
 arch/h8300/include/asm/local.h                  |    6 ---
 arch/h8300/include/asm/local64.h                |    1 -
 arch/h8300/include/asm/mman.h                   |    1 -
 arch/h8300/include/asm/percpu.h                 |    6 ---
 arch/h8300/include/asm/resource.h               |    6 ---
 arch/h8300/include/asm/scatterlist.h            |    6 ---
 arch/h8300/include/asm/sections.h               |    6 ---
 arch/h8300/include/asm/siginfo.h                |    6 ---
 arch/h8300/include/asm/statfs.h                 |    6 ---
 arch/h8300/include/asm/topology.h               |    6 ---
 arch/hexagon/include/asm/Kbuild                 |    1 +
 arch/hexagon/include/asm/kvm_para.h             |    1 -
 arch/ia64/include/asm/Kbuild                    |   10 +++++
 arch/ia64/include/asm/div64.h                   |    1 -
 arch/ia64/include/asm/emergency-restart.h       |    6 ---
 arch/ia64/include/asm/errno.h                   |    1 -
 arch/ia64/include/asm/ioctl.h                   |    1 -
 arch/ia64/include/asm/ioctls.h                  |    6 ---
 arch/ia64/include/asm/ipcbuf.h                  |    1 -
 arch/ia64/include/asm/irq_regs.h                |    1 -
 arch/ia64/include/asm/local.h                   |    1 -
 arch/ia64/include/asm/local64.h                 |    1 -
 arch/ia64/include/asm/poll.h                    |    1 -
 arch/m32r/include/asm/Kbuild                    |   28 ++++++++++++++
 arch/m32r/include/asm/bitsperlong.h             |    1 -
 arch/m32r/include/asm/bug.h                     |    4 --
 arch/m32r/include/asm/cputime.h                 |    6 ---
 arch/m32r/include/asm/delay.h                   |    1 -
 arch/m32r/include/asm/device.h                  |    7 ----
 arch/m32r/include/asm/div64.h                   |    1 -
 arch/m32r/include/asm/emergency-restart.h       |    6 ---
 arch/m32r/include/asm/errno.h                   |    6 ---
 arch/m32r/include/asm/fcntl.h                   |    1 -
 arch/m32r/include/asm/futex.h                   |    6 ---
 arch/m32r/include/asm/ioctl.h                   |    1 -
 arch/m32r/include/asm/ioctls.h                  |    6 ---
 arch/m32r/include/asm/ipcbuf.h                  |    1 -
 arch/m32r/include/asm/irq_regs.h                |    1 -
 arch/m32r/include/asm/kdebug.h                  |    1 -
 arch/m32r/include/asm/local64.h                 |    1 -
 arch/m32r/include/asm/mman.h                    |    1 -
 arch/m32r/include/asm/param.h                   |    7 ----
 arch/m32r/include/asm/pci.h                     |    6 ---
 arch/m32r/include/asm/percpu.h                  |    6 ---
 arch/m32r/include/asm/poll.h                    |    1 -
 arch/m32r/include/asm/resource.h                |    6 ---
 arch/m32r/include/asm/scatterlist.h             |    6 ---
 arch/m32r/include/asm/sections.h                |    7 ----
 arch/m32r/include/asm/siginfo.h                 |    6 ---
 arch/m32r/include/asm/statfs.h                  |    6 ---
 arch/m32r/include/asm/topology.h                |    6 ---
 arch/m32r/include/asm/xor.h                     |    6 ---
 arch/microblaze/include/asm/Kbuild              |   46 +++++++++++++++++++++++
 arch/microblaze/include/asm/bitops.h            |    1 -
 arch/microblaze/include/asm/bitsperlong.h       |    1 -
 arch/microblaze/include/asm/bug.h               |    1 -
 arch/microblaze/include/asm/bugs.h              |    1 -
 arch/microblaze/include/asm/cputime.h           |    1 -
 arch/microblaze/include/asm/div64.h             |    1 -
 arch/microblaze/include/asm/emergency-restart.h |    1 -
 arch/microblaze/include/asm/errno.h             |    1 -
 arch/microblaze/include/asm/fb.h                |    1 -
 arch/microblaze/include/asm/fcntl.h             |    1 -
 arch/microblaze/include/asm/hardirq.h           |    1 -
 arch/microblaze/include/asm/ioctl.h             |    1 -
 arch/microblaze/include/asm/ioctls.h            |    1 -
 arch/microblaze/include/asm/ipcbuf.h            |    1 -
 arch/microblaze/include/asm/irq_regs.h          |    1 -
 arch/microblaze/include/asm/kdebug.h            |    1 -
 arch/microblaze/include/asm/kmap_types.h        |    6 ---
 arch/microblaze/include/asm/kvm_para.h          |    1 -
 arch/microblaze/include/asm/local.h             |    1 -
 arch/microblaze/include/asm/local64.h           |    1 -
 arch/microblaze/include/asm/mman.h              |    1 -
 arch/microblaze/include/asm/msgbuf.h            |    1 -
 arch/microblaze/include/asm/param.h             |    1 -
 arch/microblaze/include/asm/parport.h           |    1 -
 arch/microblaze/include/asm/percpu.h            |    1 -
 arch/microblaze/include/asm/poll.h              |    1 -
 arch/microblaze/include/asm/resource.h          |    1 -
 arch/microblaze/include/asm/scatterlist.h       |    1 -
 arch/microblaze/include/asm/sembuf.h            |    1 -
 arch/microblaze/include/asm/serial.h            |    1 -
 arch/microblaze/include/asm/shmbuf.h            |    1 -
 arch/microblaze/include/asm/shmparam.h          |    1 -
 arch/microblaze/include/asm/siginfo.h           |    1 -
 arch/microblaze/include/asm/signal.h            |    1 -
 arch/microblaze/include/asm/socket.h            |    1 -
 arch/microblaze/include/asm/sockios.h           |    1 -
 arch/microblaze/include/asm/stat.h              |    1 -
 arch/microblaze/include/asm/statfs.h            |    1 -
 arch/microblaze/include/asm/swab.h              |    1 -
 arch/microblaze/include/asm/termbits.h          |    1 -
 arch/microblaze/include/asm/termios.h           |    1 -
 arch/microblaze/include/asm/topology.h          |    1 -
 arch/microblaze/include/asm/types.h             |    1 -
 arch/microblaze/include/asm/ucontext.h          |    1 -
 arch/microblaze/include/asm/vga.h               |    1 -
 arch/microblaze/include/asm/xor.h               |    1 -
 arch/mips/include/asm/Kbuild                    |   14 +++++++
 arch/mips/include/asm/cputime.h                 |    6 ---
 arch/mips/include/asm/current.h                 |    1 -
 arch/mips/include/asm/emergency-restart.h       |    6 ---
 arch/mips/include/asm/ipcbuf.h                  |    1 -
 arch/mips/include/asm/kvm_para.h                |    1 -
 arch/mips/include/asm/local64.h                 |    1 -
 arch/mips/include/asm/parport.h                 |    1 -
 arch/mips/include/asm/percpu.h                  |    6 ---
 arch/mips/include/asm/scatterlist.h             |    6 ---
 arch/mips/include/asm/sections.h                |    6 ---
 arch/mips/include/asm/serial.h                  |    1 -
 arch/mips/include/asm/ucontext.h                |    1 -
 arch/mips/include/asm/xor.h                     |    1 -
 arch/mn10300/include/asm/Kbuild                 |   23 ++++++++++++
 arch/mn10300/include/asm/bitsperlong.h          |    1 -
 arch/mn10300/include/asm/cputime.h              |    1 -
 arch/mn10300/include/asm/device.h               |    1 -
 arch/mn10300/include/asm/emergency-restart.h    |    1 -
 arch/mn10300/include/asm/errno.h                |    1 -
 arch/mn10300/include/asm/fcntl.h                |    1 -
 arch/mn10300/include/asm/futex.h                |    1 -
 arch/mn10300/include/asm/ioctl.h                |    1 -
 arch/mn10300/include/asm/ioctls.h               |    6 ---
 arch/mn10300/include/asm/ipcbuf.h               |    1 -
 arch/mn10300/include/asm/kmap_types.h           |    6 ---
 arch/mn10300/include/asm/kvm_para.h             |    1 -
 arch/mn10300/include/asm/local.h                |    1 -
 arch/mn10300/include/asm/local64.h              |    1 -
 arch/mn10300/include/asm/percpu.h               |    1 -
 arch/mn10300/include/asm/poll.h                 |    1 -
 arch/mn10300/include/asm/resource.h             |    1 -
 arch/mn10300/include/asm/scatterlist.h          |   16 --------
 arch/mn10300/include/asm/sections.h             |    1 -
 arch/mn10300/include/asm/siginfo.h              |    1 -
 arch/mn10300/include/asm/statfs.h               |    1 -
 arch/mn10300/include/asm/topology.h             |    1 -
 arch/mn10300/include/asm/xor.h                  |    1 -
 arch/openrisc/include/asm/Kbuild                |    1 +
 arch/openrisc/include/asm/kvm_para.h            |    1 -
 arch/parisc/include/asm/Kbuild                  |   18 ++++++++-
 arch/parisc/include/asm/compat_signal.h         |    2 -
 arch/parisc/include/asm/cputime.h               |    6 ---
 arch/parisc/include/asm/device.h                |    7 ----
 arch/parisc/include/asm/div64.h                 |    1 -
 arch/parisc/include/asm/emergency-restart.h     |    6 ---
 arch/parisc/include/asm/hardirq.h               |   11 ------
 arch/parisc/include/asm/irq_regs.h              |    1 -
 arch/parisc/include/asm/kdebug.h                |    1 -
 arch/parisc/include/asm/kvm_para.h              |    1 -
 arch/parisc/include/asm/local.h                 |    1 -
 arch/parisc/include/asm/local64.h               |    1 -
 arch/parisc/include/asm/param.h                 |    1 -
 arch/parisc/include/asm/percpu.h                |    7 ----
 arch/parisc/include/asm/poll.h                  |    1 -
 arch/parisc/include/asm/topology.h              |    6 ---
 arch/parisc/include/asm/xor.h                   |    1 -
 arch/powerpc/include/asm/Kbuild                 |    9 +++++
 arch/powerpc/include/asm/div64.h                |    1 -
 arch/powerpc/include/asm/emergency-restart.h    |    1 -
 arch/powerpc/include/asm/irq_regs.h             |    2 -
 arch/powerpc/include/asm/local64.h              |    1 -
 arch/powerpc/include/asm/param.h                |    1 -
 arch/powerpc/include/asm/poll.h                 |    1 -
 arch/powerpc/include/asm/resource.h             |    1 -
 arch/powerpc/include/asm/statfs.h               |    6 ---
 arch/powerpc/include/asm/xor.h                  |    1 -
 arch/s390/include/asm/Kbuild                    |   17 ++++++++-
 arch/s390/include/asm/device.h                  |    7 ----
 arch/s390/include/asm/div64.h                   |    1 -
 arch/s390/include/asm/emergency-restart.h       |    6 ---
 arch/s390/include/asm/irq_regs.h                |    1 -
 arch/s390/include/asm/kmap_types.h              |    6 ---
 arch/s390/include/asm/local.h                   |    1 -
 arch/s390/include/asm/local64.h                 |    1 -
 arch/s390/include/asm/xor.h                     |    1 -
 arch/s390/include/uapi/asm/errno.h              |   11 ------
 arch/s390/include/uapi/asm/fcntl.h              |    1 -
 arch/s390/include/uapi/asm/ioctl.h              |    1 -
 arch/s390/include/uapi/asm/param.h              |    6 ---
 arch/s390/include/uapi/asm/poll.h               |    1 -
 arch/s390/include/uapi/asm/resource.h           |   13 -------
 arch/s390/include/uapi/asm/sockios.h            |    6 ---
 arch/s390/include/uapi/asm/termbits.h           |    6 ---
 arch/score/include/asm/Kbuild                   |   44 ++++++++++++++++++++++
 arch/score/include/asm/bitsperlong.h            |    6 ---
 arch/score/include/asm/bugs.h                   |    6 ---
 arch/score/include/asm/cputime.h                |    6 ---
 arch/score/include/asm/current.h                |    6 ---
 arch/score/include/asm/device.h                 |    6 ---
 arch/score/include/asm/div64.h                  |    6 ---
 arch/score/include/asm/emergency-restart.h      |    6 ---
 arch/score/include/asm/errno.h                  |    6 ---
 arch/score/include/asm/fcntl.h                  |    6 ---
 arch/score/include/asm/futex.h                  |    6 ---
 arch/score/include/asm/hardirq.h                |    6 ---
 arch/score/include/asm/ioctl.h                  |    6 ---
 arch/score/include/asm/ioctls.h                 |    6 ---
 arch/score/include/asm/ipcbuf.h                 |    6 ---
 arch/score/include/asm/kdebug.h                 |    6 ---
 arch/score/include/asm/kmap_types.h             |    6 ---
 arch/score/include/asm/kvm_para.h               |    1 -
 arch/score/include/asm/local.h                  |    6 ---
 arch/score/include/asm/local64.h                |    1 -
 arch/score/include/asm/mman.h                   |    6 ---
 arch/score/include/asm/msgbuf.h                 |    6 ---
 arch/score/include/asm/param.h                  |    6 ---
 arch/score/include/asm/percpu.h                 |    6 ---
 arch/score/include/asm/poll.h                   |    6 ---
 arch/score/include/asm/posix_types.h            |    6 ---
 arch/score/include/asm/resource.h               |    6 ---
 arch/score/include/asm/scatterlist.h            |    6 ---
 arch/score/include/asm/sections.h               |    6 ---
 arch/score/include/asm/sembuf.h                 |    6 ---
 arch/score/include/asm/shmbuf.h                 |    6 ---
 arch/score/include/asm/shmparam.h               |    6 ---
 arch/score/include/asm/siginfo.h                |    6 ---
 arch/score/include/asm/signal.h                 |    6 ---
 arch/score/include/asm/socket.h                 |    6 ---
 arch/score/include/asm/sockios.h                |    6 ---
 arch/score/include/asm/stat.h                   |    6 ---
 arch/score/include/asm/statfs.h                 |    6 ---
 arch/score/include/asm/swab.h                   |    6 ---
 arch/score/include/asm/termbits.h               |    6 ---
 arch/score/include/asm/termios.h                |    6 ---
 arch/score/include/asm/topology.h               |    6 ---
 arch/score/include/asm/types.h                  |    6 ---
 arch/score/include/asm/ucontext.h               |    1 -
 arch/score/include/asm/unaligned.h              |    6 ---
 arch/sparc/include/asm/Kbuild                   |    5 +++
 arch/sparc/include/asm/cputime.h                |    6 ---
 arch/sparc/include/asm/emergency-restart.h      |    6 ---
 arch/sparc/include/asm/kmap_types.h             |   10 -----
 arch/sparc/include/uapi/asm/kvm_para.h          |    1 -
 arch/sparc/include/uapi/asm/statfs.h            |    6 ---
 arch/tile/include/asm/Kbuild                    |    1 +
 arch/tile/include/asm/kvm_para.h                |    1 -
 arch/um/include/asm/Kbuild                      |    2 +-
 arch/um/include/asm/kvm_para.h                  |    1 -
 arch/unicore32/include/asm/Kbuild               |    1 +
 arch/unicore32/include/asm/kvm_para.h           |    1 -
 arch/x86/include/asm/Kbuild                     |   18 +++++++++
 arch/x86/include/asm/cputime.h                  |    1 -
 arch/x86/include/asm/errno.h                    |    1 -
 arch/x86/include/asm/fcntl.h                    |    1 -
 arch/x86/include/asm/ioctl.h                    |    1 -
 arch/x86/include/asm/ioctls.h                   |    1 -
 arch/x86/include/asm/ipcbuf.h                   |    1 -
 arch/x86/include/asm/local64.h                  |    1 -
 arch/x86/include/asm/msgbuf.h                   |    1 -
 arch/x86/include/asm/param.h                    |    1 -
 arch/x86/include/asm/poll.h                     |    1 -
 arch/x86/include/asm/resource.h                 |    1 -
 arch/x86/include/asm/rtc.h                      |    1 -
 arch/x86/include/asm/shmbuf.h                   |    1 -
 arch/x86/include/asm/socket.h                   |    1 -
 arch/x86/include/asm/sockios.h                  |    1 -
 arch/x86/include/asm/termbits.h                 |    1 -
 arch/x86/include/asm/termios.h                  |    1 -
 arch/x86/include/asm/types.h                    |    6 ---
 arch/xtensa/include/asm/Kbuild                  |   25 ++++++++++++
 arch/xtensa/include/asm/bitsperlong.h           |    1 -
 arch/xtensa/include/asm/bug.h                   |   18 ---------
 arch/xtensa/include/asm/cputime.h               |    6 ---
 arch/xtensa/include/asm/device.h                |    7 ----
 arch/xtensa/include/asm/div64.h                 |   16 --------
 arch/xtensa/include/asm/emergency-restart.h     |    6 ---
 arch/xtensa/include/asm/errno.h                 |   16 --------
 arch/xtensa/include/asm/fcntl.h                 |    1 -
 arch/xtensa/include/asm/futex.h                 |    1 -
 arch/xtensa/include/asm/hardirq.h               |   16 --------
 arch/xtensa/include/asm/ioctl.h                 |    1 -
 arch/xtensa/include/asm/irq_regs.h              |    1 -
 arch/xtensa/include/asm/kdebug.h                |    1 -
 arch/xtensa/include/asm/kmap_types.h            |    6 ---
 arch/xtensa/include/asm/kvm_para.h              |    1 -
 arch/xtensa/include/asm/local.h                 |   16 --------
 arch/xtensa/include/asm/local64.h               |    1 -
 arch/xtensa/include/asm/percpu.h                |   16 --------
 arch/xtensa/include/asm/resource.h              |   16 --------
 arch/xtensa/include/asm/scatterlist.h           |   16 --------
 arch/xtensa/include/asm/sections.h              |   16 --------
 arch/xtensa/include/asm/siginfo.h               |   16 --------
 arch/xtensa/include/asm/statfs.h                |   17 ---------
 arch/xtensa/include/asm/topology.h              |   16 --------
 arch/xtensa/include/asm/xor.h                   |   16 --------
 390 files changed, 369 insertions(+), 1378 deletions(-)
