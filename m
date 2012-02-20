Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab2BTCJm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 21:09:42 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:37169 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510Ab2BTCJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 21:09:41 -0500
Message-ID: <eab6890e2976525235b93e171607d17d.squirrel@webmail.greenhost.nl>
In-Reply-To: <CA+55aFwHGUB7R6kpNPc7vDYF8dhYCKm4Riso-rpS2Fiqjg8hQg@mail.gmail.com>
References: <alpine.LFD.2.02.1202191412060.3898@i5.linux-foundation.org>
    <12996.1329699216@neuling.org>
    <CA+55aFwHGUB7R6kpNPc7vDYF8dhYCKm4Riso-rpS2Fiqjg8hQg@mail.gmail.com>
Date: Mon, 20 Feb 2012 03:09:28 +0100
Subject: Re: [PATCH 0/2] More i387 state save/restore work
From: "Indan Zupancic" <indan@nul.nu>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Michael Neuling" <mikey@neuling.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        benh@kernel.crashing.org, anton@samba.org
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.1
X-Scan-Signature: e462de357cb394d64966911c06262bc8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, February 20, 2012 02:03, Linus Torvalds wrote:
> On Sun, Feb 19, 2012 at 4:53 PM, Michael Neuling <mikey@neuling.org> wrote:
>>
>> Does "2476844 loops in 2 seconds" imply 2476844 context switches in 2
>> sec?  With Anton's context_switch [1] benchmark, we don't even hit 100K
>> context switches per sec.

No, it implies 2476844 context switches per second, because it only counts
the loops in one process, and it takes two context switches to switch away
and back again.

My numbers for context_switch.c are 418K for no VDSO/FPU and 413K with FPU.
Linus' test program gets:

1050525 loops in 2 seconds with FPU
1150258 loops in 2 seconds with use_math() commented.

So it seems that the overhead of doing the pipe thing is quite high compared
to sched_yield().

These numbers are for an old Pentium M pinned at 1.4GHz, so getting only
100K seems very bad.

>>
>> Do you have this test program anywhere?
>
> Here. No guarantees that this is at all sane, it's special-cased code
> literally for testing only this one issue. The only indication I have
> that this works at all is that the numbers did change roughly as
> expected, and the kernel profile changes made sense.

I tested both programs, and your loops per second is half the context
switches according to vmstat, so it works as expected. I haven't tested
your FPU patches though.

Greetings,

Indan


