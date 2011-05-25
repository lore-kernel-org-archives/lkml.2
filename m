Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591Ab1EYWIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 18:08:06 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53671 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070Ab1EYWIF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 18:08:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hnq+5v2fnkW0yc/NXeKrjcAWNM2EQbwXLDG3iCAg22hqkInPplDAxYvLCiS0wwK3so
         zSWsR/WREbJYYyj1APYF3KIKLE/SOgVXSpnXnS7LF9847Sj94FBNradZ11tBcxi+2R4L
         u3xFhRXvMbLUzm5fLhNLDO1Y2bAo55pTF/OwU=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1105252304050.3078@ionos>
References: <BANLkTikbJ3zX48SV0fFF8LDs=Uj8CmymgQ@mail.gmail.com>
	<BANLkTi=sA+gmggQayj9b8_O1E1rvQbEuPw@mail.gmail.com>
	<BANLkTikD_1mcZDeevSXLZaNg3CnuYU8pxA@mail.gmail.com>
	<BANLkTim5BeDNMyJkLGw3j=L9MLexsBqvhA@mail.gmail.com>
	<alpine.LFD.2.02.1105252235380.3078@ionos>
	<BANLkTimVTfbf2bRMA6-r+egAbVR-abQA1A@mail.gmail.com>
	<alpine.LFD.2.02.1105252304050.3078@ionos>
Date: Thu, 26 May 2011 01:08:04 +0300
Message-ID: <BANLkTim3rAD2Rcz4M03BM0gif1Lv7a5ALw@mail.gmail.com>
Subject: Re: CPU used at 100% in 2.6.39-git10
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 12:08 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 25 May 2011, Linus Torvalds wrote:
>
>> On Wed, May 25, 2011 at 1:37 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> >
>> > /me blushes
>> >
>> > Does the patch below fix it ?
>>
>> Yup, that seems to fix it for me. Commit log and sign-off?
>>
>>                         Linus
>
> ---->
> hrtimers: Fix moronic typo
>
> commit 9ec2690758a5 ("timerfd: Manage cancelable timers in timerfd")
> introduced a CONFIG_HIGHRES_TIMERS (should be CONFIG_HIGH_RES_TIMERS)
> typo, which caused applications depending on CLOCK_REALTIME timers to
> become sluggy due to the fact that the time base of the realtime
> timers was not updated when the wall clock time was set.
>
> Reported-by: Anca Emanuel <anca.emanuel@gmail.com>
> Fatfingered-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index c541ee5..a9205e3 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -748,7 +748,7 @@ static inline void retrigger_next_event(void *arg) { }
>  */
>  void clock_was_set(void)
>  {
> -#ifdef CONFIG_HIGHRES_TIMERS
> +#ifdef CONFIG_HIGH_RES_TIMERS
>        /* Retrigger the CPU local events everywhere */
>        on_each_cpu(retrigger_next_event, NULL, 1);
>  #endif
>

Tested-by: Anca Emanuel <anca.emanuel@gmail.com>

Linus, Thomas, this solves the problem, thanks very much for your help.
