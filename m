Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049Ab2HCWsu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 18:48:50 -0400
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:33715 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753907Ab2HCWss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 18:48:48 -0400
MIME-Version: 1.0
In-Reply-To: <20120803223623.GB6156@kroah.com>
References: <1344013004-32211-1-git-send-email-vikram.pandita@ti.com>
 <m2628z6euk.fsf@firstfloor.org> <CAFm5wm3ScpUU5wa=ei3TY0zjU4kVbOgJMmE5_QDpwy7B-TJa+A@mail.gmail.com>
 <20120803200822.GC731@harshnoise.musicnaut.iki.fi> <CAFm5wm2sf9LnZNj9_BDYTF9G7XH32fOL3x5n=kZ-1ih0Cek2DQ@mail.gmail.com>
 <20120803215954.GA4489@kroah.com> <CAFm5wm1_-JP0xjDdBvAcqqpZPQvxJPsmNtUOFQyaNw=6H_JJcg@mail.gmail.com>
 <20120803221327.GA5102@kroah.com> <CAFm5wm3ayofPD7oF1=z_jwE_wuqBxBHicAs=KOhjcUr7Jo0wDQ@mail.gmail.com>
 <20120803223623.GB6156@kroah.com>
From: "Pandita, Vikram" <vikram.pandita@ti.com>
Date: Fri, 3 Aug 2012 15:48:26 -0700
Message-ID: <CAFm5wm1SSmbdi09hc1Qo1eHw5Tc0vbMf1hWuNw-cjZEEx3jX5w@mail.gmail.com>
Subject: Re: [PATCH v3] printk: add option to print cpu id
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, Andi Kleen <andi@firstfloor.org>,
        kay@vrfy.org, linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>,
        Vimarsh Zutshi <vimarsh.zutshi@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 3, 2012 at 3:36 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Fri, Aug 03, 2012 at 03:25:17PM -0700, Pandita, Vikram wrote:
>> >> This was something that got used internally and helped at times.
>> >
>> > Could you have used the trace point instead?
>>
>> As i understood the trace_prink(), one would need to modify existing
>> printk -> trace_printk. Is my understanding correct?
>
> No, you should just be able to watch the tracepoint, right?

yes.
Assumption being you know _EXACTLY_ what code piece to watch for.
Which may not be the case all times.

>
>> Most of the times the problem exhibits as a random hang, without having a clue
>> which code to modify. That time one generic defconfig global switch is
>> your first tool.
>>
>> Other issue i found, using this patch, that on multi-core ARM systems,
>> almost 99% of times, IRQ's are handled by CPU0,
>> even if CPU0 was really busy and other CPU's were free. I am yet to
>> understand a good reason why.
>
> Can't you see that from /proc/interrupts today?

You are right that was the next step i did and that shows the problem as well.
The point i was trying to make, with printk showing cpu-id, there are
problems in system that could get highlighted,
given printk almost always runs with linux kernel.

>
>> this patch also helped in other areas as mentioned in the thread
>> http://marc.info/?l=linux-omap&m=134401269106619&w=2
>
> I still don't understand how adding the cpu number to printk enabled you
> to find any problem like this.  Can't you just add the cpu number to the
> printk messages you care about for your specific hardware?
>

The assumption here is that a developer knows well enough, which code
to modify for logging.
I my experience, that is not true most of the times. A global
defconfig switch is much easier to enable.

Eg: when i have some timing related issue, first thing i go for is to
enable PRINTK_TIME, without even
having to think about the erring code. Then time-stamps lead to bad code.

That is the same though process behind the cpu-id in printk.


> greg k-h
