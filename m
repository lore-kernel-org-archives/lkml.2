Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab1BVPid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 10:38:33 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35695 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049Ab1BVPib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 10:38:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=AyXQsz39i2qLHAnlwzjQ8DNKQwwDCtSQB6xZ4Wu/IpLKCgGML6ehwXexE5E6uOSyZG
         14tbVTRg7ncgnmH10EWBwPv0LF/j7Gp2QfQ9bBbbPLR+gMlIBnnBpBlCJDAoY9bj+haf
         9kC8q7oYxcofaIf3WmqM9asAIvgOuQNUU1XTw=
MIME-Version: 1.0
In-Reply-To: <20110221172756.GA27664@redhat.com>
References: <1298299131-17695-1-git-send-email-dacohen@gmail.com>
	<1298299131-17695-2-git-send-email-dacohen@gmail.com>
	<1298303677.24121.1.camel@twins>
	<AANLkTimOT6jNG3=TiRMJR0dgEQ6EHjcBPJ1ivCu3Wj5Q@mail.gmail.com>
	<1298305245.24121.7.camel@twins>
	<20110221172103.GA26225@redhat.com>
	<20110221172756.GA27664@redhat.com>
Date: Tue, 22 Feb 2011 17:38:29 +0200
Message-ID: <AANLkTi=f+XMp0r77jbuq44uz9TfaOttm==JXdt-6RXrh@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] headers: fix circular dependency between
 linux/sched.h and linux/wait.h
From: David Cohen <dacohen@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, linux-omap@vger.kernel.org, linux-media@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 7:27 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 02/21, Oleg Nesterov wrote:
>>
>> On 02/21, Peter Zijlstra wrote:
>> >
>> > afaict its needed because struct signal_struct and struct sighand_struct
>> > include a wait_queue_head_t. The inclusion seems to come through
>> > completion.h, but afaict we don't actually need to include completion.h
>> > because all we have is a pointer to a completion, which is perfectly
>> > fine with an incomplete type.
>> >
>> > This all would suggest we move the signal bits into their own header
>> > (include/linux/signal.h already exists and seems inviting).
>>
>> Agreed, sched.h contatins a lot of garbage, including the signal bits.
>>
>> As for signal_struct in particular I am not really sure, it is just
>> misnamed. It is in fact "struct process" or "struct thread_group". But
>> dequeue_signal/etc should go into signal.h.
>>
>> The only problem, it is not clear how to test such a change.
>
> Ah. sched.h includes signal.h, the testing is not the problem.

If sched.h includes signal.h and we move wait_queue_head_t users to
signal.h, it means signal.h should include wait.h and then it is a
problem to include sched.h in wait.h.

>
> So, we can (at least) safely move some declarations.

Safely, yes, but it won't solve the issue for TASK_* in wait.h.

Br,

David

>
> Oleg.
>
>
