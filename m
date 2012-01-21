Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab2AUP3N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 10:29:13 -0500
Received: from mta6.srv.hcvlny.cv.net ([167.206.4.212]:34391 "EHLO
	mta6.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab2AUP3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 10:29:11 -0500
Date: Sat, 21 Jan 2012 10:29:37 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: Re: Regression: sky2 kernel between 3.1 and 3.2.1 (last known good
 3.0.9)
In-reply-to: <4F1999DC.3050308@majjas.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jarek Poplawski <jarkao2@gmail.com>, David Miller <davem@davemloft.net>,
        Stephen Hemminger <shemminger@linux-foundation.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Message-id: <4F1AD9E1.8030203@majjas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <20100120094103.GA6225@ff.dom.local> <4B58B217.8030001@majjas.com>
 <20100121204133.GB3085@del.dom.local> <4B59E7EB.3050605@majjas.com>
 <4F1452B1.4010200@majjas.com>
 <20120120082659.1e06853e@nehalam.linuxnetplumber.net>
 <4F1999DC.3050308@majjas.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0) Gecko/20120118
 Thunderbird/10.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/20/2012 11:44 AM, Michael Breuer wrote:
> On 1/20/2012 11:26 AM, Stephen Hemminger wrote:
>> On Mon, 16 Jan 2012 11:39:13 -0500
>> Michael Breuer<mbreuer@majjas.com>  wrote:
>>
>>> Synopsis:
>>>
>>> Receiving DMAR and other errors after approximately three days of
>>> uptime. The symptoms exactly match errors seen and then fixed around
>>> 2.6.32.4.
>>>
>>> While the system remains unaffected for too long to do a bisect, I was
>>> able to confirm that the problem exists in the 3.1 stable branch (I
>>> jumped from 3.0 to 3.2 when 3.2. was released).
>>>
>>> For now I reverted to the sky2.c from 3.0.9 and am running the rest of
>>> the kernel from 3.1.2, but won't be certain that this works until later
>>> in the week.
>>>
>>> Note that 20 seconds prior to the log extract below were DHCP renewal
>>> attempts on eth1, the issue below was on eth0. Not sure it's relevant,
>>> however back in 2010 a preceding DHCP event did turn out to be relevant
>>> to the manifestation of the bug.
>>>
>>> The 3.2.1-dirty I'm running is from git with a single local patch - for
>>> sidewinder force-feedback support (shouldn't be relevant to the sky2 
>>> issue).
>>>
>>> Log extract:
>>>
>>> Jan 16 05:49:46 mail kernel: [198230.628919] DRHD: handling fault 
>>> status
>>> reg 2
>>> [snip]
>>>
>>>
>>>
>>
>> Which exact chip version is this?
>>    dmesg | grep sky2
>>    lspci
> [    9.927143] sky2: driver version 1.29
> [    9.927166] sky2 0000:06:00.0: PCI INT A -> GSI 18 (level, low) -> 
> IRQ 18
> [    9.927177] sky2 0000:06:00.0: setting latency timer to 64
> [    9.927254] sky2 0000:06:00.0: Yukon-2 EC Ultra chip revision 3
> [    9.927339] sky2 0000:06:00.0: irq 71 for MSI/MSI-X
> [    9.927562] sky2 0000:06:00.0: eth0: addr 00:26:18:00:1c:3b
> [    9.927578] sky2 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> 
> IRQ 17
> [    9.927586] sky2 0000:04:00.0: setting latency timer to 64
> [    9.927640] sky2 0000:04:00.0: Yukon-2 EC Ultra chip revision 3
> [    9.927718] sky2 0000:04:00.0: irq 72 for MSI/MSI-X
> [    9.927856] sky2 0000:04:00.0: eth1: addr 00:26:18:00:1c:3a
> [   23.468135] sky2 0000:06:00.0: eth0: enabling interface
> [   25.709668] sky2 0000:04:00.0: eth1: enabling interface
> [   25.981841] sky2 0000:06:00.0: eth0: Link is up at 1000 Mbps, full 
> duplex, fl    ow control both
> [   27.418742] sky2 0000:04:00.0: eth1: Link is up at 100 Mbps, full 
> duplex, flo    w control rx
>
> 04:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8056 
> PCI-E Gigabit Ethernet Controller (rev 14)
> 05:00.0 IDE interface: Marvell Technology Group Ltd. 88SE6121 SATA II 
> Controller (rev b2)
> 06:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8056 
> PCI-E Gigabit Ethernet Controller (rev 14)
>
Seems I spoke too soon... Got the sky2 crash again early this morning 
after five days up.

Not sure how I can do any sort of bisect without narrowing down the 
possible culprits.
