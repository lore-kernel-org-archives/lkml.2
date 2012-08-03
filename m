Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab2HCJgx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 05:36:53 -0400
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:56085 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751277Ab2HCJgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 05:36:52 -0400
MIME-Version: 1.0
In-Reply-To: <D958900912E20642BCBC71664EFECE3E6DDCAC49AE@BGMAIL02.nvidia.com>
References: <1343985378-22330-1-git-send-email-vikram.pandita@ti.com>
 <D958900912E20642BCBC71664EFECE3E6DDCAC49AB@BGMAIL02.nvidia.com> <D958900912E20642BCBC71664EFECE3E6DDCAC49AE@BGMAIL02.nvidia.com>
From: "Pandita, Vikram" <vikram.pandita@ti.com>
Date: Fri, 3 Aug 2012 02:36:30 -0700
Message-ID: <CAFm5wm2Z+FyVqG5oMWiEmZ8Je88hJ-cyDXmJw0wp4mqA-X9eYg@mail.gmail.com>
Subject: Re: [PATCH v2] printk: add option to print cpu id
To: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kay@vrfy.org" <kay@vrfy.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Vimarsh Zutshi <vimarsh.zutshi@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Venu

On Fri, Aug 3, 2012 at 2:32 AM, Venu Byravarasu <vbyravarasu@nvidia.com> wrote:
>
>> -----Original Message-----
>> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
>> owner@vger.kernel.org] On Behalf Of Venu Byravarasu
>> Sent: Friday, August 03, 2012 2:58 PM
>> To: Vikram Pandita; gregkh@linuxfoundation.org; kay@vrfy.org
>> Cc: linux-kernel@vger.kernel.org; Mike Turquette; Vimarsh Zutshi
>> Subject: RE: [PATCH v2] printk: add option to print cpu id
>>
>> > -----Original Message-----
>> > From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
>> > owner@vger.kernel.org] On Behalf Of Vikram Pandita
>> > Sent: Friday, August 03, 2012 2:46 PM
>> > To: gregkh@linuxfoundation.org; kay@vrfy.org
>> > Cc: linux-kernel@vger.kernel.org; Vikram Pandita; Mike Turquette; Vimarsh
>> > Zutshi
>> > Subject: [PATCH v2] printk: add option to print cpu id
>> >
>> > From: Vikram Pandita <vikram.pandita@ti.com>
>> >
>> > Introduce config option to enable CPU id reporting for printk() calls.
>> >
>> > Example logs with this option enabled look like:
>> >  [1] [    2.328613] usbcore: registered new interface driver libusual
>> >  [1] [    2.335418] usbcore: registered new interface driver usbtest
>> >  [1] [    2.342803] mousedev: PS/2 mouse device common for all mice
>> >  [0] [    2.352600] twl_rtc twl_rtc: Power up reset detected.
>> >  [0] [    2.359191] twl_rtc twl_rtc: Enabling TWL-RTC
>> >  [1] [    2.367797] twl_rtc twl_rtc: rtc core: registered twl_rtc as rtc0
>> >  [1] [    2.375274] i2c /dev entries driver
>> >  [1] [    2.382324] Driver for 1-wire Dallas network protocol.
>> >
>> > Its sometimes very useful to have printk also print the CPU Identifier
>> > that executed the call. This has helped to debug various SMP issues on
>> > shipping
>> > products.
>>
>
> As having Macro locally in the file of interest would serve the purpose,
> Why to change the printk code?

As stated, the logic followed is exactly similar to well proven and
approved way to handle printk time stamp: CONFIG_PRINTK_TIME
Its an overhead on the system that enables the config option:
CONFIG_PRINTK_CPUID
Otherwise the system remains as is.

To gain insight on SMP system logging behavior, the price to pay is
the extra 4 chars per printk line,
just like printk-time adds 15 chars to each line. Both options can be
disabled as desired.

So i am not sure what kind of option you are proposing?
Do u imply PRINTK_TIME is not right then?


>
>> Is it not better to have macros which will have wrapper to printk with
>> required
>> debug info added? E.g. cpu# in your case.
>> If by default we add cupid, is it not over head in each message getting
>> printed with printk?
>>
>> >
>> > Known limitation is if the system gets preempted between function call and
>> > actual printk, the reported cpu-id might not be accurate. But most of the
>> > times its seen to give a good feel of how the N cpu's in the system are
>> > getting loaded.
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
