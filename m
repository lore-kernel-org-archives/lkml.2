Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312Ab0E1OGe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 10:06:34 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45441 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683Ab0E1OGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 10:06:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZVLzHDZV0U0mzFEy4+H3DbKKDkcTkHdNgJGGax8vAhHm+wgHX5gkCXD7uG/Ieg2d/+
         ty2pzDAYsxfA4Swn+f1jNkPBZuE9V2N2cl3/dbNzZ8aai9ueSiCvltEbVr11HBU8jpNP
         RJUYrcJwnHZNa8KDgbgMxiw8ltAyOsFVh7BkY=
Date: Fri, 28 May 2010 23:06:23 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       balbir@linux.vnet.ibm.com, Oleg Nesterov <oleg@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
       williams@redhat.com
Subject: Re: [RFC] oom-kill: give the dying task a higher priority
Message-ID: <20100528140623.GA11041@barrios-desktop>
References: <20100528143605.7E2A.A69D9226@jp.fujitsu.com>
 <AANLkTikB-8Qu03VrA5Z0LMXM_alSV7SLqzl-MmiLmFGv@mail.gmail.com>
 <20100528145329.7E2D.A69D9226@jp.fujitsu.com>
 <20100528125305.GE11364@uudg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100528125305.GE11364@uudg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 09:53:05AM -0300, Luis Claudio R. Goncalves wrote:
> On Fri, May 28, 2010 at 02:59:02PM +0900, KOSAKI Motohiro wrote:
> | > RT Task
> | > 
> | > void non-RT-function()
> | > {
> | >    system call();
> | >    buffer = malloc();
> | >    memset(buffer);
> | > }
> | > /*
> | >  * We make sure this function must be executed in some millisecond
> | >  */
> | > void RT-function()
> | > {
> | >    some calculation(); <- This doesn't have no dynamic characteristic
> | > }
> | > int main()
> | > {
> | >    non-RT-function();
> | >    /* This function make sure RT-function cannot preempt by others */
> | >    set_RT_max_high_priority();
> | >    RT-function A();
> | >    set_normal_priority();
> | >    non-RT-function();
> | > }
> | > 
> | > We don't want realtime in whole function of the task. What we want is
> | > just RT-function A.
> | > Of course, current Linux cannot make perfectly sure RT-functionA can
> | > not preempt by others.
> | > That's because some interrupt or exception happen. But RT-function A
> | > doesn't related to any dynamic characteristic. What can justify to
> | > preempt RT-function A by other processes?
> | 
> | As far as my observation, RT-function always have some syscall. because pure
> | calculation doesn't need deterministic guarantee. But _if_ you are really
> | using such priority design. I'm ok maximum NonRT priority instead maximum
> | RT priority too.
> 
> I confess I failed to distinguish memcg OOM and system OOM and used "in
> case of OOM kill the selected task the faster you can" as the guideline.
> If the exit code path is short that shouldn't be a problem.
> 
> Maybe the right way to go would be giving the dying task the biggest
> priority inside that memcg to be sure that it will be the next process from
> that memcg to be scheduled. Would that be reasonable?

Hmm. I can't understand your point. 
What do you mean failing distinguish memcg and system OOM?

We already have been distinguish it by mem_cgroup_out_of_memory.
(but we have to enable CONFIG_CGROUP_MEM_RES_CTLR). 
So task selected in select_bad_process is one out of memcg's tasks when 
memcg have a memory pressure. 

Isn't it enough?
-- 
Kind regards,
Minchan Kim
