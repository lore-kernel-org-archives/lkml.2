Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab1KAO57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 10:57:59 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57446 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab1KAO55 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 10:57:57 -0400
MIME-Version: 1.0
In-Reply-To: <20111101121851.7d393277@bob.linux.org.uk>
References: <1319255194-4799-1-git-send-email-paul.s.schilling@gmail.com>
	<20111101121851.7d393277@bob.linux.org.uk>
Date: Tue, 1 Nov 2011 09:57:56 -0500
Message-ID: <CAC=G6swE7WCqTFkJkOm_GXpVncjXrc+-jvaKHiwc9KTb6Re8hQ@mail.gmail.com>
Subject: Re: [PATCH 02/14] ARM : SAMSUNG : Add RS485 support.
From: Paul Schilling <paul.s.schilling@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Boojin Kim <boojin.kim@samsung.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am working on resubmitting this stuff right now.  I have 14 patches
that should be
broken into more like 20 patches.  Most of them are ARM S3C and
specifically S3C2416 patches.
I am working on a patch right now to fix a Atomic wait in the DMA
code.  That causes
20 milliseconds of no interrupts whenever a sound is played on the samsung S3C
platform.

The code below wasn't supposed to go out and I have patch that removes
that chunk
of code almost ready that just needs testing before I send it.

On Tue, Nov 1, 2011 at 7:18 AM, Alan Cox <alan@linux.intel.com> wrote:
>> +config SAMSUNG_HAS_RS485
>> +     bool "Enable RS485 support for Samsung"
>> +     depends on SERIAL_SAMSUNG && (MACH_CONDOR2440 ||
>> MACH_CONDOR2416 || MACH_MINI2440)
>> +     default y if (MACH_CONDOR2440 || MACH_CONDOR2416)
>> +     default n if (MACH_MINI2440)
>
> There really needs to be more ARM thinking about doing this sort of
> stuff at runtime. If you can detect the board type at runtime then you
> need to be moving towards kicking board specifics out of the depends,
> and treating it as an "include support for this, if the board has it"
> so you can move towards less build time only configuration.
>

The chunk of code that says FIXME is an optimization that could be
implemented to
decrease interrupts by using DMA until the last byte is ready to be
sent.  I have a new
patch that explains in a comment what the code is for.

>> +/* FIXME */
>> +     #if 0
>> +     if (last_state != en) {
>> +
>
> So this doesn't look ready to submit either...
>

I have a patch that I haven't sent yet that fixes the code formating
issues.  I need to compile and test it before I send it out.

>
>> +             if ((utrstat & S3C2410_UTRSTAT_TXE) ? 1 : 0) {
>> +                     if (cfg->gpio_transmit_en > -1) {
>> +
>> gpio_set_value(cfg->gpio_transmit_en, 0);
>> +                     }
>
> Lots of excess brackets (see CodingStyle) - removing a few of the
> excess ones would make it easier to read later.
>
> The later bits become a real mess of ifdefs - much not your fault, the
> combination of your ifdefs and existing lack of design push it beyond
> ugly and really want addressing.
>
>
