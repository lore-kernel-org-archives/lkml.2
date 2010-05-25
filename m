Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283Ab0EYBeI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 21:34:08 -0400
Received: from sprinkles.athenacr.com ([64.95.46.210]:13491 "EHLO
	sprinkles.inp.in.athenacr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754449Ab0EYBeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 21:34:07 -0400
Message-ID: <4BFB2902.50308@athenacr.com>
Date: Mon, 24 May 2010 21:33:54 -0400
From: Brian Bloniarz <bmb@athenacr.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venki@google.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Export tsc related information in sysfs
References: <4BF58B59.7080901@athenacr.com> <AANLkTinJ36UBMsVvTEoPnmAVS6np9Ja6heEtKA93r7tp@mail.gmail.com> <ce764b91-11b0-44a5-9cf9-96977652bbd5@default> <1274727116.2954.5.camel@localhost.localdomain> <4BFADF9D.9050209@zytor.com 1274733566.2954.73.camel@localhost.localdomain> <3ec7f284-1507-47fb-b5a2-eea29f68c627@default> <4BFAFE17.8060105@zytor.com>
In-Reply-To: <4BFAFE17.8060105@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I still sorta think the clearest thing is to keep the kernel's
quick, dynamic calibration at boot, and expose the tsc_khz it
decides on. People who don't care about clocksync get their
quick boot, NTP knows enough to correct its drift estimate
when it starts, and users don't need to learn all these
details to get stable clocksync (*).

If we're being strict, something like NTP needs to know exactly
what's driving gettimeofday(). If the clocksource changes, it
needs to know that so it could correct or trash its drift
estimate. If there's one-time calibration, it needs to know
what the result was. If there's continuous calibration, it
either needs to be notified, or have the ability to disable
it. Right? So I think exporting tsc_khz in some form is a
step in the right direction.

So what's wrong with just adding a
/sys/devices/system/clocksource/clocksource0/tsc_khz?
Maybe Thomas Gleixner's suggestion of a vget_tsc_raw()
would also suffice, I'm not sure I understand the details
enough.

Any of the other fixes people have discussed (tsc_khz=
bootopt, tsc_long_calibration=1) would be enough to make
me happy though :)

(*) Though they still need to learn enough to coax the
kernel into giving them a fast gettimeofday(). That's a
price you gotta pay if you care enough :)

