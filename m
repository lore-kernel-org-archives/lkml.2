Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab2A0Vef (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 16:34:35 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56049 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab2A0Ved convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 16:34:33 -0500
Message-ID: <1327700063.2446.178.camel@twins>
Subject: Re: perf: prctl(PR_TASK_PERF_EVENTS_DISABLE) has no effect
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Steets <asteets@rgmadvisors.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Date: Fri, 27 Jan 2012 22:34:23 +0100
In-Reply-To: <4F2303D8.80300@rgmadvisors.com>
References: <4F22D8D9.3010108@rgmadvisors.com>
	 <1327684363.2446.176.camel@twins> <4F2303D8.80300@rgmadvisors.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-27 at 14:06 -0600, Andrew Steets wrote:
> On 1/27/12 11:12 AM, Peter Zijlstra wrote:
> > On Fri, 2012-01-27 at 11:03 -0600, Andrew Steets wrote:
> >> Can anyone tell
> >> me if I'm using this wrong or if this is a bug?
> >
> > You're using it wrong, it will disable events you own (created) not
> > events that monitor you.
> 
> Is there an alternate way of disabling events that monitor the current
> process? 

Nope, nor will there ever be.

>  I ask because I came across the following description in
> tools/perf/design.txt:
> 
>      A process can enable or disable all the counter groups that are
>      attached to it, using prctl:
> 
>          prctl(PR_TASK_PERF_EVENTS_ENABLE);
> 
>          prctl(PR_TASK_PERF_EVENTS_DISABLE);
> 
>      This applies to all counters on the current process, whether created
>      by this process or by another, and doesn't affect any counters that
>      this process has created on other processes.  It only enables or
>      disables the group leaders, not any other members in the groups.


That's wrong.. also I wouldn't ever allow such a 'feature', that's just
asking for trouble.
