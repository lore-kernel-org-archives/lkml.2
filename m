Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab2KLLD0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 06:03:26 -0500
Received: from mout.web.de ([212.227.15.3]:49170 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883Ab2KLLDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 06:03:23 -0500
Message-ID: <50A0D764.204@web.de>
Date: Mon, 12 Nov 2012 12:03:00 +0100
From: Soeren Moch <smoch@web.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Andrew Lunn <andrew@lunn.ch>
CC: Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH] mm: dmapool: use provided gfp flags for all dma_alloc_coherent()
 calls
References: <1352356737-14413-1-git-send-email-m.szyprowski@samsung.com> <20121111172243.GB821@lunn.ch> <50A0C5D2.7000806@web.de> <20121112103820.GX22029@lunn.ch>
In-Reply-To: <20121112103820.GX22029@lunn.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:2K4FuQMkK4Sip/PSC3cuBmpkCI52c4afrgzWuG/itSg
 GyqcT0IGFE3DMy8O+KdGdvMIVTshNECE/kqNgH06fdwDZL3j8s
 YXccKGUecJUDlXg6TXfc36WWAbrM96lNh0t4k4Kx2yvqXmqbZc
 OJVS6/xZEw3cia4FNYqfiNubIj8qw7vdCK/zQfoyZMxdSiBVGa
 A97d03+4JxyccHb9vVK3g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.11.2012 11:38, Andrew Lunn wrote:
> On Mon, Nov 12, 2012 at 10:48:02AM +0100, Soeren Moch wrote:
>> On 11.11.2012 18:22, Andrew Lunn wrote:
>>> On Thu, Nov 08, 2012 at 07:38:57AM +0100, Marek Szyprowski wrote:
>>>> dmapool always calls dma_alloc_coherent() with GFP_ATOMIC flag,
>> regardless
>>>> the flags provided by the caller. This causes excessive pruning of
>>>> emergency memory pools without any good reason. This patch
>> changes the code
>>>> to correctly use gfp flags provided by the dmapool caller. This should
>>>> solve the dmapool usage on ARM architecture, where GFP_ATOMIC DMA
>>>> allocations can be served only from the special, very limited
>> memory pool.
>>>> Reported-by: Soren Moch <smoch@web.de>
>> Please use
>> Reported-by: Soeren Moch <smoch@web.de>
>>
>>>> Reported-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
>>>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>>> Tested-by: Andrew Lunn <andrew@lunn.ch>
>>>
>>> I tested this on a Kirkwood QNAP after removing the call to
>>> init_dma_coherent_pool_size().
>>>
>>>      Andrew
>> Tested-by: Soeren Moch <smoch@web.de>
>>
>> Now I had a chance to test this patch on my Kirkwood guruplug
>> system with linux-3.6.6 . It is running much better now, but with the
>> original 256K coherent pool size I still see errors after several hours
>> of runtime:
>>
>> Nov 12 09:42:32 guru kernel: ERROR: 256 KiB atomic DMA coherent pool
>> is too small!
>> Nov 12 09:42:32 guru kernel: Please increase it with coherent_pool=
>> kernel parameter!
> Hi Soeren
>
> Could you tell us what DVB devices you are using.
>
> Thanks
> 	Andrew

from lsusb:
Bus 001 Device 005: ID 0ccd:00b2 TerraTec Electronic GmbH
Bus 001 Device 006: ID 2040:5200 Hauppauge
Bus 001 Device 009: ID 2304:0242 Pinnacle Systems, Inc.

If you want to check the drivers, I recommend to start with "em28xx".

Regards,
Soeren
