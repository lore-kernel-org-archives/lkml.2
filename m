Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758926Ab1LOPgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 10:36:22 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:39745 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751570Ab1LOPgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 10:36:21 -0500
X-Sasl-enc: aFatUUFYEGGNz1WAC4SMKnykkfMfS+hHntYPS+hPxY/s 1323963380
Message-ID: <4EEA144A.4070108@ladisch.de>
Date: Thu, 15 Dec 2011 16:37:46 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: fix number of mapped SG DMA entries
References: <4EDAA59B.6080900@ladisch.de> <Pine.LNX.4.44L0.1112041157370.32730-100000@netrider.rowland.org> <20111215123927.GA19650@linutronix.de>
In-Reply-To: <20111215123927.GA19650@linutronix.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian Andrzej Siewior wrote:
> * Alan Stern | 2011-12-04 11:59:32 [-0500]:
>> On Sat, 3 Dec 2011, Clemens Ladisch wrote:
>>> Add a new field num_mapped_sgs to struct urb so that we have a place to
>>> store the number of mapped entries and can also retain the original
>>> value of entries in num_sgs.  Previously, usb_hcd_map_urb_for_dma()
>>> would overwrite this with the number of mapped entries, which would
>>> break dma_unmap_sg() because it requires the original number of entries.
>>>
>>> This fixes warnings like the following when using USB storage devices:
>>>  ------------[ cut here ]------------
>>>  WARNING: at lib/dma-debug.c:902 check_unmap+0x4e4/0x695()
>>>  ehci_hcd 0000:00:12.2: DMA-API: device driver frees DMA sg list with different entry count [map count=4] [unmap count=1]
>>
>> Interesting.  Do you have any idea why this warning didn't show up
>> earlier?  Is there perhaps a Kconfig option I ought to be using?
>
> My question here is why don't we map the complete sg list but only
> one entry. What happens to the remaining few sg list entries? Don't we
> sent too less data?

Documentation/DMA-API.txt says:
| Returns: the number of physical segments mapped (this may be shorter
| than <nents> passed in if some elements of the scatter/gather list are
| physically or virtually adjacent and an IOMMU maps them with a single
| entry).

> Is there anything special you do to get into this kind of situation?

It appears that enabling CONFIG_DMA_API_DEBUG is quite special.  :o)

> Like 16GiB of memory on 32bit with highmem and a brutal disk/io test
> case so?

Plain x86-64; very few file operations done by hand.


Regards,
Clemens
