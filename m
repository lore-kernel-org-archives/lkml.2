Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab1F3SC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 14:02:57 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56361 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab1F3SCz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 14:02:55 -0400
MIME-Version: 1.0
In-Reply-To: <20110630112804.GA21481@flint.arm.linux.org.uk>
References: <BANLkTimfF3_R5VS4xOriGp+-3j-r7V0W0w@mail.gmail.com>
	<20110630074301.GC27959@flint.arm.linux.org.uk>
	<BANLkTimBTayh_mjOLMZbz3D+wqdtZ10=wA@mail.gmail.com>
	<20110630112804.GA21481@flint.arm.linux.org.uk>
Date: Thu, 30 Jun 2011 11:02:54 -0700
X-Google-Sender-Auth: Nh6oxXG91cZowAZnszRnx5WyQ9A
Message-ID: <BANLkTimo18w5yuE4jtATPvbgENCL04LMpA@mail.gmail.com>
Subject: Re: PROBLEM: ARM-dma-mapping-fix-for-speculative-prefetching cause OOPS
From: Dan Williams <dan.j.williams@intel.com>
To: Qin Dehua <qindehua@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        santosh.shilimkar@ti.com, neilb@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 4:28 AM, Russell King <rmk@arm.linux.org.uk> wrote:
> On Thu, Jun 30, 2011 at 07:16:24PM +0800, Qin Dehua wrote:
>> Commit 2ffe2da3e follows v2.6.32, the message is from kernel build on
>> commit 2ffe2da3e.
>>
>> The config has CONFIG_BUG=y and CONFIG_DEBUG_BUGVERBOSE=y, but the
>> message is Oops, not BUG() macro, so they don't have line number.
>
> In that case, the raid5 code contains an explicit NULL pointer
> dereference which isn't a BUG() - the code line disassembles to:
>
>   0:   ebfff1bc        bl      0xffffc6f8
>   4:   e28dd044        add     sp, sp, #68     ; 0x44
>   8:   e8bd8ff0        pop     {r4, r5, r6, r7, r8, r9, sl, fp, pc}
>   c:   e3a03000        mov     r3, #0  ; 0x0
>  10:   e5833000        str     r3, [r3] <=== faulting instruction
>
> So, if you're saying that's not a BUG(), then I don't know what it is
> and I'm afraid I can't help because the oops doesn't make any sense
> to me.
>

QinDehua,

Can you rebuild with CONFIG_DEBUG_INFO=y, reproduce the crash and then
send the output of:

$ gdb drivers/md/raid5.o
(gdb) li *(raid5d+0x580)
(gdb) li *(__release_stripe+0x1e4)
etc...

...those offsets might change so just grab whatever "PC is at "
reports in the oops.

--
Dan
