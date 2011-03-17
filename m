Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab1CQSbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 14:31:13 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:59893 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754961Ab1CQSbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 14:31:08 -0400
X-ASG-Debug-ID: 1300386667-03d6a54f628d820001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D825367.90408@fusionio.com>
Date: Thu, 17 Mar 2011 19:31:03 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com> <1295659049-2688-6-git-send-email-jaxboe@fusionio.com> <AANLkTin8FoXX6oqUyW+scwhadyX-TfW16_oKjvngU9-m@mail.gmail.com> <20110303221353.GA10366@redhat.com> <4D761E0D.8050200@fusionio.com> <20110308202100.GA31744@redhat.com> <4D76912C.9040705@fusionio.com> <20110308220526.GA393@redhat.com> <20110317155120.GA9220@redhat.com>
X-ASG-Orig-Subj: Re: [PATCH 05/10] block: remove per-queue plugging
In-Reply-To: <20110317155120.GA9220@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1300386667
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.58181
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-17 16:51, Mike Snitzer wrote:
> On Tue, Mar 08 2011 at  5:05pm -0500,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
>> On Tue, Mar 08 2011 at  3:27pm -0500,
>> Jens Axboe <jaxboe@fusionio.com> wrote:
>>
>>> On 2011-03-08 21:21, Mike Snitzer wrote:
>>>> On Tue, Mar 08 2011 at  7:16am -0500,
>>>> Jens Axboe <jaxboe@fusionio.com> wrote:
>>>>
>>>>> On 2011-03-03 23:13, Mike Snitzer wrote:
>>>>>> I'm now hitting a lockdep issue, while running a 'for-2.6.39/stack-plug'
>>>>>> kernel, when I try an fsync heavy workload to a request-based mpath
>>>>>> device (the kernel ultimately goes down in flames, I've yet to look at
>>>>>> the crashdump I took)
>>>>>
>>>>> Mike, can you re-run with the current stack-plug branch? I've fixed the
>>>>> !CONFIG_BLOCK and rebase issues, and also added a change for this flush
>>>>> on schedule event. It's run outside of the runqueue lock now, so
>>>>> hopefully that should solve this one.
>>>>
>>>> Works for me, thanks.
>>>
>>> Super, thanks! Out of curiousity, did you use dm/md?
>>
>> Yes, I've been using a request-based DM multipath device.
> 
> 
> Against latest 'for-2.6.39/core', I just ran that same fsync heavy
> workload against XFS (ontop of a DM multipath volume).  ffsb induced the
> following hangs (ripple effect causing NetworkManager to get hung up on
> this data-only XFS volume, etc):

Ugh. Care to send the recipee for how to reproduce this? Essentially
just looks like IO got stuck.

-- 
Jens Axboe

