Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab2H3WqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 18:46:25 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:32065 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab2H3WqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 18:46:23 -0400
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-mm@kvack.org, ngupta@vflare.org,
        konrad.wilk@oracle.com, sjenning@linux.vnet.ibm.com,
        minchan@kernel.org, dan.magenheimer@oracle.com
Subject: [PATCH 0/3] staging: ramster: move to new zcache2 code base
Date: Thu, 30 Aug 2012 15:46:01 -0700
Message-Id: <1346366764-31717-1-git-send-email-dan.magenheimer@oracle.com>
X-Mailer: git-send-email 1.7.5.1
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg --

gregkh> If you feel that the existing code needs to be dropped
gregkh> and replaced with a totally new version, that's fine with
gregkh> me.  It's forward progress, which is all that I ask for. 
(http://lkml.indiana.edu/hypermail/linux/kernel/1208.0/02240.html,
in reference to zcache, assuming applies to ramster as well)

Please apply for staging-next for the 3.7 window to move ramster forward.
Since AFAICT there have been no patches or contributions from others to
drivers/staging/ramster since it was merged, this totally new version
of ramster should not run afoul and the patches should apply to
3.5 or 3.6-rcN.

Thanks,
Dan

When ramster was merged into staging at 3.4, it used a "temporarily" forked
version of zcache.  Code was proposed to merge zcache and ramster into
a new common redesigned codebase which both resolves various serious design
flaws and eliminates all code duplication between zcache and ramster, with
the result to replace "zcache".  Sadly, that proposal was blocked, so the
zcache (and tmem) code in drivers/staging/zcache and the zcache (and tmem)
code in drivers/staging/ramster continue to be different.

This patchset moves ramster to the new redesigned codebase and calls that
new codebase "zcache2".  Most, if not all, of the redesign will eventually
need to be merged with "zcache1" before zcache functionality should be
promoted out of staging.

An overview of the zcache2 rewrite is provided in a git commit comment
later in this series.

A significant item of debate in the new codebase is the removal of zsmalloc.
This removal may be temporary if zsmalloc is enhanced with necessary
features to meet the needs of the new zcache codebase.  Justification
for the change can be found at http://lkml.org/lkml/2012/8/15/292
Such zsmalloc enhancments will almost certainly necessitate a major
rework, not a small patch.

While this zcache2 codebase is far from perfect (and thus remains in staging),
the foundation is now cleaner, more stable, more maintainable, and much
better commented.

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>

---
Diffstat:

 drivers/staging/Kconfig                            |    4 +-
 drivers/staging/Makefile                           |    2 +-
 drivers/staging/ramster/Kconfig                    |   25 +-
 drivers/staging/ramster/Makefile                   |    7 +-
 drivers/staging/ramster/TODO                       |   13 -
 drivers/staging/ramster/cluster/Makefile           |    3 -
 drivers/staging/ramster/cluster/heartbeat.c        |  464 ---
 drivers/staging/ramster/cluster/heartbeat.h        |   87 -
 drivers/staging/ramster/cluster/masklog.c          |  155 -
 drivers/staging/ramster/cluster/masklog.h          |  220 --
 drivers/staging/ramster/cluster/nodemanager.c      |  992 ------
 drivers/staging/ramster/cluster/nodemanager.h      |   88 -
 .../staging/ramster/cluster/ramster_nodemanager.h  |   39 -
 drivers/staging/ramster/cluster/tcp.c              | 2256 -------------
 drivers/staging/ramster/cluster/tcp.h              |  159 -
 drivers/staging/ramster/cluster/tcp_internal.h     |  248 --
 drivers/staging/ramster/r2net.c                    |  401 ---
 drivers/staging/ramster/ramster.h                  |  113 +-
 drivers/staging/ramster/ramster/heartbeat.c        |  462 +++
 drivers/staging/ramster/ramster/heartbeat.h        |   87 +
 drivers/staging/ramster/ramster/masklog.c          |  155 +
 drivers/staging/ramster/ramster/masklog.h          |  220 ++
 drivers/staging/ramster/ramster/nodemanager.c      |  995 ++++++
 drivers/staging/ramster/ramster/nodemanager.h      |   88 +
 drivers/staging/ramster/ramster/r2net.c            |  414 +++
 drivers/staging/ramster/ramster/ramster.c          |  985 ++++++
 drivers/staging/ramster/ramster/ramster.h          |  161 +
 .../staging/ramster/ramster/ramster_nodemanager.h  |   39 +
 drivers/staging/ramster/ramster/tcp.c              | 2253 +++++++++++++
 drivers/staging/ramster/ramster/tcp.h              |  159 +
 drivers/staging/ramster/ramster/tcp_internal.h     |  248 ++
 drivers/staging/ramster/tmem.c                     |  313 +-
 drivers/staging/ramster/tmem.h                     |  109 +-
 drivers/staging/ramster/xvmalloc.c                 |  509 ---
 drivers/staging/ramster/xvmalloc.h                 |   30 -
 drivers/staging/ramster/xvmalloc_int.h             |   95 -
 drivers/staging/ramster/zbud.c                     | 1060 ++++++
 drivers/staging/ramster/zbud.h                     |   33 +
 drivers/staging/ramster/zcache-main.c              | 3532 ++++++--------------
 drivers/staging/ramster/zcache.h                   |   55 +-
 40 files changed, 8711 insertions(+), 8567 deletions(-)
