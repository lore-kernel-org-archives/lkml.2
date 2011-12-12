Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab1LLOFo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 09:05:44 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44037 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557Ab1LLOFn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 09:05:43 -0500
MIME-Version: 1.0
In-Reply-To: <CABiHV1ShpvmA0r0wJtepnWyQ2ZT3hXtYFdKMUaZ=axTgC7uR0Q@mail.gmail.com>
References: <CANFwon04fJe9z+5wKXp55Kp-SX+FZyAhnNcAH9zi6zBd++GSFg@mail.gmail.com>
 <CABiHV1ShpvmA0r0wJtepnWyQ2ZT3hXtYFdKMUaZ=axTgC7uR0Q@mail.gmail.com>
From: Hui Zhu <teawater@gmail.com>
Date: Mon, 12 Dec 2011 22:05:00 +0800
Message-ID: <CANFwon0eEfaRn_Tbw_+sGeTk+HXVhBMLX0wt7bZ2=az2RFzydA@mail.gmail.com>
Subject: Re: KGTP (Linux Kernel debugger and tracer) 20111111 release (Android
 support OK)
To: Geunsik Lim <leemgs1@gmail.com>
Cc: linux-kernel@vger.kernel.org, "gdb@sourceware.org" <gdb@sourceware.org>,
        kgtp <kgtp@freelists.org>, Marc Khouzam <marc.khouzam@ericsson.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>,
        Steven <mqyoung@gmail.com>, colyli@gmail.com,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geunsik,

Thanks for your patch.
But  Kernel upstream:
struct perf_event *
perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
				 struct task_struct *task,
				 perf_overflow_handler_t overflow_handler,
				 void *context)

I am sorry that gtp.patch is just for the Kernel upstream (Actually,
it just for review).

I suggest you use LKM if it is OK for you.

If you want include KGTP into your kernel tree or something, maybe I
can supply a special patch for you.

BTW looks I need release an gtp_auto.patch that can patch to most of
Linux kernel.

Thanks,
Hui

On Mon, Dec 12, 2011 at 19:13, Geunsik Lim <leemgs1@gmail.com> wrote:
> On Mon, Nov 14, 2011 at 2:15 PM, Hui Zhu <teawater@gmail.com> wrote:
>> KGTP is a realtime and lightweight Linux Kernel GDB debugger and tracer.
>>
>> It makes Linux Kernel supply a GDB remote debug interface. Then GDB in
>> current machine or remote machine can debug and trace Linux through
>> GDB tracepoint without stopping the Linux Kernel.
>> And even if the board doesn't have GDB on it and doesn't have
>> interface for remote debug. It can debug the Linux Kernel using
>> offline debug.
>> Now, it supports X86-32, X86-64, MIPS and ARM.
>>
>> Now, KGTP 20111111 release.
>>
>> The change of this release is:
>> Add a doc for use KGTP with Android in
>> https://code.google.com/p/kgtp/wiki/HowToUseKGTPinAndroid
>> post_handler will make kprobes-optimization cannot be used. So make
>> gtp_kp_post_handler be call only when tpe->step is true.
>> Make rdtsc_current to x86 special.
>> Register easy Kprobe handler to speed up it when no tracepoint access
>> $cooked_clock, $cooked_rdtsc or "pc_pe" tvariable.
>> Fix a bug of ARM build.
>> To get other change info please goto https://code.google.com/p/kgtp/wiki/UPDATE
>>
>> According to the comments of Christoph.  I make a patch for Linux
>> Kernel and make it looks OK with checkpatch.pl.  The file gtp.patch is
>> include in the source of KGTP code.
> Dear Hui Zhu,
>
> Recently, I synchronized KGTP kernel source with svn 838 to test
> built-in kernel
> after adjusting recent bug-fix. I still had a compilation error.
> Please, adjust the below patch content to support  X86/ARM
> architecture normally.
>
> ==========
> From 39d58cc7dab8df5e57fa106e8e7f00e562b45212 Mon Sep 17 00:00:00 2001
> From: Geunsik Lim <geunsik.lim@samsung.com>
> Date: Mon, 10 Dec 2011 18:08:03 +0900
> Subject: [PATCH] Modify perf related func interface.
>
> Signed-off-by: Geunsik Lim <geunsik.lim@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  lib/gtp.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/lib/gtp.c b/lib/gtp.c
> index 9bdf82c..9a2670e 100644
> --- a/lib/gtp.c
> +++ b/lib/gtp.c
> @@ -4480,7 +4480,7 @@ restart:
>                tve->pts->event =
>                        perf_event_create_kernel_counter(&(tve->pts->attr),
>                                                         tve->pts->cpu,
> -                                                        NULL, NULL, NULL);
> +                                                        NULL, NULL);
>                if (IS_ERR(tve->pts->event)) {
>                        int     ret = PTR_ERR(tve->pts->event);
>
> --
> 1.7.3.4
> ==========
>
> Thank you for your contribution for embedded kernel debugging
>
>>
>> Thanks,
>> Hui
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>
> --
> Best regards,
> Geunsik Lim ( Samsung Electronics )
> Blog : http://blog.naver.com/invain/
> Homepage: http://leemgs.fedorapeople.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
