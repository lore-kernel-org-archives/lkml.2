Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385Ab1I2S4d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 14:56:33 -0400
Received: from sestofw01.enea.se ([192.36.1.252]:6793 "HELO mx-3.enea.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752912Ab1I2S4c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 14:56:32 -0400
Message-ID: <4E84BF5C.4020601@enea.com>
Date: Thu, 29 Sep 2011 20:56:28 +0200
From: Arvid Brodin <arvid.brodin@enea.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?H=E5vard_Skinnemoen?= <hskinnemoen@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-embedded@vger.kernel.org>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>, <arnd@arndb.de>
Subject: Re: dma_unmap_single() lacking cache sync on some archs?
References: <4E81BDEE.2080601@enea.com> <CAF8ieYUPcer2ZwaOi6YbiZQPeDBFukT2_dPStH10G_15Rh1fpw@mail.gmail.com>
In-Reply-To: <CAF8ieYUPcer2ZwaOi6YbiZQPeDBFukT2_dPStH10G_15Rh1fpw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [172.23.1.38]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Håvard Skinnemoen wrote:
> Hi,
> 
> On Tue, Sep 27, 2011 at 5:13 AM, Arvid Brodin <arvid.brodin@enea.com> wrote:
>> [Resending with CC to affected parties]
>>
>> Hi,
>>
>> I would expect cache synchronization for DMA_TO_DEVICE and DMA_BIDIRECTIONAL
>> when dma_map_single() is called, and for DMA_FROM_DEVICE and DMA_BIDIRECTIONAL
>> when dma_unmap_single() is called.
>>
>> However, on some architechtures (at least avr32, blackfin, ...), cache
>> synchronization only happens when dma_map_single() is called (and then
>> irrespective of DMA direction). dma_unmap_single() is a no-op for these archs.
>>
>> See e.g. http://lxr.linux.no/#linux+v3.0.4/arch/avr32/include/asm/dma-mapping.h#L117
>>
>> Isn't this a bug?
> 
> I don't think so. What do other architectures do?
> 
> We always need to sync before the transfer because if there is dirty
> data in the cache, it might get written to RAM during the transfer,
> which would be bad. Then, since the relevant cache lines are already
> clean and invalid, and the CPU is not allowed to access the buffer
> during the transfer, there's no need to sync again when the transfer
> is complete.

I see. Thanks for the explanation!

> 
> Havard

-- 
Arvid Brodin
Enea Services Stockholm AB
