Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab0KMVp4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 16:45:56 -0500
Received: from casper.infradead.org ([85.118.1.10]:49773 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab0KMVpx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 16:45:53 -0500
Subject: Re: [PATCH 2/2] perf,hw_breakpoint: Initialize hardware api earlier
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>
In-Reply-To: <1289684273-26770-3-git-send-regression-fweisbec@gmail.com>
References: <1289684273-26770-1-git-send-regression-fweisbec@gmail.com>
	 <1289684273-26770-3-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 13 Nov 2010 22:46:06 +0100
Message-ID: <1289684766.2109.326.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-11-13 at 22:37 +0100, Frederic Weisbecker wrote:
> From: Jason Wessel <jason.wessel@windriver.com>
> 
> When using early debugging, the kernel does not initialize the
> hw_breakpoint API early enough and causes the late initialization of
> the kernel debugger to fail. The boot arguments are:
> 
>     earlyprintk=vga ekgdboc=kbd kgdbwait
> 
> Then simply type "go" at the kdb prompt and boot. The kernel will
> later emit the message:
> 
>     kgdb: Could not allocate hwbreakpoints
> 
> And at that point the kernel debugger will cease to work correctly.
> 
> The solution is to initialize the hw_breakpoint at the same time that
> all the other perf call backs are initialized instead of using a
> core_initcall() initialization which happens well after the kernel
> debugger can make use of hardware breakpoints.

How early is it needed? I've got a patch converting the x86 (still need
to do the other hardware pmus) to early_initcall() instead of random
places in the arch bringup (notably before the perf core init).


