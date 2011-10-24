Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab1JXJGQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 05:06:16 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:16110 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916Ab1JXJGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 05:06:15 -0400
Message-ID: <4EA52A74.4080800@atmel.com>
Date: Mon, 24 Oct 2011 11:05:56 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: robherring2@gmail.com, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v3 0/4] dmaengine: Device Tree support for Atmel DMA
References: <1318438634-11826-1-git-send-email-nicolas.ferre@atmel.com>  <4E9C258D.3030509@atmel.com> <1319426904.9355.40.camel@vkoul-udesk3>
In-Reply-To: <1319426904.9355.40.camel@vkoul-udesk3>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2011 05:28 AM, Vinod Koul :
> On Mon, 2011-10-17 at 14:54 +0200, Nicolas Ferre wrote:
>> On 10/12/2011 06:57 PM, Nicolas Ferre :
>>> This series add the device tree support to Atmel DMA controller driver:
>>> at_hdmac.
>>> The removal of platform data ease the conversion to device tree. It also have
>>> the additional benefit of being simpler and cleaner.
>>>
>>> Nicolas Ferre (4):
>>>       dmaengine: at_hdmac: platform data move to use .id_table
>>>       dmaengine: at_hdmac: add device tree support
>>>       ARM: at91/dma: remove platform data from DMA controller
>>>       ARM: at91/dma: DMA controller registering with DT support
>>>
>>>  .../devicetree/bindings/dma/atmel-dma.txt          |   14 ++++
>>>  arch/arm/mach-at91/at91sam9g45_devices.c           |   17 ++---
>>>  arch/arm/mach-at91/at91sam9rl_devices.c            |    8 +--
>>>  arch/arm/mach-at91/include/mach/at_hdmac.h         |   10 ---
>>>  drivers/dma/at_hdmac.c                             |   76 +++++++++++++++++---
>>>  drivers/dma/at_hdmac_regs.h                        |    8 ++
>>>  6 files changed, 97 insertions(+), 36 deletions(-)
>>>  create mode 100644 Documentation/devicetree/bindings/dma/atmel-dma.txt
>>
>> Vinod,
>>
>> I have just rebased the dmaengine at_hdmac driver patches on top of your
>> "next" branch as a "v4" series. I send it to you with Grant's "Acked-by"
>> right now.
> I manged to fail the compliation with this patch
> drivers/dma/at_hdmac.c: In function 'at_dma_get_driver_data':
> drivers/dma/at_hdmac.c:1211: error: implicit declaration of function 'of_match_node'
> drivers/dma/at_hdmac.c:1211: error: 'atmel_dma_dt_ids' undeclared (first use in this function)
> drivers/dma/at_hdmac.c:1211: error: (Each undeclared identifier is reported only once
> drivers/dma/at_hdmac.c:1211: error: for each function it appears in.)
> drivers/dma/at_hdmac.c:1211: warning: assignment makes pointer from integer without a cast
> drivers/dma/at_hdmac.c: At top level:
> drivers/dma/at_hdmac.c:1558: error: implicit declaration of function 'of_match_ptr'
> drivers/dma/at_hdmac.c:1558: error: 'atmel_dma_dt_ids' undeclared here (not in a function)
> drivers/dma/at_hdmac.c:1558: error: initializer element is not constant
> drivers/dma/at_hdmac.c:1558: error: (near initialization for 'at_dma_driver.driver.of_match_table')
> make[1]: *** [drivers/dma/at_hdmac.o] Error 1
> 
> Which, IMO are triggered as one of my configs for at_hdmac did not have
> CONFIG_OF enabled. 

Yes, you are right for of_match_node(), I should protect it from non
CONFIG_OF configuration.
Maybe we should provide an empty of_match_node() function in of.h...

> I think at_hdmac should select or depend on this. I
> did latter and still I get compilation error :(
> 
> drivers/dma/at_hdmac.c:1558: error: implicit declaration of function 'of_match_ptr'
> drivers/dma/at_hdmac.c:1558: error: initializer element is not constant
> drivers/dma/at_hdmac.c:1558: error: (near initialization for 'at_dma_driver.driver.of_match_table')
> make[1]: *** [drivers/dma/at_hdmac.o] Error 1

Well, of_match_ptr() macro is included in devicetree/next git tree and
will go to mainline during next merge window. It is the desired way to
specify a match table pointer for device tree enabled drivers...

Here is the commit ID in linux-next:
3a1e362e3f3cd571b3974b8d44b8e358ec7a098c

I have a serial driver conversion to device tree sitting in Greg's tty
tree with same functions used. It is also scheduled for inclusion in
next merge 3.2 merge window.

So, I will submit a new v5 revision with of_match_node() only called
when device tree is actually selected. But I will keep the
of_match_ptr() macro. Does it sound ok to you? Or maybe just a little
patch that you can fold into the current one is the best?

Thanks, best regards,
-- 
Nicolas Ferre
