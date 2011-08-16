Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab1HPVo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 17:44:59 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35325 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab1HPVo6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 17:44:58 -0400
MIME-Version: 1.0
In-Reply-To: <1629809.vjtjo6obCs@wuerfel>
References: <1313529267-4428-1-git-send-email-wad@chromium.org>
	<1629809.vjtjo6obCs@wuerfel>
Date: Tue, 16 Aug 2011 16:44:56 -0500
Message-ID: <CABqD9hYavCxA38GbBhbCmBT+PEQQsvhbF4U7xY8P8ygbFy+=Ag@mail.gmail.com>
Subject: Re: [RFC,PATCH] arch/arm: compute and export NR_syscalls
From: Will Drewry <wad@chromium.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Mikael Pettersson <mikpe@it.uu.se>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Mike Frysinger <vapier@gentoo.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 4:21 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 16 August 2011 16:14:26 Will Drewry wrote:
>>
>> asm-exports.c is added instead of reusing asm-offsets.c to avoid a
>> variety of collisions (VM_EXEC, DMA_*, etc).  It is possible to use the
>> same calls.S mechanism but add NR_syscalls to asm-offsets.c.  However,
>> at inclusion time for generated/asm-offsets.h, conflicting defines will
>> need to be #undef'd if !__ASSEMBLY__ since it appears that the purpose
>> of asm-offsets.h is to safely bind C language definitions to assembly
>> and not the reverse.
>>
>> - Is this approach palatable?
>> - Should I resend only when paired with the other ftrace-needed patches?
>
> This seems overly complex, compared to a one-line change adding the symbol
> to asm/unistd.h. The only other architecture that uses an approach
> like the one you have posted is x86-64, and it's simpler there
> because it can easily be done in asm-offsets.c there without the need
> to create another helper.

Agreed!

I proposed this approach based solely on prior threads I've seen. E.g.,
- https://lkml.org/lkml/2007/6/1/427
  (don't just #define)
- https://lkml.org/lkml/2009/8/27/280
  (todo: x86-32 to move to x86-64)

If a single line #define is good enough, then it certainly works for me.

thanks!
will
