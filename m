Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab2DPVtr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 17:49:47 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:37075 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab2DPVtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 17:49:45 -0400
Date: Mon, 16 Apr 2012 14:39:16 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@elte.hu
Cc: sergey.senozhatsky@gmail.com, linux-kernel@vger.kernel.org
Subject: [GIT PULL rcu/urgent] rcu: Permit call_rcu() from CPU_DYING notifiers
Message-ID: <20120416213916.GA6458@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041621-2398-0000-0000-000005DE2B5B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo,

The single commit in this pull request fixes a regression spotted
by Sergey Senozhatsky (https://lkml.org/lkml/2012/4/2/34).  The
underlying problem is that some CPU_DYING notifiers post RCU
callbacks from a CPU that has been marked offline.  The long-term
fix is to adopt those callbacks from RCU's CPU_DEAD notifier in
the 3.5 release.  For 3.4, this commit simply shuts off the warning.
(Yes, the warning will return in 3.5 also.)

This change is available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/urgent

							Thanx, Paul

-------------------->
Paul E. McKenney (1):
      rcu: Permit call_rcu() from CPU_DYING notifiers

 kernel/rcutree.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

