Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665Ab0L2KUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 05:20:54 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:53299 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab0L2KUw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 05:20:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XSMC4eQVtWoDQ+jZnkFwCgUISOXjflenhFvDWSvtgWh2x/vgmbGArZ4aDW0of3vHx6
         w9FyP+l70mmyUVFKoFPsElXFKk097a1dG2oCwR9Q3+QxAlzIJg95qNyFCJaUFdmYQBjD
         yEXSacI58ywVUnA8ZhTd8tXZIXNLk04gAeOIM=
MIME-Version: 1.0
In-Reply-To: <AANLkTim6QkyMMtcQT1mfBMUDwirYg636xhBv4p77Uf4k@mail.gmail.com>
References: <AANLkTim4zbBvTyc4hNurCmPN7GisXe1mmzR6P4aj3xzA@mail.gmail.com>
	<AANLkTim6QkyMMtcQT1mfBMUDwirYg636xhBv4p77Uf4k@mail.gmail.com>
Date: Wed, 29 Dec 2010 15:50:51 +0530
Message-ID: <AANLkTinq4MTrLek8DE5SAR=-eFk==4VX-+ui0kVtrV_L@mail.gmail.com>
Subject: Re: Drift when measuring time using add_timer
From: Mohan V <mohanvforum@gmail.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 29, 2010 at 2:15 PM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> On Tue, Dec 28, 2010 at 8:05 PM, Mohan V <mohanvforum@gmail.com> wrote:
>> Hello All,
>>
>> I am testing the timers on a OMAP4 based board. I am seeing a drift or
>> the time difference between the timer value and when the function callback
>> happens. This drift is around 1000ms or 1s for a expiry value of >=5mins.
>> Is the time drift expected? Is this way of measuring right or is there
>> any other way?
>>
>> OMAP4 as you may know is a multi-core processor and CONFIG_SMP is enabled
>> along with the following:
>> CONFIG_NO_HZ, CONFIG_HIGH_RES_TIMERS
>>
>> My kernel configurations:
>> kernel: 2.6.37-rc7 (commit id: ffc96d)
>> config: omap2plus_defconfig
>>
>> My driver does the following:
>>
>> struct timeval tv;
>> test_timer_proc_write()
>> {
>>           del_timer_sync(&my_timer);
>>           period = 300000; /* 5min */
>>           my_timer.expires = jiffies + msecs_to_jiffies(period);
>>           my_timer.function = func_timeout; /* Call back function*/
>
> what's the slack of your timer?
> And what about setting my_timer.slack = 0; ?
>
I hadn't set the slack value for the timer. Setting it to "0", gives me
much better results. Thanks a lot Yong.

Regards,
Mohan

> Thanks,
> Yong
>
>>           /* Save the current time in global variable */
>>           do_gettimeofday(&timeval);
>>           /* add timer with an expiry value of 5mins*/
>>           add_timer(&my_timer);
>> }
>>
>> /* Get the current time and print the difference between the two values */
>> func_timeout()
>> {
>>           struct timeval tv1;
>>           do_gettimeofday(&tv);
>>           /* take the difference between current time and saved time */
>>           ms = (tv.tv_sec - tv1.tv_sec) * 1000 + \
>>                   (tv.tv_usec - tv1.tv_usec) / 1000;
>>           printk("Interval = %d\n", ms);
>> }
>>
>> Thanks for your time.
>>
>> Regards,
>> Mohan
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
>
>
> --
> Only stand for myself.
>
