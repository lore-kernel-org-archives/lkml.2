Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab0EXXS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:18:27 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:50808 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758557Ab0EXXS0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:18:26 -0400
MIME-Version: 1.0
Message-ID: <b4a3fe9e-8646-4fb9-93e0-6953be7a0aa9@default>
Date: Mon, 24 May 2010 16:16:26 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: john stultz <johnstul@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Brian Bloniarz <bmb@athenacr.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venki@google.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
Subject: RE: [PATCH] x86: Export tsc related information in sysfs
References: <4BF58B59.7080901@athenacr.com>
 <AANLkTinJ36UBMsVvTEoPnmAVS6np9Ja6heEtKA93r7tp@mail.gmail.com>
 <ce764b91-11b0-44a5-9cf9-96977652bbd5@default>
 <1274727116.2954.5.camel@localhost.localdomain> <4BFADF9D.9050209@zytor.com>
 <1274733566.2954.73.camel@localhost.localdomain>
 <3ec7f284-1507-47fb-b5a2-eea29f68c627@default> <4BFAFE17.8060105@zytor.com
 1274741362.2954.80.camel@localhost.localdomain>
In-Reply-To: <1274741362.2954.80.camel@localhost.localdomain>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.5.2  (401224) [OL
 12.0.6514.5000]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090201.4BFB092E.000B:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: john stultz [mailto:johnstul@us.ibm.com]
> Also, you don't really need extra accuracy, you just need it to be the
> same from boot to boot. NTP keeps the correction factor persistent from
> boot to boot via the drift file. The boot argument is just trying to
> save the time (possibly hours depending on ntp config) after a reboot
> for NTP to correct for the new error introduced by calibration.

I was assuming that extra accuracy would decrease the ntp
convergence time by about the same factor (5-6 bits of extra
accuracy would decrease ntp convergence time by 32-64x).
Is that an incorrect assumption?

> From: H. Peter Anvin [mailto:hpa@zytor.com]
> A longer sample would make sense if the goal is to freeze it into a
> kernel command line variable, but the real question is how many people
> would actually do that (and how many people would then suffer problems
> because they upgraded their CPU/mobo and got massive failures on post-
> boot.)

Not sure why upgraded mobo's would fail due to a longer sample?

As more and more systems become dependent on clocksource==tsc
and more and more people assume nanosecond-class measurements
are relatively accurate, I'd expect the accuracy of tsc_khz
to become more important.  While desktop users might bristle
at an extra second of boot delay, I'll bet many server
farm administrators would gladly pay that upfront cost
if they know an option exists.
