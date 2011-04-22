Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab1DVIKw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 04:10:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60039 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab1DVIKt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 04:10:49 -0400
Subject: Re: [RFC PATCH 4/5] RCU: Add TASK_RCU_OFFSET
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: paulmck@linux.vnet.ibm.com, "H. Peter Anvin" <hpa@linux.intel.com>,
        Michal Marek <mmarek@suse.cz>, Jan Beulich <JBeulich@novell.com>,
        Ingo Molnar <mingo@elte.hu>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, David Howells <dhowells@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <4DB12C1E.8050200@cn.fujitsu.com>
References: <4D9CDACB.9050705@linux.intel.com>
	 <20110407003041.GD2265@linux.vnet.ibm.com>
	 <4D9D507F.2040006@cn.fujitsu.com>
	 <20110407154737.GF2262@linux.vnet.ibm.com>
	 <20110407162600.GA24227@linux.vnet.ibm.com>
	 <4D9E6438.5030206@cn.fujitsu.com>
	 <20110408051359.GA2318@linux.vnet.ibm.com> <4DA2709E.50902@cn.fujitsu.com>
	 <20110411051241.GB18415@linux.vnet.ibm.com>
	 <4DA2BC4E.4010000@cn.fujitsu.com>
	 <20110411210223.GB2226@linux.vnet.ibm.com>
	 <4DB12C1E.8050200@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 22 Apr 2011 10:10:20 +0200
Message-ID: <1303459820.2298.4.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-22 at 15:19 +0800, Lai Jiangshan wrote:
> 
> What is the solution you prefer to?
> 
> I insist on the solution which split rcupdate.h into 2 parts,
> the first part is rcupdate_defs.h which only contains:
> 1) struct rcu_head
> 2) MACRO rcu_dereference*
> 3) MACRO rcu_access_pointer rcu_access_index rcu_assign_pointer RCU_INIT_POINTER
> 4) rcu_*_lock_held() which is required by 2)
> 
> All of these is required by sched.h, it is all about 450 lines of code.
> 
> It does not just separate struct rcu_head out only, because rcu_dereference*()
> and APIs in rculist.h are required by in sched.h or headers included by sched.h.

The only usage of rculist.h in the whole of sched.h is that _one_
list_entry_rcu, of which we already have a macro user, so why not make
that one a macro too and safe ourselves a ton of grief?

You're just making stuff harder than it needs to be.
