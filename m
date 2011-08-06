Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab1HFPNw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 11:13:52 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:48135 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab1HFPNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 11:13:49 -0400
Date: Sat, 6 Aug 2011 11:13:22 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, rdunlap@xenotime.net,
        imammedo@redhat.com, linux@eikelenboom.it, mingo@elte.hu
Subject: [GIT PULL] (xen) stable/bug.fixes for 3.1-rc0 (or rc1)
Message-ID: <20110806151321.GA21552@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090208.4E3D5A1F.003C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

Please pull

git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/bug.fixes

which is based off this 3.0 post commit b993fdbc7fe26f96b59003a3552c418a71aa0a9f
Linus Torvalds (1)
    Merge branch 'upstream/xen-tracing2' of git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen

The reason for picking that specific branch is that two of that patches directly
fix the xen-tracing code. Another way might be to base the patches on 'upstream/xen-tracing2' tree,
but I didn't have that locally - Jeremy pushed that to you - hence this. If you would prefer
that Jeremy push the two fixes for xen-tracing2 from his tree we can definitly arrange that.

Back to the description: Couple of fixes for various combinations of CONFIG_, cleanup
patches from Igor to make initial bootup reporting easier to grok, and removing some
compile warnings.

Huang Weiyi (1):
      xen/pciback: remove duplicated #include

Igor Mammedov (2):
      xen: Fix printk() format in xen/setup.c
      xen: Fix misleading WARN message at xen_release_chunk

Jeremy Fitzhardinge (1):
      xen/tracing: it looks like we wanted CONFIG_FTRACE

Konrad Rzeszutek Wilk (4):
      xen/grant: Fix compile warning.
      xen/balloon: Fix compile errors - missing header files.
      xen/self-balloon: Add dependency on tmem.
      xen/trace: Fix compile error when CONFIG_XEN_PRIVILEGED_GUEST is not set

 arch/x86/xen/Makefile            |    2 +-
 arch/x86/xen/setup.c             |   10 ++++------
 arch/x86/xen/trace.c             |    1 +
 drivers/xen/Kconfig              |    2 +-
 drivers/xen/grant-table.c        |    2 +-
 drivers/xen/xen-pciback/xenbus.c |    1 -
 drivers/xen/xen-selfballoon.c    |    4 ++--
 7 files changed, 10 insertions(+), 12 deletions(-)
