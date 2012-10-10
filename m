Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751160Ab2JJEgm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 00:36:42 -0400
Received: from gate.crashing.org ([63.228.1.57]:36747 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003Ab2JJEgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 00:36:41 -0400
Message-ID: <1349843784.20486.70.camel@pasglop>
Subject: Re: [GIT PULL] Disintegrate UAPI for powerpc [ver #2]
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 10 Oct 2012 15:36:24 +1100
In-Reply-To: <21173.1349774149@warthog.procyon.org.uk>
References: <21173.1349774149@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-09 at 10:15 +0100, David Howells wrote:
> Can you merge the following branch into the powerpc tree please.
> 
> This is to complete part of the UAPI disintegration for which the preparatory
> patches were pulled recently.

This is now in the powerpc "merge" branch:

git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Linus, free free to pull it.

Note that upstream Linus (and thus this branch) fails to build powerpc
configs with memory hotplug enabled due to Andrew merging a completely
untested and un-next'ed patch :-) (tsk tsk tsk !)

I assume you (Andrew) already has a fix on its way to Linus so I haven't
put it in this branch.

Cheers,
Ben.


> Now that the fixups and the asm-generic chunk have been merged, I've
> regenerated the patches to get rid of those dependencies and to take account of
> any changes made so far in the merge window.  If you have already pulled the
> older version of the branch aimed at you, then please feel free to ignore this
> request.
> 
> The following changes since commit 9e2d8656f5e8aa214e66b462680cf86b210b74a8:
> 
>   Merge branch 'akpm' (Andrew's patch-bomb) (2012-10-09 16:23:15 +0900)
> 
> are available in the git repository at:
> 
> 
>   git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-powerpc-20121009
> 
> for you to fetch changes up to c3617f72036c909e1f6086b5b9e364e0ef90a6da:
> 
>   UAPI: (Scripted) Disintegrate arch/powerpc/include/asm (2012-10-09 09:47:26 +0100)
> 
> ----------------------------------------------------------------
> UAPI Disintegration 2012-10-09
> 
> ----------------------------------------------------------------
> David Howells (1):
>       UAPI: (Scripted) Disintegrate arch/powerpc/include/asm
> 
>  arch/powerpc/include/asm/Kbuild                   |  35 --
>  arch/powerpc/include/asm/bootx.h                  | 123 +------
>  arch/powerpc/include/asm/cputable.h               |  35 +-
>  arch/powerpc/include/asm/elf.h                    | 311 +-----------------
>  arch/powerpc/include/asm/kvm_para.h               |  70 +---
>  arch/powerpc/include/asm/mman.h                   |  27 +-
>  arch/powerpc/include/asm/nvram.h                  |  55 +---
>  arch/powerpc/include/asm/ptrace.h                 | 242 +-------------
>  arch/powerpc/include/asm/signal.h                 | 143 +-------
>  arch/powerpc/include/asm/spu_info.h               |  29 +-
>  arch/powerpc/include/asm/swab.h                   |  15 +-
>  arch/powerpc/include/asm/termios.h                |  69 +---
>  arch/powerpc/include/asm/types.h                  |  30 +-
>  arch/powerpc/include/asm/unistd.h                 | 374 +--------------------
>  arch/powerpc/include/uapi/asm/Kbuild              |  41 +++
>  arch/powerpc/include/{ => uapi}/asm/auxvec.h      |   0
>  arch/powerpc/include/{ => uapi}/asm/bitsperlong.h |   0
>  arch/powerpc/include/uapi/asm/bootx.h             | 132 ++++++++
>  arch/powerpc/include/{ => uapi}/asm/byteorder.h   |   0
>  arch/powerpc/include/uapi/asm/cputable.h          |  36 ++
>  arch/powerpc/include/uapi/asm/elf.h               | 307 +++++++++++++++++
>  arch/powerpc/include/{ => uapi}/asm/errno.h       |   0
>  arch/powerpc/include/{ => uapi}/asm/fcntl.h       |   0
>  arch/powerpc/include/{ => uapi}/asm/ioctl.h       |   0
>  arch/powerpc/include/{ => uapi}/asm/ioctls.h      |   0
>  arch/powerpc/include/{ => uapi}/asm/ipcbuf.h      |   0
>  arch/powerpc/include/{ => uapi}/asm/kvm.h         |   0
>  arch/powerpc/include/uapi/asm/kvm_para.h          |  90 +++++
>  arch/powerpc/include/{ => uapi}/asm/linkage.h     |   0
>  arch/powerpc/include/uapi/asm/mman.h              |  31 ++
>  arch/powerpc/include/{ => uapi}/asm/msgbuf.h      |   0
>  arch/powerpc/include/uapi/asm/nvram.h             |  62 ++++
>  arch/powerpc/include/{ => uapi}/asm/param.h       |   0
>  arch/powerpc/include/{ => uapi}/asm/poll.h        |   0
>  arch/powerpc/include/{ => uapi}/asm/posix_types.h |   0
>  arch/powerpc/include/{ => uapi}/asm/ps3fb.h       |   0
>  arch/powerpc/include/uapi/asm/ptrace.h            | 259 +++++++++++++++
>  arch/powerpc/include/{ => uapi}/asm/resource.h    |   0
>  arch/powerpc/include/{ => uapi}/asm/seccomp.h     |   0
>  arch/powerpc/include/{ => uapi}/asm/sembuf.h      |   0
>  arch/powerpc/include/{ => uapi}/asm/setup.h       |   0
>  arch/powerpc/include/{ => uapi}/asm/shmbuf.h      |   0
>  arch/powerpc/include/{ => uapi}/asm/sigcontext.h  |   0
>  arch/powerpc/include/{ => uapi}/asm/siginfo.h     |   0
>  arch/powerpc/include/uapi/asm/signal.h            | 145 +++++++++
>  arch/powerpc/include/{ => uapi}/asm/socket.h      |   0
>  arch/powerpc/include/{ => uapi}/asm/sockios.h     |   0
>  arch/powerpc/include/uapi/asm/spu_info.h          |  53 +++
>  arch/powerpc/include/{ => uapi}/asm/stat.h        |   0
>  arch/powerpc/include/{ => uapi}/asm/statfs.h      |   0
>  arch/powerpc/include/uapi/asm/swab.h              |  23 ++
>  arch/powerpc/include/{ => uapi}/asm/termbits.h    |   0
>  arch/powerpc/include/uapi/asm/termios.h           |  76 +++++
>  arch/powerpc/include/uapi/asm/types.h             |  40 +++
>  arch/powerpc/include/{ => uapi}/asm/ucontext.h    |   0
>  arch/powerpc/include/uapi/asm/unistd.h            | 380 ++++++++++++++++++++++
>  56 files changed, 1705 insertions(+), 1528 deletions(-)
>  rename arch/powerpc/include/{ => uapi}/asm/auxvec.h (100%)
>  rename arch/powerpc/include/{ => uapi}/asm/bitsperlong.h (100%)
>  create mode 100644 arch/powerpc/include/uapi/asm/bootx.h
>  rename arch/powerpc/include/{ => uapi}/asm/byteorder.h (100%)
>  create mode 100644 arch/powerpc/include/uapi/asm/cputable.h
>  create mode 100644 arch/powerpc/include/uapi/asm/elf.h
>  rename arch/powerpc/include/{ => uapi}/asm/errno.h (100%)
>  rename arch/powerpc/include/{ => uapi}/asm/fcntl.h (100%)
>  rename arch/powerpc/include/{ => uapi}/asm/ioctl.h (100%)
>  rename arch/powerpc/include/{ => uapi}/asm/ioctls.h (100%)
>  rename arch/powerpc/include/{ => uapi}/asm/ipcbuf.h (100%)
>  rename arch/powerpc/include/{ => uapi}/asm/kvm.h (100%)
>  create mode 100644 arch/powerpc/include/uapi/asm/kvm_para.h
>  rename arch/powerpc/include/{ => uapi}/asm/linkage.h (100%)
>  create mode 100644 arch/powerpc/include/uapi/asm/mman.h
>  rename arch/powerpc/include/{ => uapi}/asm/msgbuf.h (100%)
>  create mode 100644 arch/powerpc/include/uapi/asm/nvram.h
>  rename arch/powerpc/include/{ => uapi}/asm/param.h (100%)
>  rename arch/powerpc/include/{ => uapi}/asm/poll.h (100%)
>  rename arch/powerpc/include/{ => uapi}/asm/posix_types.h (100%)
>  rename arch/powerpc/include/{ => uapi}/asm/ps3fb.h (100%)
>  create mode 100644 arch/powerpc/include/uapi/asm/ptrace.h
>  rename arch/powerpc/include/{ => uapi}/asm/resource.h (100%)
>  rename arch/powerpc/include/{ => uapi}/asm/seccomp.h (100%)
>  rename arch/powerpc/include/{ => uapi}/asm/sembuf.h (100%)
>  rename arch/powerpc/include/{ => uapi}/asm/setup.h (100%)
>  rename arch/powerpc/include/{ => uapi}/asm/shmbuf.h (100%)
>  rename arch/powerpc/include/{ => uapi}/asm/sigcontext.h (100%)
>  rename arch/powerpc/include/{ => uapi}/asm/siginfo.h (100%)
>  create mode 100644 arch/powerpc/include/uapi/asm/signal.h
>  rename arch/powerpc/include/{ => uapi}/asm/socket.h (100%)
>  rename arch/powerpc/include/{ => uapi}/asm/sockios.h (100%)
>  create mode 100644 arch/powerpc/include/uapi/asm/spu_info.h
>  rename arch/powerpc/include/{ => uapi}/asm/stat.h (100%)
>  rename arch/powerpc/include/{ => uapi}/asm/statfs.h (100%)
>  create mode 100644 arch/powerpc/include/uapi/asm/swab.h
>  rename arch/powerpc/include/{ => uapi}/asm/termbits.h (100%)
>  create mode 100644 arch/powerpc/include/uapi/asm/termios.h
>  create mode 100644 arch/powerpc/include/uapi/asm/types.h
>  rename arch/powerpc/include/{ => uapi}/asm/ucontext.h (100%)
>  create mode 100644 arch/powerpc/include/uapi/asm/unistd.h
> .


