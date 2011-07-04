Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185Ab1GDP5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 11:57:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:52917 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758008Ab1GDP5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 11:57:18 -0400
Message-ID: <4E11E2DC.2070601@linutronix.de>
Date: Mon, 04 Jul 2011 17:57:16 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org, sodaville@linutronix.de
Subject: Re: [PATCH 1/2] gpio/gpio-generic: read set register for caching
 if available
References: <1309159583-11339-1-git-send-email-bigeasy@linutronix.de> <20110704154447.GG29977@ponder.secretlab.ca>
In-Reply-To: <20110704154447.GG29977@ponder.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely wrote:
>> diff --git a/drivers/gpio/gpio-generic.c b/drivers/gpio/gpio-generic.c
>> index 231714d..9f8b5c6 100644
>> --- a/drivers/gpio/gpio-generic.c
>> +++ b/drivers/gpio/gpio-generic.c
>> @@ -398,7 +398,10 @@ int __devinit bgpio_init(struct bgpio_chip *bgc,
>>  	if (ret)
>>  		return ret;
>>  
>> -	bgc->data = bgc->read_reg(bgc->reg_dat);
>> +	if (bgc->reg_set)
>> +		bgc->data = bgc->read_reg(bgc->reg_set);
> 
> On most of the gpio controllers that I've seen, the 'set' register
> isn't something that you can actually read.  I don't think this is
> something that can be done for all gpio controllers.

I see. So

	if (bgc->reg_set && ! bgc->reg_clr)

instead should be fine, right?

> g.
> 
Sebastian
