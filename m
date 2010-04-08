Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437Ab0DHENU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 00:13:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:53244 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506Ab0DHEMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 00:12:22 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, graff.yang@gmail.com, dhowells@redhat.com,
       akpm@linux-foundation.org, uclinux-dist-devel@blackfin.uclinux.org,
       sonic.adi@gmail.com, cl@linux-foundation.org, mingo@elte.hu
Subject: percpu: implement nommu support
Date: Thu,  8 Apr 2010 13:11:00 +0900
Message-Id: <1270699865-16954-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 08 Apr 2010 04:11:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset implements nommu support in percpu allocator.  Chunk
alloc/free/(de)populate codes are separated into a separate file so
that different flavor can be included depending on configuration.  The
default vmalloc area based version now lives in percpu-vm.c and the
new kernel memory based one lives in percpu-km.c and can be selected
by CONFIG_NEED_PER_CPU_KM.

percpu-km allocates each chunk as contigus area in kernel memory using
alloc_pages().  For details on usage and limitations, please read the
patch description and comment in mm/percpu-km.c.

This patchset contains the following five patches.

 0001-percpu-factor-out-pcpu_addr_in_first-reserved_chunk-.patch
 0002-percpu-reorganize-chunk-creation-and-destruction.patch
 0003-percpu-misc-preparations-for-nommu-support.patch
 0004-percpu-move-vmalloc-based-chunk-management-into-perc.patch
 0005-percpu-implement-kernel-memory-based-chunk-allocatio.patch

0001-0003 prepare for future changes - factor things out, relocate,
clean up.

0004 separates out the default vmalloc based chunk management into
percpu-vm.c.

0005 implements percpu-km.c.

The following git branch contains these patches.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git nommu

I've tested percpu-km on x86_64 w/ configuration and percpu init code
massged.  Sonic Zhang tested it on blackfin and reports it works fine
there too (Sonic, please base further tests on these new patches).
I'll wait several days for review and further test results and then
push these patches to linux-next.

This patchset contains the following changes.

 mm/percpu-km.c |  104 ++++++++++
 mm/percpu-vm.c |  451 ++++++++++++++++++++++++++++++++++++++++++++
 mm/percpu.c    |  584 ++++++++++-----------------------------------------------
 3 files changed, 664 insertions(+), 475 deletions(-)

Thanks.

--
tejun
