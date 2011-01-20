Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab1ATVY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 16:24:58 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49958 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839Ab1ATVY5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 16:24:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=inBa7BpBIEoqG5AnzZGbacfS8aMQZEEFbM8j6t/uvyccwwF04soJodjvxOkZsOTc9e
         7DGSmHrt8sDVpd044pEijFeEFnZEmEEUxCJYZFABn6d115kamtDTRBl0b4CobH9kJmVF
         XWqQYh/dIHC8CDijBwPTUYhm5WuHP/U5KtEaI=
MIME-Version: 1.0
In-Reply-To: <1295558196.2998.85.camel@work-vm>
References: <4D38A051.2010301@caviumnetworks.com>
	<1295558196.2998.85.camel@work-vm>
Date: Thu, 20 Jan 2011 22:24:56 +0100
X-Google-Sender-Auth: UlHl5AFdTIlu7zhVuRqJ6i7AeKA
Message-ID: <AANLkTinJfQCEcqHy8oc8+F+yrmY_AkhPLCdZ7R95tk6H@mail.gmail.com>
Subject: Re: RTC seems broken on 2.6.38-rc1 for RTCs lacking alarms.
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: John Stultz <john.stultz@linaro.org>
Cc: David Daney <ddaney@caviumnetworks.com>,
        Andreas Schwab <schwab@linux-m68k.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 22:16, John Stultz <john.stultz@linaro.org> wrote:
> On Thu, 2011-01-20 at 12:51 -0800, David Daney wrote:
>> open("/dev/rtc0", O_RDONLY|O_LARGEFILE) = 3
>> ioctl(3, PRESTO_GETMOUNT or RTC_UIE_ON, 0) = 0
>> _newselect(4, [3], NULL, NULL, {5, 0})  = 0 (Timeout)
>> write(2, "select() to /dev/rtc0 to wait for"..., 55select() to /dev/rtc0
>> to wait for clock tick timed out
>> ) = 55
>> ioctl(3, PRESTO_SETPID or RTC_UIE_OFF, 0) = 0
>> close(3)                                = 0
>> exit_group(1)                           = ?
>>
>>
>> The hwclock program is asking to put the clock in UIE mode and then
>> does a select() on it.  Since the alarm doesn't work, the select times out.
>>
>> Previously the ioctl(RTC_UIE_ON) would return EINVAL:
>
> Ah. Good diagnosis! Let me try to get a patch for you and Andreas to
> test.

I'm also seeing this on m68k (ARAnyM, rtc-generic).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
