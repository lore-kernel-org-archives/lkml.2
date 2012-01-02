Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843Ab2ABJjP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 04:39:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119Ab2ABJjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 04:39:13 -0500
Message-ID: <4F017B34.109@redhat.com>
Date: Mon, 02 Jan 2012 11:39:00 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>, peterz@infradead.org,
        linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com,
        bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com> <20111219112326.GA15090@elte.hu> <87sjke1a53.fsf@abhimanyu.in.ibm.com> <4EF1B85F.7060105@redhat.com> <877h1o9dp7.fsf@linux.vnet.ibm.com> <20111223103620.GD4749@elte.hu> <4EF701C7.9080907@redhat.com> <20111230095147.GA10543@elte.hu> <878vlu4bgh.fsf@linux.vnet.ibm.com> <87pqf5mqg4.fsf@abhimanyu.in.ibm.com> <87ty4erb01.fsf@abhimanyu.in.ibm.com>
In-Reply-To: <87ty4erb01.fsf@abhimanyu.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2012 06:20 AM, Nikunj A Dadhania wrote:
> On Sat, 31 Dec 2011 07:51:15 +0530, Nikunj A Dadhania <nikunj@linux.vnet.ibm.com> wrote:
> > On Fri, 30 Dec 2011 15:40:06 +0530, Nikunj A Dadhania <nikunj@linux.vnet.ibm.com> wrote:
> > > On Fri, 30 Dec 2011 10:51:47 +0100, Ingo Molnar <mingo@elte.hu> wrote:
> > > > 
> > > > * Avi Kivity <avi@redhat.com> wrote:
> > > > 
> > > > > [...]
> > > > > 
> > > > > The first part appears to be unrelated to ebizzy itself - it's 
> > > > > the kunmap_atomic() flushing ptes.  It could be eliminated by 
> > > > > switching to a non-highmem kernel, or by allocating more PTEs 
> > > > > for kmap_atomic() and batching the flush.
> > > > 
> > > > Nikunj, please only run pure 64-bit/64-bit combinations - by the 
> > > > time any fix goes upstream and trickles down to distros 32-bit 
> > > > guests will be even less relevant than they are today.
> > > > 
> > > Sure Ingo, got a 64bit guest working yesterday and I am in process of
> > > getting the benchmark numbers for the same.
> > > 
> > Here is the results collected from the 64bit VM runs. 
> > 
> [...]
>
> PLE worst case:
>
> >      
> >     dbench 8vm (degraded -8%)
> >     |      dbench|               2.27 |               2.09 |       -8 |
> [...]
> >     dbench needs some more love, i will get the perf top caller for
> >     that.
> >
>
>     Baseline:
>     75.18%         init  [kernel.kallsyms]  [k] native_safe_halt
>     23.32%      swapper  [kernel.kallsyms]  [k] native_safe_halt
>
>     Gang V2:
>     73.21%         init  [kernel.kallsyms]       [k] native_safe_halt
>     25.74%      swapper  [kernel.kallsyms]       [k] native_safe_halt
>
> That does not give much clue :(
> Comments?
>
> >     non-PLE - Test Setup:
> > 
> >     dbench 8vm (degraded -30%)
> >     |      dbench|               2.01 |               1.38 |      -30 |
>
>
>     Baseline:
>     57.75%         init  [kernel.kallsyms]  [k] native_safe_halt
>     40.88%      swapper  [kernel.kallsyms]  [k] native_safe_halt
>
>     Gang V2:
>     56.25%         init  [kernel.kallsyms]  [k] native_safe_halt
>     42.84%      swapper  [kernel.kallsyms]  [k] native_safe_halt
>
> Similar comparison here.
>

Wierd, looks like a mismeasurement... what happens if you add a bash
busy loop?

-- 
error compiling committee.c: too many arguments to function

