Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab0KEPRM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 11:17:12 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41973 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab0KEPRL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 11:17:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TeeexM3i5sCH6tl45wH6HsOzBJxQaI0Q9XuvfNx8mGWV0Hc6Rw1cjrFsKM5hQVLGQk
         g7UN5zY+yLBbF365GSm2XPnbz4eGgS/GJKUL9k7Uj/D5vzdWYTqkvaAGhrEPgFUwJtW4
         3VkH7DV4Tw+TXt1u8iWmLCiqD/ZDP2toKBQuY=
MIME-Version: 1.0
In-Reply-To: <4CD3396D.1090308@windriver.com>
References: <4CD3396D.1090308@windriver.com>
Date: Fri, 5 Nov 2010 16:17:10 +0100
Message-ID: <AANLkTinGGRmct-XoY5Tv_WsBZ11MmgHgbsbbiBDTk5dj@mail.gmail.com>
Subject: Re: [PATCH] perf,hw_breakpoint: Initialize hardware api earlier
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/4 Jason Wessel <jason.wessel@windriver.com>:
>
> Hi Frederic,
>
> Per our conversation, here is a possible patch to fix the early
> debugging.  It might be the case that you can kill off the return code
> from the init_hw_breakpoint(), or at least do something with it.  It
> was not obvious to me what you might want to emit for a mess or act on
> if the initialization fails.



Ok, we can kill the return code from it, but we need to keep some
warnings in case
of failure.


>
>
> Thanks,
> Jason.
>
>
> --
> From 7c425dba3a4522343faf3519f3d0e99e2e55f30c Mon Sep 17 00:00:00 2001
> From: Jason Wessel <jason.wessel@windriver.com>
> Date: Thu, 4 Nov 2010 17:33:01 -0500
> Subject: [PATCH] perf,hw_breakpoint: Initialize hardware api earlier
>
> When using early debugging, the kernel does not initialize the
> hw_breakpoint API early enough and causes the late initialization of
> the kernel debugger to fail. The boot arguments are:
>
>    earlyprintk=vga ekgdboc=kbd kgdbwait
>
> Then simply type "go" at the kdb prompt and boot. The kernel will
> later emit the message:
>
>    kgdb: Could not allocate hwbreakpoints
>
> And at that point the kernel debugger will cease to work correctly.
>
> The solution is to initialize the hw_breakpoint at the same time that
> all the other perf call backs are initialized instead of using a
> core_initcall() initialization which happens well after the kernel
> debugger can make use of hardware breakpoints.
>
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---


For the rest, it looks good.

Thanks!
