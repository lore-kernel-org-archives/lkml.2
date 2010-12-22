Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab0LVDMt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 22:12:49 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37770 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab0LVDMs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 22:12:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pH4C0vJOA84Q8WfdSclQs3sv3xrLEfORp7g9R9ZnxZWy4pZClh3k4I/g1H5c+pHAve
         ShGlRjj4vho8oi6FkYuNXYFVcQt3V9luTtNxcfbgHyEEnErCDBbVfwA6fnRO20FEqVzZ
         N/UXGpsCrqJVoslDzezshBMQ/05Go62WUHDdA=
MIME-Version: 1.0
In-Reply-To: <1292978393.2401.14.camel@morgan.silverblock.net>
References: <1292762975.2403.29.camel@localhost>
	<AANLkTimYx2Og1BG37wb0WZ0_U8WJjLKHMKgU45qycUaM@mail.gmail.com>
	<AANLkTikuKMLUoVnQsU6QNCnHBgOponJUngHGtyVHk1xK@mail.gmail.com>
	<4D0F8276.9070903@kernel.org>
	<20101221044050.GA25718@windriver.com>
	<1292978393.2401.14.camel@morgan.silverblock.net>
Date: Wed, 22 Dec 2010 11:12:47 +0800
Message-ID: <AANLkTi=zw=0=7bAg9uV+u6bA6iY63k_GX9vo=G+bX0O3@mail.gmail.com>
Subject: Re: [V2 PATCH] kthread_work: Make lockdep happy
From: Yong Zhang <yong.zhang0@gmail.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        nicolas.mailhot@laposte.net, Jarod Wilson <jarod@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 8:39 AM, Andy Walls <awalls@md.metrocast.net> wrote:
> Yong,
>
> I have tested your patch with the following patch on top of yours.  I
> find the two patches together acceptable in testing in a machine with
> both a PVR-350 card and a PVR-500 card installed.
>
> Tested-by: Andy Walls <awalls@md.metrocast.net>
> Signed-off-by: Andy Walls <awalls@md.metrocast.net>
>
> Could you please author a [V3 PATCH] adding my changes?

Sure. Will do it.

> Since the
> majority of the change is your work, it should be attributed to you as
> the author.
>
>
> About my additional changes:
>
> I needed the explicit EXPORT_SYMBOL_GPL(__init_kthread_worker),
> otherwise the build would fail, because the ivtv module had an
> unresolved symbol.

Will update.

>
> I added the lockdep class name to make it easier to identify the ivtv
> module's kthread worker's lock class.  Now one can actually recognize
> the lock class in lockdep output strings:
>
>        # cat lockdep | grep itv
>        ffffffffa0483a60 FD:    1 BD:    1 ......: (&itv->irq_worker)->lock

Yeah, I like your idea.

V3 coming soon :)

Thanks,
Yong
-- 
Only stand for myself.
