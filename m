Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab0LVJds (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 04:33:48 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:40679 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab0LVJdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 04:33:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ln7Z8EqypkpNWRit+tCA51ZmXiznDQg8LKARFYSDGoS7ezJgrW/lW29+8J4wiGlXOe
         csIpuX+EdbZFghxAVkvNugyCP3GvAihT8IrgiD2rbsQwbjadQdalfp80C1mo7lcmepMX
         yEg48ToIhuIqlO1hKFaj70oX8IBBYkPetvgqE=
Date: Wed, 22 Dec 2010 10:33:41 +0100
From: Tejun Heo <tj@kernel.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Andy Walls <awalls@md.metrocast.net>, linux-kernel@vger.kernel.org,
        nicolas.mailhot@laposte.net, Jarod Wilson <jarod@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [V3 PATCH] kthread_work: Make lockdep happy
Message-ID: <20101222093341.GA4684@htj.dyndns.org>
References: <1292762975.2403.29.camel@localhost>
 <AANLkTimYx2Og1BG37wb0WZ0_U8WJjLKHMKgU45qycUaM@mail.gmail.com>
 <AANLkTikuKMLUoVnQsU6QNCnHBgOponJUngHGtyVHk1xK@mail.gmail.com>
 <4D0F8276.9070903@kernel.org>
 <20101221044050.GA25718@windriver.com>
 <1292978393.2401.14.camel@morgan.silverblock.net>
 <20101222032305.GA30724@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101222032305.GA30724@windriver.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 11:23:05AM +0800, Yong Zhang wrote:
> From: Yong Zhang <yong.zhang0@gmail.com>
> Subject: [V3 PATCH] kthread_work: Make lockdep happy
> 
> spinlock in kthread_worker and wait_queue_head in kthread_work
> both should be lockdep sensible.
> So change the interface to make it suiltable for CONFIG_LOCKDEP.
> 
> Reported-by: Nicolas <nicolas.mailhot@laposte.net>
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> Signed-off-by: Andy Walls <awalls@md.metrocast.net>
> Tested-by: Andy Walls <awalls@md.metrocast.net>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>

Applied with the following comment update (because the term "special
work" was a bit too confusing given the context) to wq#for-linus.
Will push out to Linus in several days.

+/*
+ * kthread_worker.lock and kthread_work.done need their own lockdep class
+ * keys if they are defined on stack with lockdep enabled.  Use the
+ * following macros when defining them on stack.
+ */

Thank you.

-- 
tejun
