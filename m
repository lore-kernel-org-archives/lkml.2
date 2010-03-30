Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab0C3PbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 11:31:24 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41383 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752447Ab0C3PbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 11:31:22 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.31 and later] "struct pid" leak.
References: <201003272121.ADE39095.JLFHOOMtSVOFQF@I-love.SAKURA.ne.jp>
Date: Tue, 30 Mar 2010 16:31:13 +0100
In-Reply-To: <201003272121.ADE39095.JLFHOOMtSVOFQF@I-love.SAKURA.ne.jp>
	(Tetsuo Handa's message of "Sat, 27 Mar 2010 21:21:57 +0900")
Message-ID: <tnxbpe5ygfy.fsf@e102109-lin.cambridge.arm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 30 Mar 2010 15:31:18.0151 (UTC) FILETIME=[0AC13170:01CAD01E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:
> I got below report with 2.6.33.1 .
>
> unreferenced object 0xde144600 (size 64):
>   comm "init", pid 1, jiffies 4294678101 (age 291.508s)
>   hex dump (first 32 bytes):
>     02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 04 76 ae de d1 76 43 c0 d6 08 00 00  .....v...vC.....
>   backtrace:
>     [<c0481704>] create_object+0x121/0x1ef
>     [<c05f546b>] kmemleak_alloc+0x25/0x42
>     [<c047e326>] kmemleak_alloc_recursive+0x1c/0x22
>     [<c047e36e>] kmem_cache_alloc+0x42/0x68
>     [<c0437701>] alloc_pid+0x19/0x288
>     [<c0428acc>] copy_process+0x95a/0xdac
>     [<c04290d8>] do_fork+0x129/0x261
>     [<c0407de5>] sys_clone+0x1f/0x24
>     [<c040292d>] ptregs_clone+0x15/0x28
>     [<ffffffff>] 0xffffffff
> unreferenced object 0xdfa96a40 (size 64):
>   comm "login", pid 2259, jiffies 4294719437 (age 250.179s)
>   hex dump (first 32 bytes):
>     02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 60 39 ae de d1 76 43 c0 bb 09 00 00  ....`9...vC.....
>   backtrace:
>     [<c0481704>] create_object+0x121/0x1ef
>     [<c05f546b>] kmemleak_alloc+0x25/0x42
>     [<c047e326>] kmemleak_alloc_recursive+0x1c/0x22
>     [<c047e36e>] kmem_cache_alloc+0x42/0x68
>     [<c0437701>] alloc_pid+0x19/0x288
>     [<c0428acc>] copy_process+0x95a/0xdac
>     [<c04290d8>] do_fork+0x129/0x261
>     [<c0407de5>] sys_clone+0x1f/0x24
>     [<c040292d>] ptregs_clone+0x15/0x28
>     [<ffffffff>] 0xffffffff

I reported similar leaks last year -
http://lkml.org/lkml/2009/7/8/422. There is some analysis in the thread
above of the reference counting but I couldn't figure out where it goes
wrong. It looks to me like there isn't any reference to a struct pid
block but its reference count is 2.

There is a bugzilla entry as well -
https://bugzilla.kernel.org/show_bug.cgi?id=13868

-- 
Catalin
