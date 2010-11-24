Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701Ab0KXAbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 19:31:20 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53469 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288Ab0KXAbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 19:31:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=eFoB2HxmzY2U1NnjKPK3aQdRmz91JGzGBUFSbKHUGhUcZQJZrDlsNeVCXdvmB8uVT5
         z+m/7b3f86ogRlJzbiOhfPOpj5TSmqRamlPlCZqX267aOdgjvWEzuMm6lGI4KIk+NO4T
         qEMiFMJNJFpEnUEGu6dZh/K0Z0WnCaZLmyaq4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 0/2] rcu: Fix series of spurious RCU softirqs
Date: Wed, 24 Nov 2010 01:31:11 +0100
Message-Id: <1290558673-23580-1-git-send-crap-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've observed some not so unfrequent series of spurious rcu
softirqs, sometimes happening at each ticks for a random
while.

These patches aims at fixing them.

Thanks.

Frederic Weisbecker (2):
  rcu: Don't chase unnecessary quiescent states after extended grace periods
  rcu: Stop checking quiescent states after grace period completion from remote

 kernel/rcutree.c |   22 ++++++++++++++++++++--
 1 files changed, 20 insertions(+), 2 deletions(-)

