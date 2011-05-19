Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933552Ab1ESQdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 12:33:35 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:33305 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933117Ab1ESQdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 12:33:33 -0400
Date: Thu, 19 May 2011 12:33:13 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: dkiper@net-space.pl, Ian Campbell <Ian.Campbell@eu.citrix.com>
Subject: [GIT PULL] (xen) stable/balloon.cleanup stable/general.cleanup
Message-ID: <20110519163313.GB13186@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090202.4DD54655.0162:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

Please git pull the following two branches:

 git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/balloon.cleanup stable/general.cleanup


The #stable/balloon.cleanup is based off v2.6.39-rc1 (0ce790e7d736cedc563e1fb4e998babf5a4dbc3d)

and cleans up the drivers/xen/balloon.c to make it easier to read and as well
prep it up hotplug memory code written by Daniel Kiper, an Google Summer of Code
student.

The #stable/general.cleanup, which is based of a particular git commit in the
2.6.39-rc6-ish: "Merge branch 'stable/bug-fixes-for-rc7' of git://git.kernel.org/../konrad"
with git commit 0c5e1577f1108e88475ca7b7ca75c411460173e1. This was due to the fact
that at that point in time there was no nice tag to base it off and the patches depended
on that merge. Anyhow, the patches cleanup the __init* usage in Xen code as well
clean up the Makefile.

The full diffstat:

 arch/x86/xen/enlighten.c     |   20 ++++++++++----------
 arch/x86/xen/irq.c           |    2 +-
 arch/x86/xen/mmu.c           |   34 +++++++++++++++++-----------------
 arch/x86/xen/setup.c         |    4 ++--
 arch/x86/xen/smp.c           |    8 ++++----
 arch/x86/xen/time.c          |    8 ++++----
 arch/x86/xen/xen-ops.h       |    2 +-
 drivers/xen/Makefile         |   24 ++++++++++++------------
 drivers/xen/balloon.c        |   25 +++++++++++--------------
 drivers/xen/sys-hypervisor.c |    2 +-
 10 files changed, 63 insertions(+), 66 deletions(-)

And log:

Daniel Kiper (12):
      xen/balloon: Use PageHighMem() for high memory page detection
      xen/balloon: Simplify HVM integration
      xen/balloon: Clarify credit calculation
      xen/balloon: Move dec_totalhigh_pages() from __balloon_append() to balloon_append()
      arch/x86/xen/irq: Cleanup code/data sections definitions
      arch/x86/xen/enlighten: Cleanup code/data sections definitions
      arch/x86/xen/setup: Cleanup code/data sections definitions
      arch/x86/xen/mmu: Cleanup code/data sections definitions
      arch/x86/xen/xen-ops: Cleanup code/data sections definitions
      arch/x86/xen/time: Cleanup code/data sections definitions
      arch/x86/xen/smp: Cleanup code/data sections definitions
      drivers/xen/sys-hypervisor: Cleanup code/data sections definitions

Ian Campbell (1):
      xen: tidy up whitespace in drivers/xen/Makefile

