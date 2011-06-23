Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934566Ab1FWXMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 19:12:52 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45549 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932730Ab1FWXMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 19:12:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=GNpjxaa5asqIwBORePJhNh0zMpctW0lCPjJLGODuNraUzGRJ0Ob9FlFeCD280NBREk
         1SgpCAXV3NLSSfwiwM2zMF1vErLZJ2xg1cmo4g8beX2oxZwF9eD6zRyKleLUqoohShZn
         Z/6u5gVkUQfYUxqAN1re+6UzRw3ojwx14KbNE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 0/3 v3] rcu: Detect rcu uses under extended quiescent state
Date: Fri, 24 Jun 2011 01:12:37 +0200
Message-Id: <1308870760-14153-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This time I have no current practical cases to fix. Those I fixed
in previous versions were actually using rcu_dereference_raw(), which
is legal in extended qs.

Frederic Weisbecker (3):
  rcu: Detect illegal rcu dereference in extended quiescent state
  rcu: Inform the user about dynticks idle mode on PROVE_RCU warning
  rcu: Warn when rcu_read_lock() is used in extended quiescent state

 include/linux/rcupdate.h |   68 +++++++++++++++++++++++++++++++++++++++-------
 kernel/lockdep.c         |    4 +++
 kernel/rcupdate.c        |    4 +++
 kernel/rcutiny.c         |   13 +++++++++
 kernel/rcutree.c         |   14 +++++++++
 5 files changed, 93 insertions(+), 10 deletions(-)

-- 
1.7.5.4

