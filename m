Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758952Ab0ENKLJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 06:11:09 -0400
Received: from tundra.namei.org ([65.99.196.166]:56288 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756251Ab0ENKLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 06:11:05 -0400
Date: Fri, 14 May 2010 20:10:39 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Adam Lackorzynski <adam@os.inf.tu-dresden.de>,
       Eric Paris <eparis@redhat.com>, stable@kernel.org
Subject: [GIT] security/mm: fix regression introduced by mmap_min_addr
 check
Message-ID: <alpine.LRH.2.00.1005142002020.32112@tundra.namei.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A check for CAP_SYS_RAWIO was introduced when accessing 
/proc/sys/vm/mmap_min_addr in the following patch:

commit 0e1a6ef2dea88101b056b6d9984f3325c5efced3
Author: Kees Cook <kees.cook@canonical.com>
Date:   Sun Nov 8 09:37:00 2009 -0800

    sysctl: require CAP_SYS_RAWIO to set mmap_min_addr

this has caused regressions for unprivileged userland apps which want to 
read this value:

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/568844

A patch to fix this has been in -next for some time, and given the reports 
of userland breakage, it should probably go into mainline before 2.6.34 -- 
please pull per the request below.

(The patch may also be suitable for the 2.6.32 and 2.6.33 stable trees).


The following changes since commit 6a251b0ab67989f468f4cb65179e0cf40cf8c295:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../sameo/mfd-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6 for-linus

Kees Cook (1):
      mmap_min_addr check CAP_SYS_RAWIO only for write

 security/min_addr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


-- 
James Morris
<jmorris@namei.org>
