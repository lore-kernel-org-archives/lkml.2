Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930Ab0FFOZq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 10:25:46 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63142 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757858Ab0FFOZp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 10:25:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TFDoV+smT/8c2jLxTRxir/+GMHRxnvn7woEM6wd3T1SlWFDb6dB1avnFQfZVKShmY2
         tm8oQf0rYfk2xK6GMvWVDMcfMmljKO/4Yx4/QoqqJaoiY6vpeqx3fiKfQ4xI9sqdr09a
         Qb0/Jeasnk4jMdoOVraFvOXNEEqalweROcEWk=
MIME-Version: 1.0
In-Reply-To: <201006061000.19503.maciej.rutecki@gmail.com>
References: <AANLkTiliRFydAhxH2-Dp1RKuz6sq7vgWIcMvLMi68ftg@mail.gmail.com>
	<201006061000.19503.maciej.rutecki@gmail.com>
Date: Sun, 6 Jun 2010 09:25:43 -0500
Message-ID: <AANLkTimegTM5Mslu4JJn18lc5cGkoN7z67m8WOtulbW5@mail.gmail.com>
Subject: Re: wait_even_interruptible_timeout(), signal, spin_lock() = system 
	hang
From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
To: maciej.rutecki@gmail.com
Cc: linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 6, 2010 at 3:00 AM, Maciej Rutecki <maciej.rutecki@gmail.com> wrote:
> I created a Bugzilla entry at
> https://bugzilla.kernel.org/show_bug.cgi?id=16139
> for your bug report, please add your address to the CC list in there, thanks!
>
> On piątek, 28 maja 2010 o 18:44:46 Shirish Pargaonkar wrote:
>> After this sequence of calls, system hangs (smp, x86 box based with
>> .34 kernel), can ping only.
>> I have not been able to break in with Alt Sysrq t, working on that
>>
>>         rc = wait_event_interruptible_timeout(ses->server->response_q,
>>                         (midQ->midState != MID_REQUEST_SUBMITTED),
>>  timeout); if (rc < 0) {
>>                 cFYI(1, ("command 0x%x interrupted", midQ->command));
>>                 return -1;
>>         }
>>
>> and when function that invoking function after coming out with ERESTARTSYS
>> (I kill the command with Ctrl C) calls
>>  spin_lock(&GlobalMid_Lock);
>>
>> system hangs.  If I sleep before return -1 (e.g. msleep(1), no hang)
>>
>> I do not have to use wait_event_interruptible_timeout and no such problems
>>  with wait_event_timeout, it is only when signal/interrupt is involved, I
>>  run into this problem
>>
>> Any pointers/ideas what could be happening, would be really really
>>  appreciated.
>>
>> Regards,
>>
>> Shirish
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
> --
> Maciej Rutecki
> http://www.maciek.unixy.pl
>

Thanks. Shaggy told me what I think is happening should not be for
following reasons.

"The process doesn't receive the signal in the
kernel unless it specifically checks for it, or it exits a system call.
There shouldn't be a spinlock held in either situation.
"

I will update the bug as well.

Regards,

Shirish
