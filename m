Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab0CWAOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 20:14:20 -0400
Received: from mail-yx0-f182.google.com ([209.85.210.182]:50431 "EHLO
	mail-yx0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658Ab0CWAOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 20:14:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=vXxW9nYO/PspdlOJ+HvxQn/W3qfQsYHaWhcHAW1GZp1/bj29SQAgtsZoLO7BZetqTx
         LKZL2SwZ02aO7WOe+IM3E7+KDTiRDFhiE8sjrJyrSwC27dzr+rIHR9Ek1YfSclkXUdfQ
         G4qlZdvQyn+dqNLcSBMEBxr24AfJuP05hhCaY=
Message-ID: <4BA807D7.7080007@gmail.com>
Date: Mon, 22 Mar 2010 18:14:15 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Leon Woestenberg <leon.woestenberg@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Memory-mapped I/O barriers, state of affairs?
References: <c384c5ea1003221218o2dfcf445s8b7fd5c08076bdab@mail.gmail.com>	 <20100322201637.GA8476@bombe-desk.opditex> <c384c5ea1003221512s229d1d94ta7690d109b75843a@mail.gmail.com>
In-Reply-To: <c384c5ea1003221512s229d1d94ta7690d109b75843a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 04:12 PM, Leon Woestenberg wrote:
> Hello Andreas, all,
>
> On Mon, Mar 22, 2010 at 9:16 PM, Andreas Bombe<aeb@debian.org>  wrote:
>> On Mon, Mar 22, 2010 at 08:18:49PM +0100, Leon Woestenberg wrote:
>>> What is the current solution for that particular problem, i.e. how
>>> should I make sure host memory writes are committed before I have an
>>> external DMA device act on it?
>>
>> The dma_sync_* functions, if you reuse DMA buffers without unmapping,
>> take care of that.  Otherwise the process of mapping them handles it.
>>
> The mapping makes the memory cache-coherent. I already use that.
>
> But does that mean that this coherency is guaranteed to occur before I
> start MMIO access to a device, i.e. is there a guaranteed ordering
> between the writes?

Well, for a streaming mapping, the device may not see the write to the 
memory at all until it's synced or unmapped (for one thing, if the 
kernel is using swiotlb to map the memory, it's an entirely different 
piece of memory and it needs to copy the data to where the device can 
actually see it).

For a coherent mapping, however, though I can't say for certain what the 
behavior is "supposed" to be, many drivers seem to depend on writes to 
these regions being ordered with respect to regular memory and would 
break if a particular platform didn't obey that.
