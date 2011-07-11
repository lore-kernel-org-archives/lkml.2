Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133Ab1GKQoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 12:44:18 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:40709 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758120Ab1GKQoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 12:44:16 -0400
Date: Mon, 11 Jul 2011 09:35:30 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@elte.hu
Cc: torvalds@linux-foundation.org, kernelmail.jms@gmail.com,
        kulkarni.ravi4@gmail.com, linux-kernel@vger.kernel.org
Subject: [GIT PULL rcu/urgent] Prevent RCU callbacks from executing during
 early boot
Message-ID: <20110711163530.GA6329@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo,

This pull request fixes a rare but real boot-time hang.  It defers RCU
callback execution until the scheduler has initialized, permitting
RCU callbacks that use late-initialized kernel features to be used in
RCU callbacks that are registered during early boot.  This fixes the
bugzilla at: https://bugzilla.kernel.org/show_bug.cgi?id=38732

This commit is available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/urgent

							Thanx, Paul

------------------->

Paul E. McKenney (1):
      rcu: Prevent RCU callbacks from executing during early boot

 kernel/rcutree.c        |    2 +-
 kernel/rcutree_plugin.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
