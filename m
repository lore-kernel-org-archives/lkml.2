Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280Ab0HYB4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 21:56:07 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:57876 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594Ab0HYB4E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 21:56:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QIwszJ6KQxTQVC2PwpoozSDgO3vI4MkMhl5s1VAYn8KqGN8oLfWGeM62o0A/7oS4Bb
         krxPMwkgYP8YMs8OIvDvdUKnMfp/+LKB5pEY4npQfGCXJBnl00cvlKIw0lZ1vDCJZDK2
         ElQtSSk01h7b1or9qd/mdj+IoEbHPtRRSyaMg=
MIME-Version: 1.0
In-Reply-To: <20100824163149.GA7415@redhat.com>
References: <1282633129-9187-1-git-send-email-yong.zhang0@gmail.com>
	<1282633129-9187-2-git-send-email-yong.zhang0@gmail.com>
	<20100824121109.GA13061@redhat.com>
	<20100824124958.GA3070@zhy>
	<20100824163149.GA7415@redhat.com>
Date: Wed, 25 Aug 2010 09:56:03 +0800
Message-ID: <AANLkTikqZTt+jd6X7ZwPBnz0AqDRgP=RNJc5OBtM+Yf_@mail.gmail.com>
Subject: Re: [RFC PATCH 1/3] timer: fix comments of try_to_del_timer_sync()
From: Yong Zhang <yong.zhang0@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, mingo@elte.hu, peterz@infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 25, 2010 at 12:31 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> Ah, indeed, I forgot. This was another reason for the comment.
>
>> > Please remove "#ifdef CONFIG_SMP" from set_running_timer(), then iirc
>> > it can be used from irq.
>>
>> I have noticed your comments in the commit log, but I think it's about
>> introducing the same semantic of try_to_del_timer_sync() on UP as well
>> as SMP. But this patch is focusing on the current code(SMP special).
>> Not about realizing try_to_del_timer_sync() on UP case. Do we need
>> to do that?
>
> I dunno.
>
> But look, currently try_to_del_timer_sync() is not allowed from interrupt
> even if it works with CONFIG_SMP.
>
> If we "officially" allow it to use from irq, it should work on UP too

OK. I see.

> but
> it doesn't. del_timer() can't hang, but it can never return -1 to indicate
> we hit the running timer.
>
> Consider:
>
>        // runs in interrup context
>
>        if (try_do_del_timer_sync(&TIMER) > 0)
>                kfree(something_which_can_be_used_by_TIMER_func);
>
> This is unsafe on UP.

You are right. It's unsafe here.

I will try to update this patch which introduce try_do_del_timer_sync()
on UP case.

Thanks,
Yong
