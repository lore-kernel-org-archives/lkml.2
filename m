Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758373Ab1CCP3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 10:29:31 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:32839 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab1CCP3a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 10:29:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=c2hrDAByTTVO3BHfrEpQOwrdUVyFBFN4GqouaMXCjj5JQ20QDwCN1NfklxUVM6Hftq
         Jjmcpy3bBW1RKE3DchJX0XUHQNVIpXEHExKy3o2hdco9mB792KaP+QtlSBG7lfPanr9v
         /iBc9TFxUQTh+sY4vFfCSBYpdYTxM3OATOIyA=
MIME-Version: 1.0
In-Reply-To: <20110303140551.GA20677@zhy>
References: <20110303113435.GA2868@balbir.in.ibm.com>
	<20110303140551.GA20677@zhy>
Date: Thu, 3 Mar 2011 20:59:29 +0530
X-Google-Sender-Auth: 183cH9ZnsCBV6VSMFzRVLAdHe5M
Message-ID: <AANLkTikHFLoJOZvx2YebKdHt+jjiHgUFasiLTrZ6vBUJ@mail.gmail.com>
Subject: Re: [BUGFIX][PATCH] Fix sched rt group scheduling when hierachy is enabled
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <pzijlstr@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Bharata B Rao <bharata.rao@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 3, 2011 at 7:35 PM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> On Thu, Mar 03, 2011 at 05:04:35PM +0530, Balbir Singh wrote:
>> Fix hierarchical scheduling in sched rt group
>>
>> From: Balbir Singh <balbir@linux.vnet.ibm.com>
>>
>> The current sched rt code is broken when it comes to hierarchical
>> scheduling, this patch fixes two problems
>>
>> 1. It adds redundant enqueuing (harmless) when it finds a queue
>>    has tasks enqueued, but it has no run time and it is not
>>    throttled.
>
> You say redundant here, so in fact we don't need it, right?
>

No, not really :) It is required, it is a backup check to see if we
have queued tasks, rt_time of 0 and the runqueue is not throttled, why
should it be dequeued?

>> 2. The most important change is in sched_rt_rq_enqueue/dequeue.
>>    The code just picks the rt_rq belonging to the current cpu
>>    on which the period timer runs, the patch fixes it, so that
>>    the correct rt_se is enqueued/dequeued.
>
> Ah, this is true. It is also needed for stable-2.6.33+
>

Yep, we'll need backports to stable versions

Balbir
