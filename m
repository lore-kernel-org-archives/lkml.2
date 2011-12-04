Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab1LDRFA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 12:05:00 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:33426 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752861Ab1LDRE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 12:04:58 -0500
X-Sasl-enc: w2t6GDEru+Q4H98OxJ41N5xfeYWfyk84q98AwS6ztZ4o 1323018297
Message-ID: <4EDBA82A.5080300@ladisch.de>
Date: Sun, 04 Dec 2011 18:04:42 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: fix number of mapped SG DMA entries
References: <Pine.LNX.4.44L0.1112041157370.32730-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1112041157370.32730-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Sat, 3 Dec 2011, Clemens Ladisch wrote:
>> Add a new field num_mapped_sgs to struct urb so that we have a place to
>> store the number of mapped entries and can also retain the original
>> value of entries in num_sgs.  Previously, usb_hcd_map_urb_for_dma()
>> would overwrite this with the number of mapped entries, which would
>> break dma_unmap_sg() because it requires the original number of entries.
>>
>> This fixes warnings like the following when using USB storage devices:
>>  ------------[ cut here ]------------
>>  WARNING: at lib/dma-debug.c:902 check_unmap+0x4e4/0x695()
>>  ehci_hcd 0000:00:12.2: DMA-API: device driver frees DMA sg list with different entry count [map count=4] [unmap count=1]
>
> Interesting.  Do you have any idea why this warning didn't show up
> earlier?  Is there perhaps a Kconfig option I ought to be using?

CONFIG_DMA_API_DEBUG; its help warns of performance degradation.


Regards,
Clemens
