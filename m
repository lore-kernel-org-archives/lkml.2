Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab1BWSct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 13:32:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:38184 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab1BWScs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 13:32:48 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=x5lYFldHaXAA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=Ral0kNms-R4UkuZ7lYsA:9 a=vnsXt3h_kadkAk4h6oIA:7 a=zdkC7GzY0dj-Bi3xtoTbFYm6teYA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH RFC tip/core/rcu 11/11] rcu: move TREE_RCU from softirq
 to kthread
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Lameter <cl@linux.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, "Paul E. McKenney" <paul.mckenney@linaro.org>
In-Reply-To: <alpine.DEB.2.00.1102231225330.3906@router.home>
References: <20110223013917.GA20996@linux.vnet.ibm.com>
	 <1298425183-21265-11-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20110223161645.GA1819@nowhere>
	 <1298479302.7666.94.camel@gandalf.stny.rr.com>
	 <BLU0-SMTP65F733B8D1D704C7EA1F8796DB0@phx.gbl>
	 <alpine.DEB.2.00.1102231132140.562@router.home>
	 <1298485027.7666.98.camel@gandalf.stny.rr.com>
	 <alpine.DEB.2.00.1102231225330.3906@router.home>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 23 Feb 2011 13:32:45 -0500
Message-ID: <1298485965.7666.102.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-23 at 12:29 -0600, Christoph Lameter wrote:

> Right if the kthread context can be rescheduled then either preemption
> needs to be disabled to guarantee that all three access the same per cpu
> area data or the code needs to be changed in such a way that a this_cpu
> RMW instructions can do the mods in one go.

Are you suggesting a this_cpu_atomic_inc()?

-- Steve


