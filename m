Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757169Ab0EXWG0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 18:06:26 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:24818 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973Ab0EXWGZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 18:06:25 -0400
MIME-Version: 1.0
Message-ID: <3ec7f284-1507-47fb-b5a2-eea29f68c627@default>
Date: Mon, 24 May 2010 15:04:11 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: john stultz <johnstul@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Brian Bloniarz <bmb@athenacr.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venki@google.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
Subject: RE: [PATCH] x86: Export tsc related information in sysfs
References: <4BF58B59.7080901@athenacr.com>
 <AANLkTinJ36UBMsVvTEoPnmAVS6np9Ja6heEtKA93r7tp@mail.gmail.com>
 <ce764b91-11b0-44a5-9cf9-96977652bbd5@default>
 <1274727116.2954.5.camel@localhost.localdomain> <4BFADF9D.9050209@zytor.com
 1274733566.2954.73.camel@localhost.localdomain>
In-Reply-To: <1274733566.2954.73.camel@localhost.localdomain>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.5.2  (401224) [OL
 12.0.6514.5000]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090201.4BFAF844.00EF:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Is that still the case?  I thought newer versions of NTP could deal
> with
> > large values.  Inaccuracies of way more than 500 ppm are everyday.
> 
> That's scary.
> 
> Yea, in the kernel the ntp freq correction tops out at 500ppm. Almost
> all the systems I see tend to fall in the +/- 200ppm range (if there's
> not something terribly wrong with the hardware).
> 
> So maybe things aren't so bad out there? Or is that wishful thinking?

Since Brian's concern is at boot-time at which point there is no
network or ntp, and assuming that it would be unwise to vary tsc_khz
dynamically on a clocksource==tsc machine (is it?), would optionally
lengthening the TSC<->PIT calibration beyond 25ms result in a more
consistent tsc_khz between boots?  Or is the relative instability
an unavoidable result of skew between the PIT and the fixed constant
PIT_TICK_RATE combined with algorithmic/arithmetic error?  Or is
the jitter of the (spread-spectrum) TSC too extreme?  Or ???

If better more consistent calibration is possible, offering
that as an optional kernel parameter seems better than specifying
a fixed tsc_khz (stamped or user-specified) which may or may
not be ignored due to "too different from measured tsc_khz".
Even an (*optional*) extra second or two of boot time might
be perfectly OK if it resulted in an additional five or six
bits of tsc_khz precision.

Thoughts, Brian?
