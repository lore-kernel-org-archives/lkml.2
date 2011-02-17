Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab1BQKWy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 05:22:54 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42054 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab1BQKWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 05:22:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=wnY9WYyN6hquUBvqFGYvnyXQHuoe5pppC5NCdb95/6vhX2o3PQF+U/7D4oxYw4hX58
         oJ/9mNEMcoB9pMjxSdbbZMwWokVlqJ2wsYi5snO85V5aEyiAJgRnIS/c00sOsy2pP25q
         aGt+6cq5spYbdSvzErVBI/7Zuvz+/nueog7ZY=
Date: Thu, 17 Feb 2011 11:22:46 +0100
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ray Jui <rjui@broadcom.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [GIT PULL] workqueue: changes for 2.6.38-rc5
Message-ID: <20110217102246.GP19830@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please pull from the following git branch to receive workqueue changes
for 2.6.38-rc5.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git fixes-2.6.38

The branch contains three patches.  Two of them fix the rescuer so
that they doen't get invoked too soon or stall work execution after
themselves.

The left patch substitutes 'freezeable' with 'freezable'.  The
spelling with an extra 'e' has been used by the workqueue from the
beginning but is different from what the PM code is using.  This is
not a fix but I think it would be the least painful to do this in
mainline while it is mostly stable.

Thank you.

Tejun Heo (3):
      workqueue: wake up a worker when a rescuer is leaving a gcwq
      workqueue, freezer: unify spelling of 'freeze' + 'able' to 'freezable'
      workqueue: make sure MAYDAY_INITIAL_TIMEOUT is at least 2 jiffies long

 Documentation/workqueue.txt      |    4 ++--
 drivers/memstick/core/memstick.c |    2 +-
 drivers/misc/tifm_core.c         |    2 +-
 drivers/misc/vmw_balloon.c       |    2 +-
 drivers/mtd/nand/r852.c          |    2 +-
 drivers/mtd/sm_ftl.c             |    2 +-
 drivers/net/can/mcp251x.c        |    2 +-
 drivers/tty/serial/max3100.c     |    2 +-
 drivers/tty/serial/max3107.c     |    2 +-
 fs/gfs2/glock.c                  |    4 ++--
 fs/gfs2/main.c                   |    2 +-
 include/linux/freezer.h          |    2 +-
 include/linux/sched.h            |    2 +-
 include/linux/workqueue.h        |    8 ++++----
 kernel/power/main.c              |    2 +-
 kernel/power/process.c           |    6 +++---
 kernel/workqueue.c               |   37 ++++++++++++++++++++++++-------------
 17 files changed, 47 insertions(+), 36 deletions(-)

-- 
tejun
