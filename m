Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423Ab1ADQvy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 11:51:54 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44589 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab1ADQvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 11:51:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=h406xo70mryC6Skj7SGDnIaECypWbwvS8IDeol0WP50x0dp+wUiSVy86g9rsV+5eaM
         4ikeHqtWWTyZ5VdgVu7JYKOrAGp6mfsVNIvHuiVdR/0fW9qIcSITkGykvFFBbyKwIBBe
         NI/hiUAvUejoRDjrYsDsIi36ho1jzqk6ehJ10=
MIME-Version: 1.0
In-Reply-To: <4D234E60.3010804@redhat.com>
References: <20110103162637.29f23c40@annuminas.surriel.com>
	<20110103162918.577a9620@annuminas.surriel.com>
	<AANLkTim1UFzHjBv52p7tyVyXerCVUVOBSAa3ajwQveuN@mail.gmail.com>
	<4D234E60.3010804@redhat.com>
Date: Wed, 5 Jan 2011 00:51:31 +0800
Message-ID: <AANLkTim8zmhKjPs-fVdR=65VPd6hybD8HA8pKEyKzm13@mail.gmail.com>
Subject: Re: [RFC -v3 PATCH 2/3] sched: add yield_to function
From: Hillf Danton <dhillf@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p04Gq6wJ012396

On Wed, Jan 5, 2011 at 12:44 AM, Rik van Riel <riel@redhat.com> wrote:
> On 01/04/2011 11:41 AM, Hillf Danton wrote:
>
>> /* Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  !curr->sched_class->yield_to_task || Â  Â  Â  Â */
>>
>>> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  curr->sched_class != p->sched_class) {
>>> + Â  Â  Â  Â  Â  Â  Â  goto out;
>>> + Â  Â  Â  }
>>> +
>>
>> Â  Â  Â  Â /*
>> Â  Â  Â  Â  Â * ask scheduler to compute the next for successfully kicking
>> @p onto its CPU
>> Â  Â  Â  Â  Â * what if p_rq is rt_class to do?
>> Â  Â  Â  Â  Â */
>> Â  Â  Â  Â next = pick_next_task(p_rq);
>> Â  Â  Â  Â if (next != p)
>> Â  Â  Â  Â  Â  Â  Â  Â p->se.vruntime = next->se.vruntime -1;
>> Â  Â  Â  Â deactivate_task(p_rq, p, 0);
>> Â  Â  Â  Â activate_task(p_rq, p, 0);
>> Â  Â  Â  Â if (rq == p_rq)
>> Â  Â  Â  Â  Â  Â  Â  Â schedule();
>> Â  Â  Â  Â else
>> Â  Â  Â  Â  Â  Â  Â  Â resched_task(p_rq->curr);
>> Â  Â  Â  Â yield = 0;
>
> Wouldn't that break for FIFO and RR tasks?
>
> There's a reason all the scheduler folks wanted a
> per-class yield_to_task function :)
>

Where is the yield_to callback in the patch for RT schedule class?
If @p is RT, what could you do?

Hillf
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
