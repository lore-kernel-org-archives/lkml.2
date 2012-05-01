Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262Ab2EAPlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 11:41:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757131Ab2EAPlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 11:41:17 -0400
Message-ID: <4FA003C8.7060004@redhat.com>
Date: Tue, 01 May 2012 18:39:52 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>, mingo@elte.hu,
        jeremy@goop.org, mtosatti@redhat.com, kvm@vger.kernel.org,
        x86@kernel.org, vatsa@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com
Subject: Re: [RFC PATCH v1 3/5] KVM: Add paravirt kvm_flush_tlb_others
References: <20120427161727.27082.43096.stgit@abhimanyu>     <20120427162401.27082.59387.stgit@abhimanyu>   <4F9D32B4.8040002@redhat.com>  <1335865176.13683.120.camel@twins>   <4F9FBF38.2060903@redhat.com> <1335869827.13683.133.camel@twins>   <4F9FD337.5010908@redhat.com> <1335884353.13683.144.camel@twins>  <4FA001D8.6080801@redhat.com> <1335886587.13683.153.camel@twins>
In-Reply-To: <1335886587.13683.153.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2012 06:36 PM, Peter Zijlstra wrote:
> On Tue, 2012-05-01 at 18:31 +0300, Avi Kivity wrote:
> > On 05/01/2012 05:59 PM, Peter Zijlstra wrote:
> > > On Tue, 2012-05-01 at 15:12 +0300, Avi Kivity wrote:
> > > > local_irq_save() is a stronger version or rcu_read_lock()
> > >
> > > Not so, local_irq_save() doesn't at all stop regular RCU grace periods,
> > > things like preemptible rcu can be driven from rcu_read_unlock().
> > >
> > > Note that this is the reason call_rcu_sched() exists and is used in this
> > > case.
> > 
> > Ah, thanks for the correction.  I'll read some more about the _sched
> > variants.
>
> Basically:
>
>  rcu_read_{,un}lock_sched() -- aka preempt_{en,dis}able()
>  call_rcu_sched()
>  synchronize_rcu_sched() -- aka synchronize_sched();
>
> Define an RCU variant where each cpu has to have scheduled at least once
> to complete a grace period.

Which was the original rcu implementation, until it got replaced by
preemptible rcu, yes?  I guess that was the source of my confusion.

-- 
error compiling committee.c: too many arguments to function

