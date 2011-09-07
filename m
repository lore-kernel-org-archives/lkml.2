Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab1IGQne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:43:34 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41448 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab1IGQnc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:43:32 -0400
MIME-Version: 1.0
In-Reply-To: <20110907162857.GB2327@n2100.arm.linux.org.uk>
References: <87ehzstr07.fsf@vostro.fn.ogness.net> <20110907144016.GA30719@e102109-lin.cambridge.arm.com>
 <20110907162857.GB2327@n2100.arm.linux.org.uk>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Wed, 7 Sep 2011 17:43:12 +0100
X-Google-Sender-Auth: kPzkN2A7W4YMgyfn294TkuuZrgI
Message-ID: <CAHkRjk4CQAMb5GdGxKY3oASQYA6a3w0dCNXbD3pF4NFKgmPfQQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: alignment: setup alignment handler earlier
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Dave Martin <dave.martin@linaro.org>,
        John Ogness <john.ogness@linutronix.de>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 September 2011 17:28, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Wed, Sep 07, 2011 at 03:40:16PM +0100, Catalin Marinas wrote:
>> On Wed, Sep 07, 2011 at 02:35:04PM +0100, John Ogness wrote:
>> > From 6f3f381800367127dc6430d9b9fa9bd6fc6d8ed0 Mon Sep 17 00:00:00 2001
>> > From: John Ogness <john.ogness@linutronix.de>
>> >
>> > The alignment exception handler is setup fairly late in
>> > the boot process (fs_initcall). However, with newer gcc
>> > versions and the compiler option -fconserve-stack, code
>> > accessing unaligned data is generated in functions that
>> > are called earlier, for example pcpu_dump_alloc_info().
>> > This results in unhandled alignment exceptions during
>> > boot. By setting up the exception handler sooner, we
>> > reduce the window where a compiler may generate code
>> > accessing unaligned data.
>>
>> While this reduces the window and fixes this particular case, it still
>> doesn't solve the problem. We never know when some unaligned access
>> would be generated for some earlier code.
>
> Is the problem even solvable?  There are instructions on ARMv6+ which
> always produce an alignment fault (eg, ldrd) irrespective of strict
> alignment checking.

We can just hope that the compiler isn't that bad as to generate
unaligned accesses with those instructions that are known to fault.
That's what I would consider a compiler bug.

-- 
Catalin
