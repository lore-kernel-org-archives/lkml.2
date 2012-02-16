Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751134Ab2BPLOX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 06:14:23 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:15991 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750727Ab2BPLOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 06:14:22 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAOXjPE/O+Ip3/2dsb2JhbABEsGWBCIFyAQEFJxMbASMQCxguFCUkE8Eqi1Q3DgECAgsJBQECCR0DAwKDawMEA0AMgk1jBIhNjGiOLYRa
X-IronPort-AV: E=Sophos;i="4.73,428,1325480400"; 
   d="scan'208";a="163283966"
Date: Thu, 16 Feb 2012 06:14:21 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org,
        Avi Kiviti <avi@redhat.com>, Chris Mason <chris.mason@oracle.com>,
        Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH RFC tip/core/rcu] rcu: direct algorithmic SRCU
	implementation
Message-ID: <20120216111421.GA13497@Krystal>
References: <20120213020951.GA12138@linux.vnet.ibm.com> <1329310763.2293.78.camel@twins> <20120216063504.GE2976@linux.vnet.ibm.com> <20120216105005.GA11674@Krystal> <1329389542.2293.196.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1329389542.2293.196.camel@twins>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 06:12:34 up 7 days, 22:10,  1 user,  load average: 0.01, 0.03,
	0.02
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Thu, 2012-02-16 at 05:50 -0500, Mathieu Desnoyers wrote:
> > > Ah, so something like this?
> > > 
> > >       ACCESS_ONCE(this_cpu_ptr(sp->per_cpu_ref)->c[idx]) += 
> > >               SRCU_USAGE_COUNT + 1;
> > > 
> > > Now that you mention it, this does look nicer, applied here and to
> > > srcu_read_unlock().
> > 
> > I think Peter refers to __this_cpu_add(). 
> 
> I'm not sure that implies the ACCESS_ONCE() thing
> 

Fair point. The "generic" fallback for this_cpu_add does not imply the
ACCESS_ONCE() semantic AFAIK. I don't know if there would be a clean way
to get both without duplicating these operations needlessly.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
