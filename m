Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab0IJLZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 07:25:44 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:10428 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab0IJLZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 07:25:43 -0400
Message-ID: <4C8A15AB.4030209@atmel.com>
Date: Fri, 10 Sep 2010 13:25:31 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.9) Gecko/20100825 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>, avictor.za@gmail.com
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] AT91: at91sam9261ek board: remove warnings related to
 use of SPI or SD/MMC
References: <1284113629-13768-1-git-send-email-nicolas.ferre@atmel.com> <1284113629-13768-2-git-send-email-nicolas.ferre@atmel.com> <4C8A07BA.9090805@ru.mvista.com> <20100910110632.GT9112@game.jcrosoft.org>
In-Reply-To: <20100910110632.GT9112@game.jcrosoft.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 10/09/2010 13:06, Jean-Christophe PLAGNIOL-VILLARD :
>>>   * ADS7846 Touchscreen
>>> @@ -357,6 +350,21 @@ static struct spi_board_info ek_spi_devices[] = {
>>>  #endif
>>>  };
>>>
>>> +#else /* CONFIG_SPI_ATMEL_* */
>>> +
>>> +/*
>>> + * MCI (SD/MMC)
>>> + * spi0 and mmc/sd share the same PIO pins: cannot be used at the same time
>>> + */
>>> +static struct at91_mmc_data __initdata ek_mmc_data = {
>>> +	.wire4		= 1,
>>> +//	.det_pin	= ... not connected
>>> +//	.wp_pin		= ... not connected
>>> +//	.vcc_pin	= ... not connected
>>
>>    The coding style document forbids C99 style // comments. Could
>> replace with normal comment or #if 0...
> no dead code please

I kept those comments because it is just a move of code.

But ok, it seem that they are not liked by several people. As I am in a
"tiny fixes" mood, I post an additional patch to remove them ;-)

Cheers,
-- 
Nicolas Ferre

