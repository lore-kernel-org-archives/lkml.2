Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab0I2Lyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 07:54:44 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:33545 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752323Ab0I2Lyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 07:54:41 -0400
Message-ID: <4CA328E3.3040502@stericsson.com>
Date: Wed, 29 Sep 2010 13:54:11 +0200
From: Linus Walleij <linus.walleij@stericsson.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Dan Williams <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "yuanyabin1978@sina.com" <yuanyabin1978@sina.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] SPI: add PrimeCell generic DMA to PL022 v12
References: <1285684441-21700-1-git-send-email-linus.walleij@stericsson.com> <1285684441-21700-2-git-send-email-linus.walleij@stericsson.com> <20100929082055.GC4703@angua.secretlab.ca>
In-Reply-To: <20100929082055.GC4703@angua.secretlab.ca>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely wrote:

> On Tue, Sep 28, 2010 at 04:33:55PM +0200, Linus Walleij wrote:

>> This extends the PL022 SSP/SPI driver with generic DMA engine
>> support using the PrimeCell DMA engine interface. Also fix up the
>> test code for the U300 platform.
>> (...)
>> --- a/arch/arm/mach-u300/dummyspichip.c
>> +++ b/arch/arm/mach-u300/dummyspichip.c
>> @@ -267,6 +267,7 @@ static struct spi_driver pl022_dummy_driver = {
>>  	.driver = {
>>  		.name	= "spi-dummy",
>>  		.owner	= THIS_MODULE,
>> +		.bus = &spi_bus_type,
> 
> This shouldn't be necessary.  spi_register_driver already sets the bus
> type field.
> 
> Otherwise, this patch looks good.  If you're okay with me dropping
> this hunk, then I'll pick up this patch into my next-spi branch.

OK just drop it, thanks Grant.

I need to come up with the right way to refactor that dummychip anyway
to I'll churn it out completely sooner or later.

Yours,
Linus Walleij

