Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235Ab1AKOcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 09:32:53 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38765 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016Ab1AKOct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 09:32:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iYKNGsI3XE0JeguPi1veSEKd502RS0Cq4itVQP5TCI3C+cja/RhM6e14LwxnqzeKV+
         T+TPPSMkcbL/Me6cmZ+6JJ+pHDMqHizUrZAfJga/F65lvOOn60XYxry61tk62AKw68X8
         PWKD0+l6DL+NP/niNoJDrG0hLQP3mu7hlRseo=
Date: Tue, 11 Jan 2011 15:32:44 +0100
From: Tejun Heo <tj@kernel.org>
To: Tony Luck <tony.luck@gmail.com>
Cc: Minchan Kim <minchan.kim@gmail.com>, Jiri Slaby <jirislaby@gmail.com>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: WARNING: at kernel/workqueue.c [was: mmotm 2011-01-06-15-41
 uploaded]
Message-ID: <20110111143244.GC30607@htj.dyndns.org>
References: <201101070014.p070Egpo023959@imap1.linux-foundation.org>
 <4D2ADD43.2020702@gmail.com>
 <AANLkTin7h=R0cfzpeuvpTAGRFCsFocJezpW7Riz5Za4z@mail.gmail.com>
 <AANLkTimeUN9m-roDmsfaMaiD4wZw1wETYsf+dONjpmyj@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimeUN9m-roDmsfaMaiD4wZw1wETYsf+dONjpmyj@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 03:36:09PM -0800, Tony Luck wrote:
> > Here it is, too.
> > mmotm-01-06
> 
> Also in today's linux-next (tag: next-20110110) on ia64:
> 
> 
> ------------[ cut here ]------------
> WARNING: at kernel/workqueue.c:1202 worker_enter_idle+0x3f0/0x4a0()
> Hardware name: server rx2620
> Modules linked in:
> 
> Call Trace:
>  [<a000000100014cb0>] show_stack+0x50/0xa0
>                                 sp=e0000040600d7c30 bsp=e0000040600d0dd0
>  [<a000000100bcaa20>] dump_stack+0x30/0x50
>                                 sp=e0000040600d7e00 bsp=e0000040600d0db8
>  [<a000000100082260>] warn_slowpath_common+0xc0/0x100
>                                 sp=e0000040600d7e00 bsp=e0000040600d0d78
>  [<a0000001000822e0>] warn_slowpath_null+0x40/0x60
>                                 sp=e0000040600d7e00 bsp=e0000040600d0d50
>  [<a0000001000b0830>] worker_enter_idle+0x3f0/0x4a0
>                                 sp=e0000040600d7e00 bsp=e0000040600d0d28
>  [<a0000001000b2c80>] worker_thread+0x8c0/0x980
>                                 sp=e0000040600d7e00 bsp=e0000040600d0c28
>  [<a0000001000c08c0>] kthread+0x120/0x160
>                                 sp=e0000040600d7e00 bsp=e0000040600d0be8
>  [<a000000100012ef0>] kernel_thread_helper+0x30/0x60
>                                 sp=e0000040600d7e30 bsp=e0000040600d0bc0
>  [<a00000010000a0c0>] start_kernel_thread+0x20/0x40
>                                 sp=e0000040600d7e30 bsp=e0000040600d0bc0
> ---[ end trace 7e2fb881ec0622f8 ]---

Ah, of course, it's commit 21ec12364bb78b72ad36b94269c64b3ee31b038f
(workqueue: remove noop condition check in worker_clr_flags()).  The
condition it removes is not a noop.  Reverting it.

Thank you.

-- 
tejun
