Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264Ab1CATvq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 14:51:46 -0500
Received: from ns.omicron.at ([212.183.10.25]:40242 "EHLO ns.omicron.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757207Ab1CATvp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 14:51:45 -0500
X-Greylist: delayed 3624 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Mar 2011 14:51:44 EST
From: Richard Cochran <richard.cochran@omicron.at>
To: "'torbenh'" <torbenh@gmx.de>, "'Thomas Gleixner'" <tglx@linutronix.de>
CC: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'John Stultz'" <john.stultz@linaro.org>,
        "'Ingo Molnar'" <mingo@elte.hu>,
        "'Peter Zijlstra'" <peterz@infradead.org>
Date: Tue, 1 Mar 2011 19:50:55 +0100
Subject: RE: [patch 00/28]  Rework of the PTP support series core code
Thread-Topic: [patch 00/28]  Rework of the PTP support series core code
Thread-Index: AcvYJrO3D4wtLmP4TFWfBwcQhNEI5QAGf3xA
Message-ID: <95DC1AA8EC908B48939B72CF375AA5E3011C94941E@alice.at.omicron.at>
References: <20110201134320.688829863@linutronix.de>
 <20110301153809.GA2934@siel.b>
In-Reply-To: <20110301153809.GA2934@siel.b>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Richard, can you please run that through your testing ? The PTP
>> drivers apply on top of that.
>
>i am a bit puzzled how a software ptp clock would fit into this
>framework. for some avb use-cases we could get away with a ptp clock
>thats only accurate to a few 100us.
>
>from a few quick glances it seems, that if userspace is able to create a
>ptp clock driven by normal timers and the kernel allows for timestamping
>packets using that clock, a modified ptpd could do the trick.
>
>i am not sure, how much of this should be happening in userspace though.

The point of the PHC patch set is to support special hardware clocks.
After much discussion (see the links in the V12 patch set) we have come
up with an API that will work both with software only (ie normal system
time) as well as with hardware clocks.

The application just uses: clockid_t id = CLOCK_REALTIME
if it wants to use software time stamping with the normal system clock.

I have some patches for the ptpd that show how the API works, and I
will be reposting those to the ptpd.sf.net in the next few days.

HTH,
Richard

