Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555Ab0G2P2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 11:28:44 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:40012 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753848Ab0G2P2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 11:28:43 -0400
Date: Thu, 29 Jul 2010 17:28:40 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Jeff Dike <jdike@addtoit.com>, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 0/3] Removing dead code
Message-ID: <cover.1280417117.git.siccegge@cs.fau.de>
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

        I've been running a check on the arch/um sourcetree for config
Items not defined in Kconfig and found 10 such cases. Sourcecode
blocks depending on these Items are not reachable from a vanilla
kernel -- dead code. I've seen such dead blocks made on purpose
e.g. while integrating new features into the kernel but generally
they're just useless.

        Each of the patches in this patchset removes on such dead
config Item, I'd be glad if you consider applying them. I've been
doing deeper analysis of such issues before and can do so again but
I'm not so sure they were fastly usefull.

        I build the patches against a vanilla kernel in order to
try if the kernel compiles with this patches. As reported earlier
today the build currently fails for plain um but adding this patchset
doesn't change the failing in any way. That was a i386 build.

        Please keep me informed of this patch getting confirmed /
merged so we can keep track of it.

Regards

        Christoph Egger

[0] http://vamos1.informatik.uni-erlangen.de/

Christoph Egger (3):
  Removing dead PROC_MM
  Removing conditionalizing containing exactly the same code
  Removing dead copy&paste code

 arch/um/kernel/ptrace.c                   |   21 ---------------------
 arch/um/sys-i386/asm/archparam.h          |    4 ----
 arch/um/sys-i386/shared/sysdep/system.h   |   11 +----------
 arch/um/sys-ppc/misc.S                    |    6 ------
 arch/um/sys-ppc/shared/sysdep/ptrace.h    |    5 +----
 arch/um/sys-x86_64/shared/sysdep/system.h |   10 +---------
 6 files changed, 3 insertions(+), 54 deletions(-)

