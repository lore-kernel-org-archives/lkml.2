Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335Ab2EOJRJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 05:17:09 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38300 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932120Ab2EOJRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 05:17:07 -0400
Subject: Re: Plumbers: Tweaking scheduler policy micro-conf RFP
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <pantelis.antoniou@gmail.com>
In-Reply-To: <CAKfTPtBhPpQyr1qugbMzq2nENh+zBT+zx_nWQpQ9NPbF=+ppcQ@mail.gmail.com>
Date: Tue, 15 May 2012 12:17:02 +0300
Cc: mou Chen <hi3766691@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, torvalds@linux-foundation.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Transfer-Encoding: 7bit
Message-Id: <833A8DB8-1AB4-45E4-8D44-14A0D782807D@gmail.com>
References: <CAKfTPtDSDAOAdv0GTDswZeRM7TmACrjok+5kddSaQpvy6_6xWw@mail.gmail.com> <CAKfTPtCfiY7A29+e50F+6awd8BjNJjg4=uNN4ReZfdS_4FbpkA@mail.gmail.com> <CANQmPXj_81NBBrTYCkhUO1k1i4WVu0iHwY1_10wDVOFWCSkvsw@mail.gmail.com> <CAKfTPtBhPpQyr1qugbMzq2nENh+zBT+zx_nWQpQ9NPbF=+ppcQ@mail.gmail.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 15, 2012, at 12:07 PM, Vincent Guittot wrote:

> On 15 May 2012 10:34, mou Chen <hi3766691@gmail.com> wrote:
>> Hi Vincent
>> 
>> There is no necessary to change the scheduling policy for for a
>> SPECIFIC work. In case changing the scheduling policy just for this
>> reason will drop the total performance at all. People know that
>> desktop scheduler is for interactivity and server scheduler is for
>> throughput and we are just designing a scheduler for these 2 groups of
>> task.
> 
> Hi Chen,
> 
> First of all, I'm not sure that limiting the scheduling policy to
> server and desktop mode is the right solution because Linux is used in
> much more system like the embedded one.
> 
> Then, some weaknesses have been point out around the sched_mc and its
> power saving policy and IIRC Peter was close to remove the sched_mc
> stuff: http://thread.gmane.org/gmane.linux.kernel/1236846. It sounds
> like the sched_mc should be removed, replace or at least rework to
> have something smarter which takes into account more inputs than just
> cluster or hyper threading links between cores which seems to be no
> more sufficient.
> 
> So LPC would be a good place to discuss this point
> 
> Regards,
> Vincent
> 

Hi Vincent

IMO this whole idea about 'server' or 'desktop' schedulers is bunk.

There should only be a single scheduler, but it should be flexible
enough to cater to the needs of quite different classes of hardware,
and their specific workload requirements.

I feel that we're in the birthing pains period of where what used
to be a simple goal (perform as much work as possible in the minimum
amount of time) for the scheduler, turns into something more complex
(perform as much work as possible while staying within this power &
thermal envelope).

The LPC should be an excellent place to discuss how we can achieve this.

Regards

-- Pantelis

PS. Or have lots of beer crying over it...


>> 
>> All right you may not agree with me at all. However, changing the
>> policy for a SPECIFIC work is unnecessary. Or it is more better to
>> share about "how to make a scheduler for yourselves" with people who
>> don't know how to write a scheduler. :-)
>> 
>>                                                      Chen
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

