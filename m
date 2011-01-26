Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab1AZGtY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 01:49:24 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:61591 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab1AZGtX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 01:49:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Jlgpk+E4gsE+sCsR104uU8bwqeVgaNXykUUpmHxiZvWjZYtCm+/0g4Zkdf7qzL9i4x
         8N03O0NwOyyMJG44rT5/u3wXFIc8UzED5pe73UHSiRHbJS74VoFEH21vRei5ueh4RczP
         rZ+ENvML5GGO10Fv/jNinc/BzfvRFsFPKjPWw=
MIME-Version: 1.0
In-Reply-To: <20110126055610.GA2593@windriver.com>
References: <1295651224-29823-1-git-send-email-torbenh@gmx.de>
	<1295651224-29823-2-git-send-email-torbenh@gmx.de>
	<1295901169.4845.29.camel@work-vm>
	<alpine.LFD.2.00.1101242254420.31804@localhost6.localdomain6>
	<1295907672.2274.44.camel@twins>
	<alpine.LFD.2.00.1101242344090.31804@localhost6.localdomain6>
	<1295946514.28776.476.camel@laptop>
	<1295951677.28776.489.camel@laptop>
	<1295974319.28776.1070.camel@laptop>
	<20110126055610.GA2593@windriver.com>
Date: Wed, 26 Jan 2011 14:49:22 +0800
Message-ID: <AANLkTinGToHk-Rpc0p1s=RfDuXe=r=CuARb4xFfWNnuo@mail.gmail.com>
Subject: Re: [PATCH 01/18] move do_timer() from kernel/timer.c into kernel/time/timekeeping.c
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
        Torben Hohn <torbenh@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
        hch@infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 1:56 PM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Subject: [PATCH] sched: Move the calc_global_load() call into the scheduler
>
> Remove the calc_global_load() call from the timekeeping code and make
> it local to the scheduler.
>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> ---
>  include/linux/sched.h |    2 --
>  kernel/sched.c        |   34 +++++++++++++++++++++++-----------
>  kernel/timer.c        |    1 -
>  3 files changed, 23 insertions(+), 14 deletions(-)
> +
> +static __init void start_calc_global_timer()

should be
static __init void start_calc_global_timer(void)
