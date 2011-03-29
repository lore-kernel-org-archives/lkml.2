Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab1C2Vbv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 17:31:51 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:37514 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab1C2Vbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 17:31:50 -0400
Date: Tue, 29 Mar 2011 14:31:30 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Jan Beulich <JBeulich@novell.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, David Howells <dhowells@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        Serge Hallyn <serue@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 4/5] RCU: Add TASK_RCU_OFFSET
Message-ID: <20110329213130.GK2261@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4D8FF8AD.5080607@cn.fujitsu.com>
 <4D8FF9BC.7050609@cn.fujitsu.com>
 <4D90647902000078000389CB@vpn.id2.novell.com>
 <4D924BAF.1020906@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D924BAF.1020906@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 02:14:23PM -0700, H. Peter Anvin wrote:
> On 03/28/2011 01:35 AM, Jan Beulich wrote:
> >>>> On 28.03.11 at 05:00, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> >>
> >> We can not include linux/sched.h in linux/rcupdate.h.
> >> If we access task's task_rcu_strut without linux/sched.h included,
> >> We will failed with compiling error.
> >>
> >> So we add TASK_RCU_OFFSET, which help us access
> >> task's task_rcu_strut without linux/sched.h included.
> >> Now, task_rcu_struct(), current_task_rcu_struct(), task_of_task_rcu() and
> >> rcu_copy_process() can be used anywhere without linux/sched.h included.
> > 
> > Aren't the offsets-generation methods meant for assembly
> > consumption only? Header dependency problems normally can
> > be solved by splitting headers into a type declaration one and
> > a second one carrying inline function implementations. Is that
> > indeed completely impossible here?
> 
> I have to say that if we have to use hardcoded offsets in C then we have
> bigger problems.

In this case, the offsets are mechanically generated from the structure
definitions.

Or am I missing your point?

							Thanx, Paul
