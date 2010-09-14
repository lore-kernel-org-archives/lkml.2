Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab0INUsK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 16:48:10 -0400
Received: from mail.bluewatersys.com ([202.124.120.130]:24737 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752457Ab0INUsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 16:48:07 -0400
Message-ID: <4C8FDF87.4050500@bluewatersys.com>
Date: Wed, 15 Sep 2010 08:48:07 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Maxim Osipov <maxim.osipov@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>, Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "Antonio R. Costa" <costa.antonior@gmail.com>,
        Ernst Schwab <eschwab@online.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] AT91: Add flexibity board support
References: <4C8DFA84.4040501@gmail.com>	<4C8E8F31.2050108@bluewatersys.com> <AANLkTi=-n0_uFMKGED-aOtuLEfUyVeMcm5FWX5xM_BT1@mail.gmail.com>
In-Reply-To: <AANLkTi=-n0_uFMKGED-aOtuLEfUyVeMcm5FWX5xM_BT1@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2010 05:57 PM, Maxim Osipov wrote:
> Please see my comments below...
> 
> On Tue, Sep 14, 2010 at 12:53 AM, Ryan Mallon <ryan@bluewatersys.com> wrote:
>> On 09/13/2010 10:18 PM, Maxim Osipov wrote:
>>
>>> +static void __init flexibity_board_init(void)
>>> +{
>>> +     /* Serial */
>>> +     at91_add_device_serial();
>>> +     /* USB Host */
>>> +     at91_add_device_usbh(&flexibity_usbh_data);
>>> +     /* USB Device */
>>> +     at91_add_device_udc(&flexibity_udc_data);
>>> +     /* SPI */
>>> +     at91_add_device_spi(flexibity_spi_devices,
>>> +             ARRAY_SIZE(flexibity_spi_devices));
>>> +     /* MMC */
>>> +     at91_add_device_mmc(0, &flexibity_mmc_data);
>>> +     /* LEDs */
>>> +     at91_gpio_leds(flexibity_leds, ARRAY_SIZE(flexibity_leds));
>>
>> Can we drop all the comments inside this function please. They don't add
>> any information and they make it harder to read the actual code.
>>
> 
> Ryan, thank you for the review. However I would like to keep these
> comments - for some devices, like UDC - it really provides
> clarification. Reading the code is not a problem with proper
> highlighting scheme.

There are already comments above each of the structures so it is clear
what all of these are. IMHO, this commenting is similar to doing:

	/* Add 1 to i */
	i++;

We don't have this kind of overly verbose commenting in any of the other
ARM variants, it appears to something that is just cut and pasted around
the AT91 boards :-). Syntax highlighting or not, reading one for one
comments on what should be straight forward device registration is annoying.

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
