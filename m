Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273Ab1K3UHK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 15:07:10 -0500
Received: from hera.cwi.nl ([192.16.191.8]:63649 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939Ab1K3UHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 15:07:08 -0500
Message-ID: <4ED68CCE.1070400@cwi.nl>
Date: Wed, 30 Nov 2011 20:06:38 +0000
From: "Wouter M. Koolen" <W.M.Koolen-Wijkstra@cwi.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: "Wouter M. Koolen" <W.M.Koolen-Wijkstra@cwi.nl>
CC: Catalin Marinas <catalin.marinas@arm.com>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        x86@kernel.org, keithp@keithp.com
Subject: Re: kmemleak: unreferenced object in copy_thread
References: <4ED3CE60.2060901@cwi.nl> <CAHkRjk69fwTy0+w4LyXeai5ekCirC1D5V7-Gkja6MbKqJ_-KFw@mail.gmail.com> <4ED68BBF.8010608@cwi.nl>
In-Reply-To: <4ED68BBF.8010608@cwi.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add i915 maintainer Keith Packard to CC.

On 11/30/2011 08:02 PM, Wouter M. Koolen wrote:
>
> On 11/30/2011 11:54 AM, Catalin Marinas wrote:
>> I can't yet tell whether it's a false positive or not. Did the X
>> server die? Is the process with pid 1415 still around? The leaked
>> object looks like the thread stack (8K) and it should have been
>> removed when the corresponding process was killed.
> Hi Catalin,
>
> Just got lucky and hit it again. This time it occurred without 
> killing. Here's the splat:
>
> unreferenced object 0xffff880003eda000 (size 8192):
>   comm "Xorg", pid 1117, jiffies 4295143832 (age 34745.832s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 0f 00 00 00 0f 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<ffffffff813feeb1>] kmemleak_alloc+0x21/0x50
>     [<ffffffff8111086b>] kmem_cache_alloc_trace+0xdb/0x1d0
>     [<ffffffff81001fbe>] copy_thread+0x1be/0x260
>     [<ffffffff81044953>] copy_process+0xee3/0x1520
>     [<ffffffff810450d6>] do_fork+0x116/0x350
>     [<ffffffff8100a7d3>] sys_clone+0x23/0x30
>     [<ffffffff8141c173>] stub_clone+0x13/0x20
>     [<ffffffffffffffff>] 0xffffffffffffffff
>
> The process 1117 is still alive. It is
>
> root      1117  2.1  1.3 147484 28152 tty7     Ss+  09:55  13:02 
> /usr/bin/X :0 vt7 -br -nolisten tcp -auth /var/run/xauth/A:0-Tdu4bb
>
>
> Actually, there now are several splats of a second kind, relating to 
> i915 gem buffers (attached). This type of splat has been reported 
> before in
> https://lkml.org/lkml/2011/10/4/15
> although that thread seems to be a dead end. Maybe these warnings have 
> a common source?
>
> What would be a good next step?
>
> With kind regards,
>
> Wouter Koolen
