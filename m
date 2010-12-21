Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933456Ab0LUByU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 20:54:20 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55928 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933407Ab0LUByT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 20:54:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=JvYL7yH3fenhv+h7hixOFIlZfu7NYoOCJV7f/SPxmxO6EgSWkQH5eJq3D0ScYlaOIN
         LTWiUbXExjszkK8X5RLE1nFwQm51qJJd8YwDFb556JVnnbvPuOnlQTRVPPH4IxwWV5IT
         YNNtTut+wymVMNyDWsR4f30xTomVWlgJSwNYI=
MIME-Version: 1.0
In-Reply-To: <4D0F8276.9070903@kernel.org>
References: <1292762975.2403.29.camel@localhost>
	<AANLkTimYx2Og1BG37wb0WZ0_U8WJjLKHMKgU45qycUaM@mail.gmail.com>
	<AANLkTikuKMLUoVnQsU6QNCnHBgOponJUngHGtyVHk1xK@mail.gmail.com>
	<4D0F8276.9070903@kernel.org>
Date: Tue, 21 Dec 2010 09:54:18 +0800
Message-ID: <AANLkTikVwGqhCxuCjW1AceBaZp-iCY=1cxge5xqyNSBd@mail.gmail.com>
Subject: Re: [PATCH] kthread_worker: Initialize dynamically allocated spinlock
 properly for lockdep
From: Yong Zhang <yong.zhang0@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andy Walls <awalls@md.metrocast.net>, linux-kernel@vger.kernel.org,
        nicolas.mailhot@laposte.net, Jarod Wilson <jarod@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 12:21 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On 12/20/2010 10:28 AM, Yong Zhang wrote:
>> Subject: [PATCH] kthread_work: Make lockdep happy
>>
>> spinlock in kthread_worker and wait_queue_head in kthread_work
>> both should be lockdep annotated.
>> So change the interface to make it suiltable for CONFIG_LOCKDEP.
>>
>> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
>> ---
>> I'm not sure if it's possible to define a worker on stack?
>> So I left DEFINE_KTHREAD_WORKER() untouched.
>
> Yes, it can, I think.

Thanks for your confirmation, I will update the patch in V2.

>BTW, where are you using kthread_worker?

I don't have anything using kthread_worker, but go through
the kernel and find ivtv is the only one.
This is why I sent the untested patch :)

> I'm
> planning to update its flush semantics similar to that of proper
> workqueue so that it's less confusing and switching between the two is
> easy, so its usage may change slightly soon, although conversion
> shouldn't be difficult.

No problem. Now I just make the patch based on the current
kthread_work*.

Thanks,
Yong

-- 
Only stand for myself.
