Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627Ab1GNX1N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 19:27:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58436 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932558Ab1GNX1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 19:27:12 -0400
Message-ID: <4E1F7B40.6030705@zytor.com>
Date: Thu, 14 Jul 2011 16:26:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: "John Z. Bohach" <jzb2@aexorsyst.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: large initramfs causes h/w reset after decompressing
References: <201107140906.46404.jzb2@aexorsyst.com> <4E1F5C20.8000008@zytor.com> <201107141532.59383.jzb2@aexorsyst.com>
In-Reply-To: <201107141532.59383.jzb2@aexorsyst.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2011 03:32 PM, John Z. Bohach wrote:
> On Thursday 14 July 2011 02:14:08 pm H. Peter Anvin wrote:
>> On 07/14/2011 09:06 AM, John Z. Bohach wrote:
>>> I have a large initramfs cpio file, about 890 MB, which expands to
>>> 2.7 GB, and am running on linux-2.6.36.1, in 64-bit mode with 8 GB
>>> of physical RAM.
>>>
>>> Upon loading the initramfs, I see the message "Decompressing..."
>>> for a few seconds, and then comes a reset.
>>>
>>> This question has come up before...is there some sort of max size.
>>> that I am exceeding?  With 8 GB of physical memory and 64-bit arch.
>>> (AMD-II), certainly seems that there should be enough memory, no?
>>>
>>> Thanks...
>>
>> What bootloader are you using?  There are some bootloaders which
>> don't allocate the initramfs in a very good spot.
>>
>> 	-hpa
> 
> I've actually gotten the improbable to work, and am PXE booting via 
> syslinux and dhcp.
> 
> It all works fine with an initramfs of ~20 MB, but that's quite a diff. 
> from 2.7 GB of expanded /root (890 MB cpio.tar.gz file).
> 
> But excuse my ignorance, I don't see the relevance of your 
> question...the initramfs is part of the kernel itself...I simply load 
> the kernel bzImage (all 890 MB) and that's where its all at...this is 
> _not_ an initrd.
> 

Ah, interesting.  You didn't say that.  That does change some things...
I would not at all be surprised if the kernel decompressor doesn't
handle that very well...

	-hpa

