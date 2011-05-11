Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757723Ab1EKQsh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:48:37 -0400
Received: from smtp-out.google.com ([216.239.44.51]:56374 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756649Ab1EKQsf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:48:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=nrvrRXhexHKPj0MocKfXHmrXTemrTagdHgUFLRRygkt99T2eAXmqgClwKpyN3PEfLF
         VKaZHS0RoIva5FWvo3MQ==
MIME-Version: 1.0
In-Reply-To: <4DCA40E8.3090805@jp.fujitsu.com>
References: <20110503092846.022272244@google.com> <20110503092904.541414484@google.com>
 <4DC8E5C2.9090701@jp.fujitsu.com> <1305016326.14565.2.camel@marge.simson.net> <4DCA40E8.3090805@jp.fujitsu.com>
From: Paul Turner <pjt@google.com>
Date: Wed, 11 May 2011 01:13:18 -0700
Message-ID: <BANLkTimr31i9hA375__Kw+i0GBFq5fPfvw@mail.gmail.com>
Subject: Re: [patch 01/15] sched: (fixlet) dont update shares twice on on_rq parent
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 12:55 AM, Hidetoshi Seto
<seto.hidetoshi@jp.fujitsu.com> wrote:
> (2011/05/10 17:32), Mike Galbraith wrote:
>> On Tue, 2011-05-10 at 16:14 +0900, Hidetoshi Seto wrote:
>>> This small fixlet can stand alone.
>>> Peter, how about getting this into git tree first?
>>
>> tip 2f36825b176f67e5c5228aa33d828bc39718811f contains the below.
>>
>>                 /* Don't dequeue parent if it has other entities besides us */
>> -               if (cfs_rq->load.weight)
>> +               if (cfs_rq->load.weight) {
>> +                       /*
>> +                        * Bias pick_next to pick a task from this cfs_rq, as
>> +                        * p is sleeping when it is within its sched_slice.
>> +                        */
>> +                       if (task_sleep && parent_entity(se))
>> +                               set_next_buddy(parent_entity(se));
>>                         break;
>> +               }
>>                 flags |= DEQUEUE_SLEEP;
>>         }
>
> Oh, thanks Mike!
> It seems that this change in tip is better one.
>
> Paul, don't you mind rebasing your patches onto tip/sched/core next time?
> (...or is there better branch for rebase?)
>

I thought I had but apparently I missed this.

We still need to set se = parent_entity(se) to avoid the pointless
double update below.

Will definitely rebase.

Thanks!

>
> Thanks,
> H.Seto
>
>
