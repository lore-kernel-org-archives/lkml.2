Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab2CZICW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 04:02:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:55986 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034Ab2CZICT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 04:02:19 -0400
Message-ID: <1332748920.16159.65.camel@twins>
Subject: Re: CPU Hotplug rework
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: paulmck@linux.vnet.ibm.com,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Milton Miller <miltonm@bga.com>, "mingo@elte.hu" <mingo@elte.hu>,
        Tejun Heo <tj@kernel.org>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Date: Mon, 26 Mar 2012 10:02:00 +0200
In-Reply-To: <87bonkchxk.fsf@rustcorp.com.au>
References: <4F674649.2000300@linux.vnet.ibm.com>
	 <87aa3cqht9.fsf@rustcorp.com.au> <1332240151.18960.401.camel@twins>
	 <874ntic1ze.fsf@rustcorp.com.au> <1332320519.18960.466.camel@twins>
	 <87d3859s9r.fsf@rustcorp.com.au> <20120322224919.GW2450@linux.vnet.ibm.com>
	 <877gya99uj.fsf@rustcorp.com.au> <20120324002347.GD2450@linux.vnet.ibm.com>
	 <87bonkchxk.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-26 at 11:11 +1030, Rusty Russell wrote:
> Obviously, having callbacks hanging around until the CPU comes back is
> not viable, nor is blocking preempt during the callbacks.  Calling
> get_online_cpus() is too heavy. 

-rt has patches (albeit somewhat ugly) to make get_online_cpus() a br
style rw-lock. That is, it makes the read side a per-cpu lock/counter so
that its much faster and only touches cpu-local state in the common
case.

It would be good to clean those up and make get_online_cpus() fast and
usable.
