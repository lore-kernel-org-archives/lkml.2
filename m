Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab1HVQDq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 12:03:46 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:25490 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab1HVQDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 12:03:44 -0400
Date: Mon, 22 Aug 2011 12:02:57 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, rdunlap@xenotime.net,
        stefan.bader@canonical.com, JBeulich@novell.com
Subject: [GIT PULL] (xen) stable/bug.fixes for 3.1-rc2
Message-ID: <20110822160257.GI8944@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4E527DBC.0061:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

Please git pull:

 git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/bug.fixes

which has some patches that have been there since last week - but the LinuxCon
interrupted my process a bit so sending it late.

The patches are based off git commit c00c8aa2d976e9ed1d12a57b42d6e9b27efb7abe:
Konrad Rzeszutek Wilk (1):
  xen/trace: Fix compile error when CONFIG_XEN_PRIVILEGED_GUEST is not set

which you pulled in 3.1-rc1.

Anyhow, this git pull has two boring compile fixes, and then two exciting bug-fixes. The
exciting bug-fixes are 1) Jan's fix to check the ceiling of our M2P table - we
did it slowly and potentially could read userspace pages (oops!) to find out our frame
numbers, being a potential security risk; 2) fix PVonHVM to work with older hypervisors
that don't support callbacks - we have code that does it, but missed one case - leading
to crashes with more than 4 VCPUs.

 arch/x86/include/asm/xen/page.h |    4 ++--
 arch/x86/xen/Makefile           |    2 +-
 arch/x86/xen/enlighten.c        |    4 ++--
 arch/x86/xen/mmu.c              |   12 ++++++++----
 arch/x86/xen/smp.c              |    4 ++--
 5 files changed, 15 insertions(+), 11 deletions(-)

Jan Beulich (1):
      xen/x86: replace order-based range checking of M2P table by linear one

Jeremy Fitzhardinge (1):
      xen/tracing: Fix tracing config option properly

Randy Dunlap (1):
      xen: xen-selfballoon.c needs more header files

Stefano Stabellini (1):
      xen: Do not enable PV IPIs when vector callback not present

P.S.
If you look in the commits date, you will notice Stefano's patch (and the
subsequent ones) being modified about 30 minutes ago - it did not have his SOB
on it - so I updated it just now using 'git rebase'. Rest assured, the patches
had been for some time in #linux-next:
http://git.kernel.org/?p=linux/kernel/git/konrad/xen.git;a=shortlog;h=refs/heads/linux-next
