Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab2B2Tt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 14:49:57 -0500
Received: from mga12.intel.com ([143.182.124.36]:5596 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753960Ab2B2Ttl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 14:49:41 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dan.j.williams@intel.com designates 10.182.188.36 as permitted sender) smtp.mail=dan.j.williams@intel.com
MIME-Version: 1.0
In-Reply-To: <1330507023.11248.113.camel@twins>
References: <20120227203847.22153.62468.stgit@dwillia2-linux.jf.intel.com>
	<1330422535.11248.78.camel@twins>
	<alpine.LFD.2.02.1202282240340.2794@ionos>
	<CABE8wwsmWqDddMqgQ6HvMPkbK+Vu7G7GOY-VO_Tru2JV2NUUcw@mail.gmail.com>
	<1330507023.11248.113.camel@twins>
Date: Wed, 29 Feb 2012 11:49:39 -0800
Message-ID: <CABE8wwvhZTB8AONcdCyoE+i3rNKUHFwDSiwVWcLOU=zeKz_Nbg@mail.gmail.com>
Subject: Re: [RFC PATCH] kick ksoftirqd more often to please soft lockup detector
From: Dan Williams <dan.j.williams@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
        Lukasz Dorau <lukasz.dorau@intel.com>,
        James Bottomley <JBottomley@parallels.com>,
        Andrzej Jakowski <andrzej.jakowski@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 1:17 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2012-02-28 at 14:16 -0800, Dan Williams wrote:
>> Looks like everyone is guilty:
>>
>> [  422.765336] softirq took longer than 1/4 tick: 3 NET_RX ffffffff813f0aa0
>> ...
>> [  423.971878] softirq took longer than 1/4 tick: 4 BLOCK ffffffff812519c8
>> [  423.985093] softirq took longer than 1/4 tick: 6 TASKLET ffffffff8103422e
>> [  423.993157] softirq took longer than 1/4 tick: 7 SCHED ffffffff8105e2e1
>> [  424.001018] softirq took longer than 1/4 tick: 9 RCU ffffffff810a0fed
>> [  424.008691] softirq loop took longer than 1/2 tick need_resched:
>
> /me kicks himself for not printing the actual duration.. :-)
>
>> As expected whenever that 1/2 tick message gets emitted the softirq
>> handler is almost running in a need_resched() context.
>
> Yeah.. that's quite expected.
>
>> So is it a good idea to get more aggressive about scheduling ksoftrrqd?
>
> Nah, moving away from softirq more like. I'll put moving the
> load-balancer into a kthread on the todo list. And it looks like
> everybody else should move to kthreads too.

I seem to recall this running into resistance (but maybe things have
changed in the last few years)?

https://lkml.org/lkml/2007/6/29/155
