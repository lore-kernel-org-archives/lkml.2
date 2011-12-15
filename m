Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758819Ab1LOMjd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 07:39:33 -0500
Received: from www.linutronix.de ([62.245.132.108]:36707 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809Ab1LOMjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 07:39:32 -0500
Date: Thu, 15 Dec 2011 13:39:28 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Clemens Ladisch <clemens@ladisch.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: fix number of mapped SG DMA entries
Message-ID: <20111215123927.GA19650@linutronix.de>
References: <4EDAA59B.6080900@ladisch.de>
 <Pine.LNX.4.44L0.1112041157370.32730-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1112041157370.32730-100000@netrider.rowland.org>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alan Stern | 2011-12-04 11:59:32 [-0500]:

>On Sat, 3 Dec 2011, Clemens Ladisch wrote:
>
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
>Interesting.  Do you have any idea why this warning didn't show up 
>earlier?  Is there perhaps a Kconfig option I ought to be using?

My question here is why don't we map the complete sg list but only
one entry. What happens to the remaining few sg list entries? Don't we
sent too less data?
Is there anything special you do to get into this kind of situation?
Like 16GiB of memory on 32bit with highmem and a brutal disk/io test
case so?

>Alan Stern

Sebastian
