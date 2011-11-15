Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab1KOADo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 19:03:44 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:44369 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab1KOADn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 19:03:43 -0500
Message-ID: <4EC1AC5B.6000001@lwfinger.net>
Date: Mon, 14 Nov 2011 18:03:39 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: LKML <linux-kernel@vger.kernel.org>, iommu@lists.linux-foundation.org,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: nommu warning message
References: <4EBD65F5.8090808@lwfinger.net> <20111114114213.GC14704@amd.com>
In-Reply-To: <20111114114213.GC14704@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2011 05:42 AM, Joerg Roedel wrote:
> On Fri, Nov 11, 2011 at 12:14:13PM -0600, Larry Finger wrote:
>> For the driver rtl8192cu (a USB wireless device), the current
>> version loads the 15KB firmware asynchronously one 32-bit quantity
>> at a time. Although inefficient. this method works with USB 1.1 and
>> USB 2.0 adapters; however, it fails on at least one USB 3.0 adapter
>> with "xhci_hcd 0000:05:00.0: ERROR no room on ep ring" errors.
>>
>> These errors are believed to arise from small, fixed-size ep rings.
>> There is a vendor driver that works with that same hardware. The
>> major difference is that it uses synchronous block writes of 254
>> bytes. When I tried this with the in-kernel driver, each block write
>> yields a warning as shown below:
>>
>> nommu_map_single: overflow 41000340d020+254 of device mask ffffffff
>
> Strange. This means that your system uses the nommu DMA driver. But for
> your hardware the GART or SWIOTLB should be used.
>
> Even more strange is the address used for the device. I don't believe is
> is correct, otherwise your Laptop would have a very huge amount of RAM
> :)
>
> The I think there are two issues here: Why is your system using nommu
> and not GART? Can you check that GART and SWIOTLB are enabled in your
> kernel config? Second, why is your system using the wrong address? This
> looks like some kind of driver bug to mee.

My system has 3 GB of RAM installed, and it has both GART and SWIOTLB enabled.

Your comment about the strange address made me wonder if my driver was somehow 
overrunning a buffer. Keeping the buffer size constant while reducing the 
maximum block size by 10 bytes cleared the problem. Obviously, I there is some 
buffer overhead that I had not considered.

Thanks for pointing me in the right direction.

Larry
