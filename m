Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760110Ab2ILPSs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 11:18:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4916 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759751Ab2ILPSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 11:18:43 -0400
X-Authority-Analysis: v=2.0 cv=C49rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=jUoZk2RAzk0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=xkD7W5DCUvkA:10 a=VwQbUJbxAAAA:8 a=f8us78lFAAAA:8 a=is1WEdOEVPPngleRh-wA:9 a=PUjeQqilurYA:10 a=HEdnscJc8mAA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1347463120.10751.63.camel@gandalf.local.home>
Subject: Re: [PATCH tip/core/rcu 04/15] rcu: Permit RCU_NONIDLE() to be used
 from interrupt context
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 12 Sep 2012 11:18:40 -0400
In-Reply-To: <20120912150328.GN4257@linux.vnet.ibm.com>
References: <20120904233344.GB11855@jtriplet-mobl1>
	 <20120904234307.GY2593@linux.vnet.ibm.com>
	 <20120906185402.GB5738@jtriplet-mobl1>
	 <1346961244.1680.46.camel@gandalf.local.home> <20120907060940.GA21166@leaf>
	 <20120907142441.GD2462@linux.vnet.ibm.com> <20120907144717.GA22059@leaf>
	 <1347030967.8178.15.camel@gandalf.local.home>
	 <20120912010720.GM4257@linux.vnet.ibm.com>
	 <1347459210.10751.48.camel@gandalf.local.home>
	 <20120912150328.GN4257@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Added Linus to verify what I'm talking about ]

On Wed, 2012-09-12 at 08:03 -0700, Paul E. McKenney wrote:

> Doesn't Fengguang pull branches individually?  And won't that mean
> that as soon as I push my export-removal commit, that he will see
> build failures?
> 
> Or are you suggesting that we both send both commits?

No, what I could do is to push the branch out to my repository on
kernel.org (I'm currently running it under my test suite), and then both
you and Ingo can pull from it.

It is based off of v3.6-rc5 and only has Josh's change in it. This way,
when Ingo pulls it into the perf/core branch, I can work against that,
and you could either pull the same branch directly from me (as you need
it to work too), or you could have Ingo pull it into the rcu branches in
tip, and you could work against that.

The trick is that the branch I push is against Linus's tree (something
that we all should be working against) and contains only the one change.
Then everyone that needs this change can just pull it directly, and git
will sort it all out without any conflicts. This is the method that
Linus was talking about at Kernel Summit.

-- Steve


