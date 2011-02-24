Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab1BXICL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 03:02:11 -0500
Received: from mail143.messagelabs.com ([216.82.254.35]:54574 "HELO
	mail143.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754504Ab1BXICJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 03:02:09 -0500
X-VirusChecked: Checked
X-Env-Sender: fschaef9@visteon.com
X-Msg-Ref: server-7.tower-143.messagelabs.com!1298534493!78157046!5
X-StarScan-Version: 6.2.9; banners=-,-,-
X-Originating-IP: [213.71.174.167]
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: Interrupt Latencies
Date: Thu, 24 Feb 2011 09:01:38 +0100
Message-ID: <060E4307CE6CA14BB4F7B4A25ECA052904BB7841@VEUMBV03.vistcorp.ad.visteon.com>
In-Reply-To: <4D63AD35.6050808@ladisch.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Interrupt Latencies
Thread-Index: AcvSjJoWWC11ZKQ8Qfei8PHhvmrPNABbE8KA
References: <060E4307CE6CA14BB4F7B4A25ECA052904B73AD1@VEUMBV03.vistcorp.ad.visteon.com> <4D63AD35.6050808@ladisch.de>
From: "Schaefer Dr, Frank-Rene ()" <fschaef9@visteon.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 24 Feb 2011 08:01:37.0693 (UTC) FILETIME=[0FE144D0:01CBD3F9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In response to Thomas Gleixner:

> Interrupt latency depends on various factors:
> 
>   - Interrupt disabled code regions
Could you tell us how this could be detected or measured?
Is there a central place, where we could toggle a pin to 
see when interrupts are enabled/disabled? 

>   - Concurrent interrupts and the ordering of handling
We are only considering the best times that we measure.
The only other interrupts are SATA and system timer, I guess.

>   - Deep idle states
You mean 'suspend' or some type of CPU sleep. Could you elaborate?
We do not suspend. This should also only be the case for the 
first chunk that is transmitted. But the latencies remain
over longer time spans.

>   - Bus contention
Nothing else is running. 

>   - Cache misses
We cannot make any statements about that. But, we are **not** 
working on huge data or code regions.

> >
> >       pin IN        .-------------------------
> >       ______________|
> >
> >       pin OUT                     .-----------
> >       ____________________________|
> >
> >                     |<- latency ->|
> >

> How is that interrupt connected to the CPU/chipset? 
The port is part of the chipset connected internally 
via PCI.

> Which driver(s) is/are involved ? 
http://lxr.free-electrons.com/source/drivers/gpio/pl061.c

> How is the pin OUT accessed from the driver?
gpio_set_value(Pin, Value);

we measured the delay and could find that it was in the range
of some nano seconds.

Best Regards

Frank Schäfer and Joachim Becker.

