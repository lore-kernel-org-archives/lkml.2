Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307Ab0LLG0H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 01:26:07 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51496 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab0LLG0D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 01:26:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vjrsKSdAAd6ZCpOyJT+CgL8LYECk0E4lVRgDO1aDG/XU0zRyXT4vjNhf3eCIMB4bNx
         ZaAloRjnRwgt9SI+gEz1WuiKeX8H+xrDhoox0R+O1Mf/F0vTtiGVgN7ODwqPWy7m82RZ
         lm1FfLZbiKAWNbMARxKQOHGa8IlEqyY+PEKJY=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=bw8EcxEffbVV6CfdAPVdM25ZMxHqAmz1yukq3@mail.gmail.com>
References: <20101210135746.0cf6cbcd.sfr@canb.auug.org.au>
	<20101210092533.4f426650.randy.dunlap@oracle.com>
	<AANLkTi=bw8EcxEffbVV6CfdAPVdM25ZMxHqAmz1yukq3@mail.gmail.com>
Date: Sun, 12 Dec 2010 12:26:02 +0600
Message-ID: <AANLkTinRaGcEzGaRZSvGzRAubNtRUnHstru_0E0aCdrd@mail.gmail.com>
Subject: Re: linux-next: Tree for December 10 (x86 nmi_watchdog)
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 12, 2010 at 11:27 AM, Rakib Mullick <rakib.mullick@gmail.com> wrote:
> On Fri, Dec 10, 2010 at 11:25 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> On Fri, 10 Dec 2010 13:57:46 +1100 Stephen Rothwell wrote:
>>
>>> Hi all,
>>>
>>> Changes since 20101209:
>>
>>
>> arch/x86/kernel/apic/hw_nmi.c:28: error: redefinition of 'touch_nmi_watchdog'
>> include/linux/nmi.h:22: note: previous definition of 'touch_nmi_watchdog' was here
>>
> Hello Randy,
>
> Please checkout the following patch. Does it work?
> ----
>
> x86: Fix kernel build in hw_nmi.c when CONFIG_HARDLOCKUP_DETECTOR=n.
>
> This patch fixes kernel build introduced by commit
> 96a84c20d635fb1e98ab92f9fc517c4441f5c424. That commit supposed to
> define touch_nmi_watchdog when CONFIG_HARDLOCKUP_DETECTOR=y in
> hw_nmi.c. But mistakenly defines touch_nmi_watchdog when
> CONFIG_HARDLOCKUP_DETECTOR=n in hw_nmi.c.
>
> arch/x86/kernel/apic/hw_nmi.c:28: error: redefinition of ‘touch_nmi_watchdog’
> include/linux/nmi.h:23: error: previous definition of
> ‘touch_nmi_watchdog’ was here
>

NO. I don't think this is the correct one. Cause we don't want
touch_softlockup_watchdog() to be called if
CONFIG_HARDLOCKUP_DETECTOR=y.

> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> ---
>
> diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
> index c558e11..2056569 100644
> --- a/arch/x86/kernel/apic/hw_nmi.c
> +++ b/arch/x86/kernel/apic/hw_nmi.c
> @@ -24,7 +24,7 @@ u64 hw_nmi_get_sample_period(void)
>  }
>  #endif
>
> -#ifndef CONFIG_HARDLOCKUP_DETECTOR
> +#ifdef CONFIG_HARDLOCKUP_DETECTOR
>  void touch_nmi_watchdog(void)
>  {
>        touch_softlockup_watchdog();
>
