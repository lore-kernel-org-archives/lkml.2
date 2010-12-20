Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932824Ab0LTQVQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 11:21:16 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:50205 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932780Ab0LTQVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 11:21:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=HMA6dpy+xLiHuVtpVFBCjqF5Ktfh9mMUuV4V+UIXL+ipLWLm8Bv/is25OxxWI74ITR
         rgqniHc+sc02F2iu6TS9465FBPdKpPS99pVab71SSxlZU/ETB5IEiPPJEgUxWp0wtbEL
         fjtr5nqsMToibyplwjUEB7OelvVKbvRn3VUqU=
Message-ID: <4D0F8276.9070903@kernel.org>
Date: Mon, 20 Dec 2010 17:21:10 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Yong Zhang <yong.zhang0@gmail.com>
CC: Andy Walls <awalls@md.metrocast.net>, linux-kernel@vger.kernel.org,
        nicolas.mailhot@laposte.net, Jarod Wilson <jarod@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] kthread_worker: Initialize dynamically allocated spinlock
 properly for lockdep
References: <1292762975.2403.29.camel@localhost>	<AANLkTimYx2Og1BG37wb0WZ0_U8WJjLKHMKgU45qycUaM@mail.gmail.com> <AANLkTikuKMLUoVnQsU6QNCnHBgOponJUngHGtyVHk1xK@mail.gmail.com>
In-Reply-To: <AANLkTikuKMLUoVnQsU6QNCnHBgOponJUngHGtyVHk1xK@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/20/2010 10:28 AM, Yong Zhang wrote:
> Subject: [PATCH] kthread_work: Make lockdep happy
> 
> spinlock in kthread_worker and wait_queue_head in kthread_work
> both should be lockdep annotated.
> So change the interface to make it suiltable for CONFIG_LOCKDEP.
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> ---
> I'm not sure if it's possible to define a worker on stack?
> So I left DEFINE_KTHREAD_WORKER() untouched.

Yes, it can, I think.  BTW, where are you using kthread_worker?  I'm
planning to update its flush semantics similar to that of proper
workqueue so that it's less confusing and switching between the two is
easy, so its usage may change slightly soon, although conversion
shouldn't be difficult.

Thanks.

-- 
tejun
