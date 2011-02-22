Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab1BVJfG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 04:35:06 -0500
Received: from mail202.messagelabs.com ([216.82.254.227]:2381 "HELO
	mail202.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753249Ab1BVJfE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 04:35:04 -0500
X-VirusChecked: Checked
X-Env-Sender: fschaef9@visteon.com
X-Msg-Ref: server-14.tower-202.messagelabs.com!1298367301!70147941!2
X-StarScan-Version: 6.2.9; banners=-,-,-
X-Originating-IP: [213.71.174.167]
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Interrupt Latencies
Date: Tue, 22 Feb 2011 10:35:02 +0100
Message-ID: <060E4307CE6CA14BB4F7B4A25ECA052904B73AD1@VEUMBV03.vistcorp.ad.visteon.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Interrupt Latencies
Thread-Index: AcvSc8f7yx4mxr8+Qz2JjlHNJrX3MQ==
From: "Schaefer Dr, Frank-Rene ()" <fschaef9@visteon.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 22 Feb 2011 09:35:01.0256 (UTC) FILETIME=[C709A080:01CBD273]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello. 

Having read "Moving interrupts to threads" at

           http://lwn.net/Articles/302043/

I expected to reduce interrupt latency during a SPI 
communication by handling the transmit-receive in a 
'quick_check_handler' using 

           request_threaded_irq(...);


However, the difference in latency to "request_irq(...)" 
is not measurable. It is still in the range from 60 to 110us
on a 1.6 GHz Atom CPU. From "linux/interrupt.h" I conclude 
that depending on 

           CONFIG_GENERIC_HARDIQS

either 'request_irq' is mapped to 'request_threaded_irq' 
or vice versa. We are able to measure the latency precisely
as the difference of the time when the interrupt pin 'IN'
is raised and we raise our response pin 'OUT' as shown below.

      pin IN        .-------------------------
      ______________|
                    
      pin OUT                     .-----------
      ____________________________|
                          
                    |<- latency ->|

Could anyone point to locations in the kernel so that I can
precisely understand the mechanisms that cause the latency? It 
is totally incomprehensible to me why the 'quick_check_handler' 
must have a latency of 60us at min. (that are many thousand 
instructions).

Any help and comments are greatly appreciated.

Best Regards

Frank
