Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812Ab1BVMcj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 07:32:39 -0500
Received: from smtprelay05.ispgateway.de ([80.67.31.99]:44050 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab1BVMci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 07:32:38 -0500
Message-ID: <4D63AD35.6050808@ladisch.de>
Date: Tue, 22 Feb 2011 13:33:57 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: "Schaefer Dr, Frank-Rene ()" <fschaef9@visteon.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Interrupt Latencies
References: <060E4307CE6CA14BB4F7B4A25ECA052904B73AD1@VEUMBV03.vistcorp.ad.visteon.com>
In-Reply-To: <060E4307CE6CA14BB4F7B4A25ECA052904B73AD1@VEUMBV03.vistcorp.ad.visteon.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Schaefer Dr, Frank-Rene wrote:
> Having read "Moving interrupts to threads" at
> 
>            http://lwn.net/Articles/302043/
> 
> I expected to reduce interrupt latency during a SPI
> communication by handling the transmit-receive in a
> 'quick_check_handler' using
> 
>            request_threaded_irq(...);
> 
> However, the difference in latency to "request_irq(...)"
> is not measurable.

Threaded interrupts reduce the latency for _other_ interrupts because
most of the code has been moved into the thread.  Without threaded
interrupts, the same could would be in the actual interrupt handler
(the equivalent of the quick check handler).

> It is totally incomprehensible to me why the 'quick_check_handler'
> must have a latency of 60us at min. (that are many thousand
> instructions).

The sytem's interrupt handling and the I/O accesses aren't fast.
Furthermore, waking the CPU up, or changing its frequency, can be quite
slow (but I don't know how much in the case of your Atom).  You could
try reducing the interrupt latency by not letting the CPU get idle but
executing some low-priority busy loop.


Regards,
Clemens
