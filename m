Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332Ab1DUF5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 01:57:10 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:32915 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab1DUF46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 01:56:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=a69YqAFsSu/WYxgKteHMaW0fQu+LsX8+c03Y7+RPMAUG6wbtK7FT1JdrWWyxOtsNUN
         zzPfKd1DCert1fSWPHJkCVezSps+lwAGjw+FCDkBS/+IFDLXhmjOvjW12BKnJmecCTfK
         tbsmh116MSUjojYkQT7TojmN6LVm+4K6V35i8=
Date: Thu, 21 Apr 2011 08:04:17 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>
Subject: Re: Linux 2.6.39-rc4 (regression: NUMA on multi-node CPUs broken)
Message-ID: <20110421060417.GA7046@loge>
References: <BANLkTin1=uPcyBgy9S_2TJASk8qTkeueEA@mail.gmail.com>
 <20110420153907.GA9000@alberich.amd.com>
 <20110421110452.7323.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110421110452.7323.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 11:04:27AM +0900, KOSAKI Motohiro wrote:
> > Following patch breaks real NUMA on multi-node CPUs like AMD
> > Magny-Cours and should be reverted (or changed to just take effect in
> > case of numa=fake):
> > 
> >   commit 7d6b46707f2491a94f4bd3b4329d2d7f809e9368
> >   Author: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> >   Date:   Fri Apr 15 20:39:01 2011 +0900
> > 
> >     x86, NUMA: Fix fakenuma boot failure
> > 
> >     ...
> > 
> >     Thus, this patch implements a reassignment of node-ids if buggy firmware
> >     or numa emulation makes wrong cpu node map. Tt enforce all logical cpus
> >     in the same physical cpu share the same node.
> > 
> >     ...
> > 
> >   +static void __cpuinit check_cpu_siblings_on_same_node(int cpu1, int cpu2)
> >   +{
> >   +       int node1 = early_cpu_to_node(cpu1);
> >   +       int node2 = early_cpu_to_node(cpu2);
> >   +
> >   +       /*
> >   +        * Our CPU scheduler assumes all logical cpus in the same physical cpu
> >   +        * share the same node. But, buggy ACPI or NUMA emulation might assign
> >   +        * them to different node. Fix it.
> >   +        */
> > 
> >    ...
> > 
> > This is a false assumption. Magny-Cours has two nodes in the same
> > physical package. The scheduler was (kind of) fixed to work around
> > this boot problem for multi-node CPUs (with 2.6.32). 
> 
> I agree we have to fix this ASAP. I also think we have to avoid reintroduce 
> the same again. Can you please tell me the commit-id of this one? 

It's

  commit 5a925b4282d7f805deafde62001a83dbaf8be275
  Author: Andreas Herrmann <andreas.herrmann3@amd.com>
  Date:   Thu Sep 3 09:44:28 2009 +0200

    x86, sched: Workaround broken sched domain creation for AMD Magny-Cours
 

 
> > If this is also
> > an issue with wrong cpu node maps in case of NUMA emulation this might
> > be fixed similar or this quirk should only be applied in case of NUMA
> > emulation.
> 
> Indeed.
> 
> Tejun, Do you remember I sent numa emulation specific patch at first. now
> I'm beside with Andreas. Because I bet current numa fallback code (you 
> pointed out one) has no user. 
> 
> Or, please let us know if you have an alternative patch.
> 
> Attached revert and fakenuma spefic fix patches.


Andreas
