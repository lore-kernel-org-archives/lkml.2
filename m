Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791Ab1K3LzW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 06:55:22 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:47075 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757619Ab1K3LzV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 06:55:21 -0500
MIME-Version: 1.0
In-Reply-To: <4ED3CE60.2060901@cwi.nl>
References: <4ED3CE60.2060901@cwi.nl>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Wed, 30 Nov 2011 11:54:59 +0000
X-Google-Sender-Auth: 3Pa8bcehhDdO1J6hoThS9LIGdQI
Message-ID: <CAHkRjk69fwTy0+w4LyXeai5ekCirC1D5V7-Gkja6MbKqJ_-KFw@mail.gmail.com>
Subject: Re: kmemleak: unreferenced object in copy_thread
To: "Wouter M. Koolen" <W.M.Koolen-Wijkstra@cwi.nl>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 November 2011 18:09, Wouter M. Koolen <W.M.Koolen-Wijkstra@cwi.nl> wrote:
> Dear kmemleak and/or x86 maintainers,
>
> I asked for too much memory. The machine started swapping. I killed the hog.
> Then I found this gem:
>
> unreferenced object 0xffff8800006ea000 (size 8192):
>  comm "Xorg", pid 1415, jiffies 4298164697 (age 2433.696s)
>  hex dump (first 32 bytes):
>    00 00 00 00 00 00 00 00 0f 00 00 00 0f 00 00 00  ................
>    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>  backtrace:
>    [<ffffffff813feeb1>] kmemleak_alloc+0x21/0x50
>    [<ffffffff8111086b>] kmem_cache_alloc_trace+0xdb/0x1d0
>    [<ffffffff81001fbe>] copy_thread+0x1be/0x260
>    [<ffffffff81044953>] copy_process+0xee3/0x1520
>    [<ffffffff810450d6>] do_fork+0x116/0x350
>    [<ffffffff8100a7d3>] sys_clone+0x23/0x30
>    [<ffffffff8141c173>] stub_clone+0x13/0x20
>    [<ffffffffffffffff>] 0xffffffffffffffff

I can't yet tell whether it's a false positive or not. Did the X
server die? Is the process with pid 1415 still around? The leaked
object looks like the thread stack (8K) and it should have been
removed when the corresponding process was killed.

-- 
Catalin
