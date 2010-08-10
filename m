Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab0HJJLJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 05:11:09 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:57956 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751422Ab0HJJLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 05:11:07 -0400
Date: Tue, 10 Aug 2010 11:11:02 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: David Howells <dhowells@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andreas Dilger <adilger@dilger.ca>, Jiri Kosina <jkosina@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 0/4] Removing dead code
Message-ID: <cover.1281431005.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!
       
        As part of the VAMOS[0] research project at the University of
Erlangen we are looking at multiple integrity errors in linux'
configuration system.

        I've been running a check on the arch/frv sourcetree for
config Items not defined in Kconfig and found 4 such cases. Sourcecode
blocks depending on these Items are not reachable from a vanilla
kernel -- dead code. I've seen such dead blocks made on purpose
e.g. while integrating new features into the kernel but generally
they're just useless.

        Each of the patches in this patchset removes on such dead
config Item, I'd be glad if you consider applying them. I've been
doing deeper analysis of such issues before and can do so again but
I'm not so sure they were fastly usefull.


I wasn't able to build a vanilla kernel allyesconfig, therefore these
patches might break something. But because they are just removing dead
code it is unlikely.

Another problem i encountered was CONFIG_PREEMPT, which isn't
selectable in frv Kconfig because it doesn include
kernel/Kconfig.preempt. But there ist plenty of evidence for me, that
there is preemption support in frv.


        Please keep me informed of this patch getting confirmed /
merged so we can keep track of it.

Regards

        Christian Dietrich

[0] http://vamos1.informatik.uni-erlangen.de/

Christian Dietrich (4):
  arch/frv: Removing dead RAMKERNEL config option
  arch/frv: Removing dead HEARTBEAT config option
  arch/frv: Removing dead NO_KERNEL_MSG config option
  arch/frv: Removing dead DEBUG_STACK_USAGE config option

 arch/frv/include/asm/bug.h         |    4 ----
 arch/frv/include/asm/thread_info.h |   11 -----------
 arch/frv/kernel/debug-stub.c       |    2 --
 arch/frv/kernel/time.c             |    6 ------
 arch/frv/mm/init.c                 |   17 -----------------
 5 files changed, 0 insertions(+), 40 deletions(-)

