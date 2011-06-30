Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab1F3RHU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 13:07:20 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:50487 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab1F3RHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 13:07:15 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Christoph Hellwig <hch@infradead.org>, Randy Dunlap <rdunlap@xenotime.net>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com
Subject: Re: Build regressions/improvements in v3.0-rc5 (ssize_t ???)
References: <alpine.DEB.2.00.1106291011400.10665@ayla.of.borg>
	<20110629140630.5aefdda8.rdunlap@xenotime.net>
	<BANLkTin80p6gh0+Kga_92=wNEoAr9gFR2Q@mail.gmail.com>
	<20110630080119.GA20802@infradead.org>
	<BANLkTik81kgf=g+QngnaB7gNUF+xCQdSvw@mail.gmail.com>
X-Yow: Boy, am I glad it's only 1971...
Date: Thu, 30 Jun 2011 19:07:08 +0200
In-Reply-To: <BANLkTik81kgf=g+QngnaB7gNUF+xCQdSvw@mail.gmail.com> (Geert
	Uytterhoeven's message of "Thu, 30 Jun 2011 10:43:47 +0200")
Message-ID: <m2y60jmeo3.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> On Thu, Jun 30, 2011 at 10:01, Christoph Hellwig <hch@infradead.org> wrote:
>> On Thu, Jun 30, 2011 at 08:59:28AM +0200, Geert Uytterhoeven wrote:
>>> Nope. Also only happens on cris, which has in
>>> arch/cris/include/asm/posix_types.h:
>>>
>>> typedef long            __kernel_ssize_t;
>>>
>>> The "long" should be "int".
>>> But probably it should just include <asm-generic/posix_types.h> instead.
>>
>> Changing a user visible type won't be very nice for those using it in
>> C++ code.
>
> Are __kernel_* types exported to C++ userspace?

Currently, no exported kernel header is using __kernel_ssize_t, so it
may not be too late to change cris.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
