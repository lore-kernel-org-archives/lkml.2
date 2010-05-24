Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932640Ab0EXXar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:30:47 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:36385 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932395Ab0EXXao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:30:44 -0400
Subject: RE: [PATCH] x86: Export tsc related information in sysfs
From: john stultz <johnstul@us.ibm.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Brian Bloniarz <bmb@athenacr.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venki@google.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <b4a3fe9e-8646-4fb9-93e0-6953be7a0aa9@default>
References: <4BF58B59.7080901@athenacr.com>
	 <AANLkTinJ36UBMsVvTEoPnmAVS6np9Ja6heEtKA93r7tp@mail.gmail.com>
	 <ce764b91-11b0-44a5-9cf9-96977652bbd5@default>
	 <1274727116.2954.5.camel@localhost.localdomain>
	 <4BFADF9D.9050209@zytor.com>
	 <1274733566.2954.73.camel@localhost.localdomain>
	 <3ec7f284-1507-47fb-b5a2-eea29f68c627@default>
	 <4BFAFE17.8060105@zytor.com 1274741362.2954.80.camel@localhost.localdomain>
	 <b4a3fe9e-8646-4fb9-93e0-6953be7a0aa9@default>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 May 2010 16:30:36 -0700
Message-ID: <1274743836.2954.104.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-24 at 16:16 -0700, Dan Magenheimer wrote:
> > From: john stultz [mailto:johnstul@us.ibm.com]
> > Also, you don't really need extra accuracy, you just need it to be the
> > same from boot to boot. NTP keeps the correction factor persistent from
> > boot to boot via the drift file. The boot argument is just trying to
> > save the time (possibly hours depending on ntp config) after a reboot
> > for NTP to correct for the new error introduced by calibration.
> 
> I was assuming that extra accuracy would decrease the ntp
> convergence time by about the same factor (5-6 bits of extra
> accuracy would decrease ntp convergence time by 32-64x).
> Is that an incorrect assumption?

Sorry, this is sort of mixing points. I was saying you don't need more
accuracy (as opposed to what H. Peter mentioned below) when setting the
tsc_khz= option I proposed. Since it will be constant from boot to boot,
and thus will reduce the ntp convergence time.

However, without such a boot option, more accuracy from an increased
calibration time would help. However, the tradeoff of a longer boot time
is one not many will probably want.


> > From: H. Peter Anvin [mailto:hpa@zytor.com]
> > A longer sample would make sense if the goal is to freeze it into a
> > kernel command line variable, but the real question is how many people
> > would actually do that (and how many people would then suffer problems
> > because they upgraded their CPU/mobo and got massive failures on post-
> > boot.)
> 
> Not sure why upgraded mobo's would fail due to a longer sample?

Again, this is mixing the discussion. The concern was users of a
tsc_khz= boot option might have problems when they upgrade, as the
actual TSC freq might not match what was specified at boot.

> As more and more systems become dependent on clocksource==tsc
> and more and more people assume nanosecond-class measurements
> are relatively accurate, I'd expect the accuracy of tsc_khz
> to become more important.  While desktop users might bristle
> at an extra second of boot delay, I'll bet many server
> farm administrators would gladly pay that upfront cost
> if they know an option exists.

Maybe something like a tsc_long_calibration=1 option would allow for
this?  

However, I really do like the idea of pulling the stamped value from the
MSR and if its close to what we quickly calibrated, use that.

thanks
-john

