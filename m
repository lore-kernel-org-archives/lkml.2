Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656Ab2IFOQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 10:16:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:44988 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab2IFOQQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 10:16:16 -0400
Message-ID: <1346940930.18408.14.camel@twins>
Subject: Re: [PATCH tip/core/rcu 13/23] rcu: Control grace-period duration
 from sysfs
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Date: Thu, 06 Sep 2012 16:15:30 +0200
In-Reply-To: <1346350718-30937-13-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120830181811.GA29154@linux.vnet.ibm.com>
	 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1346350718-30937-13-git-send-email-paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-30 at 11:18 -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> 
> Some uses of RCU benefit from shorter grace periods, while others benefit
> more from the greater efficiency provided by longer grace periods.
> Therefore, this commit allows the durations to be controlled from sysfs.
> There are two sysfs parameters, one named "jiffies_till_first_fqs" that
> specifies the delay in jiffies from the end of grace-period initialization
> until the first attempt to force quiescent states, and the other named
> "jiffies_till_next_fqs" that specifies the delay (again in jiffies)
> between subsequent attempts to force quiescent states.  They both default
> to three jiffies, which is compatible with the old hard-coded behavior.

A number of questions:

 - how do I know if my workload wants a longer or shorter forced qs
   period?
 - the above implies a measure of good/bad-ness associated with fqs,
   can one formulate this?
 - if we can, should we not do this 'automagically' and avoid burdening
   our already hard pressed sysads of the world with trying to figure
   this out?

Also, whatever made you want to provide this 'feature' in the first
place?
   
