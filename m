Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab0ERQLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 12:11:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:56853 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754105Ab0ERQLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 12:11:15 -0400
Message-ID: <4BF2BBEC.7010506@kernel.org>
Date: Tue, 18 May 2010 18:10:20 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
CC: David Howells <dhowells@redhat.com>, graff yang <graff.yang@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       Sonic Zhang <sonic.adi@gmail.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: [GIT PULL] percpu for v2.6.35-rc1
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 18 May 2010 16:10:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please pull from the following branch to receive percpu changes for
2.6.35-rc1.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-linus

There are six commits.  One is to add sparse annotation to ia64.  All
the others are to implement nommu percpu support.  blackfin does SMP
w/o mmu and thus requires percpu allocator which doesn't make use of
remapping in the vmalloc area.  Percpu chunk [de]allocation and
[de]population code paths are factored out and nommu simply allocates
contiguous kernel memory for each unit.

Thanks.

Tejun Heo (6):
      percpu: factor out pcpu_addr_in_first/reserved_chunk() and update per_cpu_ptr_to_phys()
      percpu: reorganize chunk creation and destruction
      percpu: misc preparations for nommu support
      percpu: move vmalloc based chunk management into percpu-vm.c
      percpu: implement kernel memory based chunk allocation
      ia64: add sparse annotation to __ia64_per_cpu_var()

 arch/ia64/include/asm/percpu.h |    5 +-
 mm/percpu-km.c                 |  104 +++++++
 mm/percpu-vm.c                 |  451 +++++++++++++++++++++++++++++++
 mm/percpu.c                    |  585 ++++++++--------------------------------
 4 files changed, 671 insertions(+), 474 deletions(-)
 create mode 100644 mm/percpu-km.c
 create mode 100644 mm/percpu-vm.c

--
tejun
