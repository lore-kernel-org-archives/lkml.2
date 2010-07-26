Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab0GZRWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 13:22:17 -0400
Received: from nbd.name ([88.198.39.176]:60781 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848Ab0GZRWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 13:22:16 -0400
Message-ID: <4C4DC43E.2060608@openwrt.org>
Date: Mon, 26 Jul 2010 19:22:06 +0200
From: Felix Fietkau <nbd@openwrt.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.11) Gecko/20100711 Thunderbird/3.0.6
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: Jike Song <albcamus@gmail.com>,
        =?UTF-8?B?T3J0d2luIEdsw7xjaw==?= <odi@odi.ch>,
        linux-kernel@vger.kernel.org,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>, jmalinen@atheros.com,
        Sujith.Manoharan@atheros.com, senthilkumar@atheros.com,
        linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: BUG at arch/x86/mm/physaddr.c:5
References: <4C3D5F3F.7070901@odi.ch> <AANLkTimn7Z3LqhLOt4_6ggFgjdzIZQPd_CznOIW-6D1N@mail.gmail.com> 	<4C499E6F.8030507@odi.ch> <AANLkTikrmM0pwBLLMWTCO-stRnoCxwQf0M3ZByc7=8_b@mail.gmail.com> <AANLkTi=Ga2Sy60=wXKQT3nv_PRYw-og7279bD9LTWENE@mail.gmail.com>
In-Reply-To: <AANLkTi=Ga2Sy60=wXKQT3nv_PRYw-og7279bD9LTWENE@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-07-26 6:55 PM, Luis R. Rodriguez wrote:
> 2010/7/25 Jike Song <albcamus@gmail.com>:
>> 2010/7/23 Ortwin Glück <odi@odi.ch>:
>>> On 23.07.2010 10:04, Jike Song wrote:
>>>> Seems to be a logical error?  Does the following patch remove your Oops?
>>>
>>> Looking at the init code I agree. Yes, the patch fixes the OOPS. I am sure
>>> because the OOPS occurred at every boot and now it's gone.
>>>
>>> Thanks!
>>>
>>> Ortwin
>>
>> Hi Maintainers,
>>
>>  Since Ortwin has confirmed this patch , would you give me an ACK/NAK please?
>>
> I'll let Felix chime in on this one as he last reviewed this path.
> There were some serious issues with MIPs and DMA that at this point I
> think only he grocked.

A patch exactly like that was already posted and merged into the
wireless-testing tree a while ago, it apparently just hasn't made it to
Linus' tree. John, could we get this one into 2.6.35?

http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commitdiff;h=56824223ac97ca845652c59bed9ce139e100261b

commit 56824223ac97ca845652c59bed9ce139e100261b
Author: Ming Lei <tom.leiming@gmail.com>
Date:   Fri May 14 21:15:38 2010 +0800

    ath9k: fix dma direction for map/unmap in ath_rx_tasklet
    
    For edma, we should use DMA_BIDIRECTIONAL, or else use
    DMA_FROM_DEVICE.
    
    Signed-off-by: Ming Lei <tom.leiming@gmail.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

