Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab1EQOrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 10:47:12 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61333 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225Ab1EQOrL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 10:47:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Whg1jht1OTIi6//2ivFX26FbvzKdUtCqlLxygU8fEaUEzqiwXlj7WgTg1lCLDaAkzO
         u9+euCKjaWSrm3gMrNHf+vrQeWAlg+/40k5tMlSVN4SVx34yP5s4maPMG6Xe9YwwwLZu
         yOwUSSYKJ2dUIpC6sbbneKqEgkhiBkI7Fyi6A=
MIME-Version: 1.0
In-Reply-To: <BANLkTikPhwajRBZ-dx46NnobOu10AmXoSg@mail.gmail.com>
References: <BANLkTinw9LLiGD788+6AvbE+54jyVRUwBg@mail.gmail.com>
	<BANLkTikPhwajRBZ-dx46NnobOu10AmXoSg@mail.gmail.com>
Date: Tue, 17 May 2011 22:47:09 +0800
Message-ID: <BANLkTimOfL9iWFEhV6tQcTBM+V5N3b+-YA@mail.gmail.com>
Subject: Re: [PATCH] sched: fix how RT task is pulled
From: Hillf Danton <dhillf@gmail.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 10:35 AM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> On Sun, May 15, 2011 at 10:50 AM, Hillf Danton <dhillf@gmail.com> wrote:
>> When pulling RT task for a given runqueue, if it is already overloaded
>> with RT tasks, the pull operation could be avoided at the moment.
>>
>> btw, it looks like a typo?
>
> No.
>
> Below is how rt_overloaded() is realized:
> static inline int rt_overloaded(struct rq *rq)
> {
>        return atomic_read(&rq->rd->rto_count);
> }
>
> You can notice it's about the overload of the very root_domain.
>
Well, why is it going no head if not overloaded?

thanks
          Hillf
