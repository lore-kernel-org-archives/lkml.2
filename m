Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878Ab1HPQdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 12:33:50 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:52126 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab1HPQdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 12:33:49 -0400
Message-ID: <4E4A9BD8.1040302@atmel.com>
Date: Tue, 16 Aug 2011 18:33:28 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>, vinod.koul@intel.com
CC: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmaengine: at_hdmac: add device tree probe
References: <1312549120-22266-1-git-send-email-nicolas.ferre@atmel.com> <20110807040932.GF7667@ponder.secretlab.ca>
In-Reply-To: <20110807040932.GF7667@ponder.secretlab.ca>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 07/08/2011 06:09, Grant Likely :
> On Fri, Aug 05, 2011 at 01:58:40PM +0100, Nicolas Ferre wrote:
>> Add device tree probe support for atmel at_hdmac DMA driver.
>> Bindings are added to specify the number of channels that the implementation of
>> the controller actually has. They also allow to tell if the peripherals/DMA
>> transfer is supported by the IP.
>>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> ---
>>  .../devicetree/bindings/dma/atmel-hdmac.txt        |   23 +++++++++
>>  drivers/dma/at_hdmac.c                             |   51 ++++++++++++++++----
>>  2 files changed, 65 insertions(+), 9 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/dma/atmel-hdmac.txt
>>
>> diff --git a/Documentation/devicetree/bindings/dma/atmel-hdmac.txt b/Documentation/devicetree/bindings/dma/atmel-hdmac.txt
>> new file mode 100644
>> index 0000000..0e48553
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/dma/atmel-hdmac.txt
>> @@ -0,0 +1,23 @@
>> +* Atmel Direct Memory Access Controller
>> +
>> +Required properties:
>> +- compatible: Should be "atmel,<chip>-hdmac"
>> +- reg: Should contain DMA registers location and length
>> +- interrupts: Should contain DMA interrupt
>> +- atmel,hdmac-nr-channels: Should contain number of channels
>> +  available in the controller
>> +
>> +Optional properties:
>> +- atmel,hdmac-cap-memcpy: Chip can do memory to memory transfers
>> +- atmel,hdmac-cap-slave: Chip can do peripherals/memory transfers
> 
> Heh, ignore my comments on the other patch about missing documentation
> for the dma engine.  :-)
> 
> Otherwise the patch looks pretty good.

[..]

Grant, Vinod,

Don't you think it would make sense to generalize nr-channels and maybe
also the capabilities properties for other dmaengine drivers?
I have seen other dmaengine drivers taking the number of channels from
platform data so that would make sense.
It would be new dmaengine device tree properties, but on the other hand,
I do not know if code can also be centralized for handling of those
properties... maybe it is better to let drivers deal with them if
required...

Your thoughts?

Best regards,
-- 
Nicolas Ferre

