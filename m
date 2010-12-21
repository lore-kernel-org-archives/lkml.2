Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743Ab0LUM7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 07:59:41 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:38614 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965Ab0LUM7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 07:59:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hWn2lM6Z+Rb7S/tf8+NMtrbwJbIZxkeUj6Pmx9Qs/UK8h2xby9bt90qmBMfg5c5R1c
         gcaXcviYvz7+/r8lv1zG7st9e18obYXWtgYYfAgiTOL/iMjVCSvik4PHqdotOZZMo/P6
         W1LTABMvbj1ZUTn/H3SKmcFyyjkJWNt+1Zo9U=
Date: Tue, 21 Dec 2010 13:59:36 +0100
From: Tejun Heo <tj@kernel.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Andy Walls <awalls@md.metrocast.net>, linux-kernel@vger.kernel.org,
        nicolas.mailhot@laposte.net, Jarod Wilson <jarod@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [V2 PATCH] kthread_work: Make lockdep happy
Message-ID: <20101221125934.GA13285@htj.dyndns.org>
References: <1292762975.2403.29.camel@localhost>
 <AANLkTimYx2Og1BG37wb0WZ0_U8WJjLKHMKgU45qycUaM@mail.gmail.com>
 <AANLkTikuKMLUoVnQsU6QNCnHBgOponJUngHGtyVHk1xK@mail.gmail.com>
 <4D0F8276.9070903@kernel.org>
 <20101221044050.GA25718@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101221044050.GA25718@windriver.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Dec 21, 2010 at 12:40:50PM +0800, Yong Zhang wrote:
> From: Yong Zhang <yong.zhang0@gmail.com>
> Subject: [V2 PATCH] kthread_work: Make lockdep happy
> 
> spinlock in kthread_worker and wait_queue_head in kthread_work
> both should be lockdep sensible.
> So change the interface to make it suiltable for CONFIG_LOCKDEP.
> 
> Reported-by: Nicolas <nicolas.mailhot@laposte.net>
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Andy Walls <awalls@md.metrocast.net>
> ---
> Changes from V1:
>  *According to Tejun, kthread_worker could be defined on stack,
>   So introduce DEFINE_KTHREAD_WORKER_ONSTACK.
>  *Change wrong setting to kthread_work->task. Thanks Adny for
>   pointing it.
>  *including some minor issue.
> 
> BTW, only passed build.

If somebody can confirm this makes lockdep behave correctly, I'll
route it through the wq tree.

Thanks.

-- 
tejun
