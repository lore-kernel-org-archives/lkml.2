Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651Ab2IFOmc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 10:42:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:45731 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756521Ab2IFOmb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 10:42:31 -0400
Message-ID: <1346942438.18408.27.camel@twins>
Subject: Re: [PATCH tip/core/rcu 03/15] rcu: Properly initialize
 ->boost_tasks on CPU offline
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Date: Thu, 06 Sep 2012 16:40:38 +0200
In-Reply-To: <1346352988-32444-3-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120830185607.GA32148@linux.vnet.ibm.com>
	 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1346352988-32444-3-git-send-email-paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-30 at 11:56 -0700, Paul E. McKenney wrote:
> When rcu_preempt_offline_tasks() clears tasks from a leaf rcu_node
> structure, it does not NULL out the structure's ->boost_tasks field.
> This commit therefore fixes this issue. 

What would have been the side-effects of this? Would rcu-boosting have
been able to go funny on hotplug, and if so, how?

