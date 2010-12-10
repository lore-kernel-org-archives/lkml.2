Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab0LJVLz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 16:11:55 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:63594 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205Ab0LJVLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 16:11:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=esTPuzLJbno7qD+RK30JJu0SQRBmTZjcMRMRFkOyNrrtavW7ybKPyeya2NZKfnSrRd
         vVs3n1A9WVIU7HunyZLtF5V9mILQBZ6lPkNzTmUbshUVhcQjB5orSXn/4osxI9xHBn68
         1zCo+EPnbn4emUlH5Bsxsxoppaqw1BW1vokr0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 0/2 v2] rcu: Fix series of spurious RCU softirqs
Date: Fri, 10 Dec 2010 22:11:09 +0100
Message-Id: <1292015471-19227-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Following Lai's idea.

An example of such series of spurious softirqs:

http://tglx.de/~fweisbec/trace_rcu_softirq.txt

In that example, the rcu softirq is raised at every tick
during 20 secs (was perhaps more, but the trace snapshot happened
during 20 secs). It happens randomly.

Ah and it survived several hours of rcutorture (with rcu cpu stall
detection).

Thanks.

Frederic Weisbecker (2):
  rcu: Stop chasing QS if another CPU did it for us
  rcu: Keep gpnum and completed fields synchronized

 kernel/rcutree.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

-- 
1.7.3.2

