Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab1BVQKI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 11:10:08 -0500
Received: from mail191.messagelabs.com ([216.82.242.19]:29924 "HELO
	mail191.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754079Ab1BVQKG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 11:10:06 -0500
X-VirusChecked: Checked
X-Env-Sender: fschaef9@visteon.com
X-Msg-Ref: server-14.tower-191.messagelabs.com!1298390983!59207837!3
X-StarScan-Version: 6.2.9; banners=-,-,-
X-Originating-IP: [213.71.174.167]
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Interrupt Latencies
Date: Tue, 22 Feb 2011 17:10:20 +0100
Message-ID: <060E4307CE6CA14BB4F7B4A25ECA052904BB6E98@VEUMBV03.vistcorp.ad.visteon.com>
In-Reply-To: <alpine.LFD.2.00.1102221527180.2701@localhost6.localdomain6>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Interrupt Latencies
Thread-Index: AcvSnleoCBo1wb0FQ5ug6+m3gNVMKQADIcRw
References: <060E4307CE6CA14BB4F7B4A25ECA052904B73AD1@VEUMBV03.vistcorp.ad.visteon.com> <alpine.LFD.2.00.1102221527180.2701@localhost6.localdomain6>
From: "Schaefer Dr, Frank-Rene ()" <fschaef9@visteon.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 22 Feb 2011 16:09:44.0279 (UTC) FILETIME=[EB382670:01CBD2AA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are using GPIO pins and map them to IRQ. 
The underlying driver seems to use message signaled
interrupts. 


-----Original Message-----
From: Thomas Gleixner [mailto:tglx@linutronix.de] 
Sent: Tuesday, February 22, 2011 3:39 PM
To: Schaefer Dr, Frank-Rene ()
Cc: linux-kernel@vger.kernel.org
Subject: Re: Interrupt Latencies

On Tue, 22 Feb 2011, Schaefer Dr, Frank-Rene () wrote:
> Having read "Moving interrupts to threads" at
> 
>            http://lwn.net/Articles/302043/
> 
> I expected to reduce interrupt latency during a SPI 
> communication by handling the transmit-receive in a 
> 'quick_check_handler' using 
> 
>            request_threaded_irq(...);

The quick check handler has the same latencies as the normal handler
of an interrupt requested by request_irq.
 
Interrupt latency depends on various factors:

  - Interrupt disabled code regions
  - Concurrent interrupts and the ordering of handling
  - Deep idle states
  - Bus contention
  - Cache misses

The maximum latency is the worst case of all the above added together.

> or vice versa. We are able to measure the latency precisely
> as the difference of the time when the interrupt pin 'IN'
> is raised and we raise our response pin 'OUT' as shown below.
> 
>       pin IN        .-------------------------
>       ______________|
>                     
>       pin OUT                     .-----------
>       ____________________________|
>                           
>                     |<- latency ->|
> 
> Could anyone point to locations in the kernel so that I can
> precisely understand the mechanisms that cause the latency? It 

There is no single mechanism.

> is totally incomprehensible to me why the 'quick_check_handler' 
> must have a latency of 60us at min. (that are many thousand 
> instructions).

How is that interrupt connected to the CPU/chipset? Which driver(s)
is/are involved ? How is the pin OUT accessed from the driver?

Thanks,

	tglx
