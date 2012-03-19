Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528Ab2CSDrX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 23:47:23 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:52183 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753150Ab2CSDrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 23:47:22 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19IsFhux9ZIUGuawmaSycK3tefn9jrW1XCfGjeK1F
	emd5OAeaATXaPc
Message-ID: <1332128832.7283.34.camel@marge.simpson.net>
Subject: Re: [PATCH RFC] rcu: Permit limiting of force_quiescent_state()
 latency
From: Mike Galbraith <efault@gmx.de>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, sivanich@sgi.com
Date: Mon, 19 Mar 2012 04:47:12 +0100
In-Reply-To: <20120319001014.GD2393@linux.vnet.ibm.com>
References: <20120316160328.GA7207@linux.vnet.ibm.com>
	 <1332003451.8147.77.camel@marge.simpson.net>
	 <1332082821.7291.27.camel@marge.simpson.net>
	 <20120319001014.GD2393@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-03-18 at 17:10 -0700, Paul E. McKenney wrote:

> Thank you very much for your efforts on this!!!

No problem, irq holdoff troubles are worth effort.

> Given that you were seeing about 200-microsecond latency spikes on
> grace-period initialization, I would expect that you would need about
> 200 dyntick-idle CPUs for force_quiescent_state() to give you a
> ten-microsecond spike, so I am not surprised that you could not see
> the difference on 60 CPUs, which probably have given you something
> like 3 microseconds..

Crawling over fewer locks should still save cycles, so I'll measure.
Big box rt needs every little usec we can scrape together.

-Mike

