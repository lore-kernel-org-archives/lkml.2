Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760162Ab1LPIgf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 03:36:35 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:59780 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751229Ab1LPIge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 03:36:34 -0500
X-Sasl-enc: 2jYC9y/zHitEoYrJgWOuvTXgvz9DQbLSh7bkTv0ZtZzV 1324024592
Message-ID: <4EEB0364.1060101@ladisch.de>
Date: Fri, 16 Dec 2011 09:37:56 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Julian Sikorski <belegdol@gmail.com>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: bug report: irq 19: nobody cared (try booting with the "irqpoll"
 option)
References: <4EEA0485.4050105@gmail.com> <4EEA0521.2030502@gmail.com> <4EEA18A8.5030603@ladisch.de> <4EEA1A81.6030807@gmail.com> <4EEA331F.1060201@ladisch.de> <4EEA34D7.9030109@gmail.com>
In-Reply-To: <4EEA34D7.9030109@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julian Sikorski wrote:
> W dniu 15.12.2011 18:49, Clemens Ladisch pisze:
>> Was it the JMB38x that used a wrong interface number in its PCIe
>> transactions, which would make the I/O-MMU map it to the wrong device?
>> [...]
>> add the kernel parameter intel_iommu=off to the boot loader.
>
> This did not work

> 00:1c.1 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 2
>         Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
> 00:1c.3 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 4
>         Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
> ...
> 03:00.0 Ethernet controller: JMicron Technology Corp. JMC250 PCI Express Gigabit Ethernet Controller (rev 05)
> 03:00.1 System peripheral: JMicron Technology Corp. SD/MMC Host Controller (rev 90)
> 03:00.2 SD Host controller: JMicron Technology Corp. Standard SD Host Controller (rev 90) (prog-if 01)
> 03:00.3 System peripheral: JMicron Technology Corp. MS Host Controller (rev 90)
> 05:00.0 FireWire (IEEE 1394): JMicron Technology Corp. IEEE 1394 Host Controller (prog-if 10 [OHCI])

Sorry, I didn't notice before that your FireWire controller is
a physically separate chip on another PCIe port, so whatever is
happening is unlikely to be related with another device.

It appears that the JMB381 is not correctly reinitialized when doing
a suspend/resume.  However, the driver already does a reset of the chip,
so it isn't clear what else could be done.  This might be a problem
with the PCI initialization as done by the BIOS; try a BIOS update, if
possible.


Regards,
Clemens
