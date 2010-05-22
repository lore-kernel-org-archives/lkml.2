Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935733Ab0EVCDW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 22:03:22 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44412 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935688Ab0EVCDR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 22:03:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=AAhHFLr/r+QI01L5hxaUAqUdcAwbqyVLuGkSx7+KapYJG5wbCAGqJjnrEXKq3GQqbm
         AR5sdRZuxumXBUxYj+lv+ChT6GeWgJY77VSBI2uJkiWba/rpCgzG7FeHP2w2sE3Sy6I9
         5qGhEiX7qHslGYqeqUYrfDZy5DeikXWuEBKV4=
MIME-Version: 1.0
In-Reply-To: <4BF58B59.7080901@athenacr.com>
References: <4BF58B59.7080901@athenacr.com>
Date: Fri, 21 May 2010 19:03:16 -0700
X-Google-Sender-Auth: caBkHAehPvZlyLdFA2DYUCOxdfE
Message-ID: <AANLkTinJ36UBMsVvTEoPnmAVS6np9Ja6heEtKA93r7tp@mail.gmail.com>
Subject: Re: [PATCH] x86: Export tsc related information in sysfs
From: john stultz <johnstul@us.ibm.com>
To: Brian Bloniarz <bmb@athenacr.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venki@google.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20, 2010 at 12:19 PM, Brian Bloniarz <bmb@athenacr.com> wrote:
> Take NTP as an example. It does a pretty good job of observing the drift in
> gettimeofday() against a reference clock and correcting for it. This seems
> to work well even when GTOD uses the TSC. But, it assumes that the drift
> changes slowly.
>
> That goes out the window on reboot, because the kernel only spends 25ms on
> TSC<->PIT calibration and the value of tsc_khz can vary a lot from boot to
> boot. Then NTP starts up and reads a drift value from /var/lib/ntp/ntp.drift
> that it *thinks* is accurate. In our experience, it'll then spend up to 48
> hours doing god knows what to the clock until it converges on the real
> drift at the new tsc_khz.  initscripts could correct for the kernel's
> recalibration, but tsc_khz isn't exported.
>
> So it's too bad that it can't be exported somehow. The TSC on our
> machines has proven to be stable for all intents and purposes; I just
> checked 25 of my machines, most have uptime of >200 days, all of them
> still have current_clocksource=tsc. After NTP or PTPd has been running
> for a while, things converge, but being unable to reboot is a headache.
> Using the HPET for gettimeofday() would be impractical for performance
> reasons.

Yea, the relative instability of the tsc calibration at boot is an
issue for folks who want very very precise timekeeping immediately
after a reboot.

I proposed a solution to this awhile back via a boot option users
could use to specify the tsc_khz freq, so it would be consistent from
boot to boot. See: https://patchwork.kernel.org/patch/22492/

It didn't really go anywhere due to a lack of public interest.
However, if you're interested in playing with it, I can try to revive
the patch.

thanks
-john
