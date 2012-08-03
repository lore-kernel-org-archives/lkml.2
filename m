Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab2HCS0B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 14:26:01 -0400
Received: from na3sys009aog136.obsmtp.com ([74.125.149.85]:51787 "EHLO
	na3sys009aog136.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754085Ab2HCSZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 14:25:59 -0400
MIME-Version: 1.0
In-Reply-To: <m2628z6euk.fsf@firstfloor.org>
References: <1344013004-32211-1-git-send-email-vikram.pandita@ti.com> <m2628z6euk.fsf@firstfloor.org>
From: "Pandita, Vikram" <vikram.pandita@ti.com>
Date: Fri, 3 Aug 2012 11:25:37 -0700
Message-ID: <CAFm5wm3ScpUU5wa=ei3TY0zjU4kVbOgJMmE5_QDpwy7B-TJa+A@mail.gmail.com>
Subject: Re: [PATCH v3] printk: add option to print cpu id
To: Andi Kleen <andi@firstfloor.org>
Cc: gregkh@linuxfoundation.org, kay@vrfy.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>,
        Vimarsh Zutshi <vimarsh.zutshi@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 3, 2012 at 10:54 AM, Andi Kleen <andi@firstfloor.org> wrote:
> Vikram Pandita <vikram.pandita@ti.com> writes:
>
>> From: Vikram Pandita <vikram.pandita@ti.com>
>>
>> Introduce config option to enable CPU id reporting for printk() calls.
>
> What's wrong with using trace_printk for this?

trace_printk works only when you know the _exact_ path in code that
you want to profile.
When you have no idea of a random lockup, then it would be kind of
touch and time consuming
to put trace prints all around the code.

> That's much faster
> anyways. Generally printk is so slow that it's typically useless for
> instrumenting races.
>

As stated in another thread, its found useful to debug some specific cases:
Check thread: http://marc.info/?l=linux-omap&m=134401269106619&w=2

> And really: Wasting 1/3 of the 80 character line is too much.

You _WASTE_ 4 chars only if you are interested in this info by
enabling: CONFIG_PRINTK_CPUID
Just like you _WASTE_ 15 chars when you enable existing: CONFIG_PRINTK_TIME

For general usecase, recommendation would be to keep these options disabled.
Working on shipping products, i find almost all shipping with
CONFIG_PRINTK_TIME enabled, so there must be some value.
Same would hold for the use case being debugged for CPUID enabling.

>
> -Andi
>
> --
> ak@linux.intel.com -- Speaking for myself only
