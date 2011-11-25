Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab1KYN4c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 08:56:32 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:6416 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754099Ab1KYN4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 08:56:31 -0500
Message-ID: <4ECF9E71.2050305@atmel.com>
Date: Fri, 25 Nov 2011 14:56:01 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111031 Thunderbird/7.0.1
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Jamie Iles <jamie@jamieiles.com>
CC: netdev@vger.kernel.org, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] at91_ether: use gpio_is_valid for phy IRQ line
References: <1322128098-17724-1-git-send-email-jamie@jamieiles.com> <1322169674-4109-1-git-send-email-nicolas.ferre@atmel.com> <20111124222836.GB28582@gallagher> <20111125134708.GM15531@game.jcrosoft.org>
In-Reply-To: <20111125134708.GM15531@game.jcrosoft.org>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2011 02:47 PM, Jean-Christophe PLAGNIOL-VILLARD :
> On 22:28 Thu 24 Nov     , Jamie Iles wrote:
>> Hi Nicolas,
>>
>> On Thu, Nov 24, 2011 at 10:21:14PM +0100, Nicolas Ferre wrote:
>>> Use the generic gpiolib gpio_is_valid() function to test
>>> if the phy IRQ line GPIO is actually provided.
>>>
>>> For non-connected or non-existing phy IRQ lines, -EINVAL
>>> value is used for phy_irq_pin field of struct at91_eth_data.
>>>
>>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>>> ---
>>>  drivers/net/ethernet/cadence/at91_ether.c |   23 +++++++++++++----------
>>>  1 files changed, 13 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/cadence/at91_ether.c b/drivers/net/ethernet/cadence/at91_ether.c
>>> index 56624d3..a1c4143 100644
>>> --- a/drivers/net/ethernet/cadence/at91_ether.c
>>> +++ b/drivers/net/ethernet/cadence/at91_ether.c
>>> @@ -255,8 +255,7 @@ static void enable_phyirq(struct net_device *dev)
>>>  	unsigned int dsintr, irq_number;
>>>  	int status;
>>>  
>>> -	irq_number = lp->board_data.phy_irq_pin;
>>> -	if (!irq_number) {
>>> +	if (!gpio_is_valid(lp->board_data.phy_irq_pin)) {
>>>  		/*
>>>  		 * PHY doesn't have an IRQ pin (RTL8201, DP83847, AC101L),
>>>  		 * or board does not have it connected.
>>> @@ -265,6 +264,7 @@ static void enable_phyirq(struct net_device *dev)
>>>  		return;
>>>  	}
>>>  
>>> +	irq_number = lp->board_data.phy_irq_pin;
>>
>> Does this need to be:
>>
>> 	irq_number = gpio_to_irq(lp->board_data.phy_irq_pin);
>>
>> and the same for the other occurrences?  Otherwise this looks like the 
>> right thing to me.
> yes

True but I prefered to separate changes. As it was not addressed like
this in the code I clung to it. I will post an additional patch on top
of this one to add the gpio_to_irq() call.

> Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Best regards,
-- 
Nicolas Ferre
