Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243Ab2EAQIN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 12:08:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757362Ab2EAQIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 12:08:11 -0400
Message-ID: <4FA002F4.8000508@redhat.com>
Date: Tue, 01 May 2012 18:36:20 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>, mingo@elte.hu,
        jeremy@goop.org, mtosatti@redhat.com, kvm@vger.kernel.org,
        x86@kernel.org, vatsa@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com
Subject: Re: [RFC PATCH v1 3/5] KVM: Add paravirt kvm_flush_tlb_others
References: <20120427161727.27082.43096.stgit@abhimanyu>    <20120427162401.27082.59387.stgit@abhimanyu>  <4F9D32B4.8040002@redhat.com>  <1335865176.13683.120.camel@twins>  <4F9FBF38.2060903@redhat.com> <1335869827.13683.133.camel@twins>  <4F9FD337.5010908@redhat.com> <1335885292.13683.150.camel@twins>
In-Reply-To: <1335885292.13683.150.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2012 06:14 PM, Peter Zijlstra wrote:
> On Tue, 2012-05-01 at 15:12 +0300, Avi Kivity wrote:
> > 
> > What's changed is not gup_fast() but the performance of munmap(),
> > exit(), and exec(), no?
>
> If it is indeed cache related like you suggested earlier, it would be
> the allocation side of things, like fork()/mmap() that suffer since
> there's fewer hot pages about, but yes, anything creating/destroying
> page-tables.

Right.

>
> > What bounds the amount of memory waiting to be freed during an rcu grace
> > period?
>
> Most RCU implementations don't have limits, so that could be quite a
> lot. I think preemptible RCU has a batch limit at which point it tries
> rather hard to force a grace period, but I'm not sure if even that
> provides a hard limit.
>
> Practically though, I haven't had reports of PPC/Sparc going funny
> because of this.

It could be considered a DoS if a user is able to free page tables
faster than rcu is able to recycle them, possibly triggering the oom
killer (should that force a grace period before firing from the hip?)

-- 
error compiling committee.c: too many arguments to function

