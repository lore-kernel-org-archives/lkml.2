Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab2CTUC6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 16:02:58 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61139 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755917Ab2CTUC5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 16:02:57 -0400
MIME-Version: 1.0
In-Reply-To: <4F63EBC9.6010208@us.ibm.com>
References: <CAJPugqsJgN9ZL3jQAZ+eGKfzxH0PAZonj-36H6PB1cHSpQHqSw@mail.gmail.com>
 <1322855029.21423.170.camel@work-vm> <CAJPugqs6wDcEM-5p5vRxHNVZd92ozgk0sw7g3=F6pvYyCA-CEw@mail.gmail.com>
 <1322864926.21423.184.camel@work-vm> <CAJPugqur-7=s2ujsy+XhAZ3TucD_R_Wcdat2NA9TdFNrhSA2ww@mail.gmail.com>
 <4F63EBC9.6010208@us.ibm.com>
From: Jose Luis Salas <josacar@gmail.com>
Date: Tue, 20 Mar 2012 21:02:36 +0100
Message-ID: <CAJPugqssDxkCpHzHZmKfMpyMnajH405QxsE6WhNY+JvMVcNnhA@mail.gmail.com>
Subject: Re: System freezes with high network activity
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello John,

I'll wait for 3.3 Debian kernel package to test it and send you the
results. Yes, my system is working properly with the nohz option in 39
days.

I'll try the patch asap.

Thanks for your great work.

On Sat, Mar 17, 2012 at 2:41 AM, John Stultz <johnstul@us.ibm.com> wrote:
>
> On 12/03/2011 02:04 PM, Jose Luis Salas wrote:
>>
>> Hi,
>>
>> attached is the output of the timer_list.
>>
>> With the nohz option the system is stable too.
>>
>> Other symptom of the problem is network drops performance to 50% ( 50
>> Mbps ).
>>
>
> Hey Jose,
>    Just following up on this old email. Looking at the timer_list.txt that
> you sent, I'm not seeing anything that sticks out as problematic. Are you
> still seeing issues with recent kernels (3.1, 3.2) ?    Is nohz still
> working for you?
>
> I suspect the problem is that the lapic on your machine goes out to lunch
> after longish idle times w/ nohz.  That's why the key-press or network
> traffic wakes the system back up.
>
> Does booting with the following patch (without nohz or any clocksource=
> boot args) fix the issue?
>
> If it does, can you increase the time returned in the patch from 20ms by
> powers of ten until it gets to 2 seconds or you see the problem? If the
> patch below doesn't help, can you drop the value down to 1ms and let me know
> if that affects anything?
>
> thanks
> -john
>
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 95bebaa..8fd2bfa 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -546,6 +546,9 @@ u64 timekeeping_max_deferment(void)
>  {
>        unsigned long seq;
>        u64 ret;
> +
> +       return 20000000ULL; /* 20ms */
> +
>        do {
>                seq = read_seqbegin(&timekeeper.lock);
>
>
