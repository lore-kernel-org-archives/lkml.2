Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031Ab1COK3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 06:29:31 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42923 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab1COK33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 06:29:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=n+PixGqWVkk8nhc+B8y5XgkoHoOMu8zXnVvajSbznE0y4AEVJJTZ7vk6MNkA9dtXHz
         HnKgAy74lTMSQFVV1rdB93bRbpcaNtVevMrypxiJONruImo0Rw4JRriV28s324PnBVh2
         3oq/MEXWxAr2uSfhMksDZaR3pSIJ0UEZQq+Xc=
Date: Tue, 15 Mar 2011 11:29:25 +0100
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux.com>
Subject: [GIT PULL] percpu: changes for 2.6.39-rc1
Message-ID: <20110315102925.GH8635@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please pull from the following git branch to receive percpu changes
for 2.6.39-rc1.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-2.6.39

Only four commits.  Two for aligning percpu readmostly subsection to
cacheline to avoid sharing a cacheline with rw data.  The other two
from Christoph implement this_cpu_cmpxchg_double() which is a rather
nasty operation which does cmpxchg on two long's, which x86 supports
with cmpxchg{8,16}b instructions.  This is used by sl?b allocators to
implement lockless operation and shows measurable performance
improvements in hot paths.

Thanks.

Christoph Lameter (2):
      percpu: Generic support for this_cpu_cmpxchg_double()
      percpu, x86: Add arch-specific this_cpu_cmpxchg_double() support

Tejun Heo (2):
      percpu: align percpu readmostly subsection to cacheline
      alpha: use L1_CACHE_BYTES for cacheline size in the linker script

 arch/alpha/kernel/vmlinux.lds.S    |    5 +-
 arch/arm/kernel/vmlinux.lds.S      |    2 +-
 arch/blackfin/kernel/vmlinux.lds.S |    2 +-
 arch/cris/kernel/vmlinux.lds.S     |    2 +-
 arch/frv/kernel/vmlinux.lds.S      |    2 +-
 arch/ia64/kernel/vmlinux.lds.S     |    2 +-
 arch/m32r/kernel/vmlinux.lds.S     |    2 +-
 arch/mips/kernel/vmlinux.lds.S     |    2 +-
 arch/mn10300/kernel/vmlinux.lds.S  |    2 +-
 arch/parisc/kernel/vmlinux.lds.S   |    2 +-
 arch/powerpc/kernel/vmlinux.lds.S  |    2 +-
 arch/s390/kernel/vmlinux.lds.S     |    2 +-
 arch/sh/kernel/vmlinux.lds.S       |    2 +-
 arch/sparc/kernel/vmlinux.lds.S    |    2 +-
 arch/tile/kernel/vmlinux.lds.S     |    2 +-
 arch/um/include/asm/common.lds.S   |    2 +-
 arch/x86/include/asm/percpu.h      |   48 +++++++++++++
 arch/x86/kernel/vmlinux.lds.S      |    4 +-
 arch/x86/lib/Makefile              |    1 +
 arch/x86/lib/cmpxchg16b_emu.S      |   59 ++++++++++++++++
 arch/xtensa/kernel/vmlinux.lds.S   |    2 +-
 include/asm-generic/vmlinux.lds.h  |   35 ++++++----
 include/linux/percpu.h             |  128 ++++++++++++++++++++++++++++++++++++
 23 files changed, 279 insertions(+), 33 deletions(-)
 create mode 100644 arch/x86/lib/cmpxchg16b_emu.S

-- 
tejun
