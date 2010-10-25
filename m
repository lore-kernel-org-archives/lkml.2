Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab0JYH41 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 03:56:27 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50222 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab0JYH40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 03:56:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ExsmLu9qj8JUnt4REogZMOyZ0HRjcm1iwvVfjqcbX/zbcrxfkIAVEHEXGPe0186HLW
         p0NT7l154WnvbiPkMPbhso1Cyl4BFAv4FXxDIWluVsVwVXZnIWQwPCljH5NULlHf7Zkx
         p0iDXX9By7h/6ufLdivSkD3pupc8jftkraswU=
Date: Mon, 25 Oct 2010 00:56:17 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessandro Rubini <rubini@cvml.unipv.it>
Subject: Re: 2.6.36-git4 -- BUG: looking up invalid subclass: 31 -- turning
 off the locking correctness validator.
Message-ID: <20101025075617.GE1438@core.coreip.homeip.net>
References: <AANLkTinDR=r-x+CDO0tFUOYMjwYBH0DvvxxgjCYfaXrJ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinDR=r-x+CDO0tFUOYMjwYBH0DvvxxgjCYfaXrJ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miles,

On Sun, Oct 24, 2010 at 06:00:30PM -0400, Miles Lane wrote:
> BUG: looking up invalid subclass: 31
> turning off the locking correctness validator.
> Pid: 1, comm: swapper Not tainted 2.6.36-git4 #3
> Call Trace:
>  [<ffffffff810634a7>] look_up_lock_class+0x66/0xe6
>  [<ffffffff81063940>] register_lock_class+0x1e/0x30e
>  [<ffffffff81062d07>] ? trace_hardirqs_on+0xd/0xf
>  [<ffffffff81064f70>] lockdep_init_map+0xf9/0x10c
>  [<ffffffff812a949b>] mousedev_create+0xb3/0x1e7
>  [<ffffffff816a2afe>] ? mousedev_init+0x0/0x62
>  [<ffffffff816a2b1a>] mousedev_init+0x1c/0x62
>  [<ffffffff81000336>] do_one_initcall+0x7a/0x130
>  [<ffffffff8167ad1e>] kernel_init+0x148/0x1d2
>  [<ffffffff81003854>] kernel_thread_helper+0x4/0x10
>  [<ffffffff8102ea4f>] ? finish_task_switch+0x3f/0x9a
>  [<ffffffff813619c0>] ? restore_args+0x0/0x30
>  [<ffffffff8167abd6>] ? kernel_init+0x0/0x1d2
>  [<ffffffff81003850>] ? kernel_thread_helper+0x0/0x10

This should be fixed by:

commit f74eef95e33a07379aa2b950c7f313cbfd55ebbe
Author: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Date:   Wed Oct 13 11:35:40 2010 -0700

    Input: mousedev - correct lockdep annotation
    
    When annotating mutex to avoid false lockdep reports we should not
    be using MOUSEDEV_MIX as lock subclass but rather SINGLE_DEPTH_NESTING.
    
    Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
    Signed-off-by: Dmitry Torokhov <dtor@mail.ru>

once Linus pulls from my tree.

Thanks.

-- 
Dmitry
