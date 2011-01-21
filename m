Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab1AURh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 12:37:29 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61694 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab1AURh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 12:37:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=qJLmvhZcSMEytghhFdEW0BaZkvXDJjTaxgazVoDxVh1vzLxAC3Jo9CMMmtDQ82ZpmW
         wKrJ9//VaadFlIru2fIOo22qgQbti2Kf6z7alUWzcPMyDFUhGhjfOSNlGg0BV/c+nVZ2
         SwSzwktGZct8cuZq5T56KKP1Vne5Cqaxi/QR0=
Date: Fri, 21 Jan 2011 18:37:23 +0100
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [GIT PULL] workqueue fixes for v2.6.38-rc1
Message-ID: <20110121173723.GL2832@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please pull from the following branch to receive workqueue fixes.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git fixes-2.6.38

It contains two patches.  One relaxes lockdep annotation for
flush_work() such that it doesn't trigger spuriously when a work tries
to flush another work on the same multi-concurrency workqueue.  The
other one just adds comment explaining a misleading piece of code.

Tejun Heo (2):
      workqueue: relax lockdep annotation on flush_work()
      workqueue: note the nested NOT_RUNNING test in worker_clr_flags() isn't a noop

 include/linux/lockdep.h |    3 +++
 kernel/workqueue.c      |   20 +++++++++++++++++---
 2 files changed, 20 insertions(+), 3 deletions(-)

Thanks.

--
tejun
