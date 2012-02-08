Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968Ab2BHBkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 20:40:07 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37934 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756394Ab2BHBkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 20:40:04 -0500
Date: Wed, 8 Feb 2012 05:39:59 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Dave Jones <davej@redhat.com>, Russell King <linux@arm.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Nicolas Pitre <nico@fluxnic.net>, Mike Chan <mike@android.com>,
        Todd Poynor <toddpoynor@google.com>, cpufreq@vger.kernel.org,
        kernel-team@android.com, linaro-kernel@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH RFC 0/4] Scheduler idle notifiers and users
Message-ID: <20120208013959.GA24535@panacea>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

For some drivers we need to know when scheduler is idling. The most
straightforward way is to gracefully hook into the idle loop.

On x86 there are "CPU idle" notifiers in the inner idle loop, but
scheduler idle notifiers are different. These notifiers do not run on
every invocation/exit from cpuidle, instead they used to notify about
scheduler state changes, not HW states.

In other words, CPU idle notifiers work inside while(!need_resched())
loop (nested into idle loop), while scheduler idle notifier work
outside of the loop.

The first two patches consolidate scheduler idle entry/exit
points, and converts architectures to this new API.

The third patch is a new cpufreq governor, the commit message
briefly describes it.

The fourth patch is another user of the notifiers, a trivial one.

Thanks,

p.s. For the reference, the old discussion about CPU/PM idle
     notifiers: http://lkml.org/lkml/2011/6/27/391 

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
