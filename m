Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab1CCKdk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 05:33:40 -0500
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:51987 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752704Ab1CCKdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 05:33:39 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAMP7bk1R8KK1/2dsb2JhbACmdHW+XA2FVAQ
Date: Thu, 3 Mar 2011 11:33:36 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Mike Waychison <mikew@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] [PATCH 6/10] Generic Watchdog Timer Driver
Message-ID: <20110303103336.GZ3790@infomag.iguana.be>
References: <20110223204350.GA7433@infomag.iguana.be> <4D6584F2.1010109@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6584F2.1010109@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

>> diff --git a/drivers/watchdog/core/watchdog_core.c b/drivers/watchdog/core/watchdog_core.c
>> index 52bc520..d1a824e 100644
>> --- a/drivers/watchdog/core/watchdog_core.c
>> +++ b/drivers/watchdog/core/watchdog_core.c
>> @@ -60,6 +60,10 @@ int register_watchdogdevice(struct watchdog_device *wdd)
>>   	if (wdd == NULL || wdd->info == NULL || wdd->ops == NULL)
>>   		return -ENODATA;
>>
>> +	/* Make sure that the owner of the watchdog operations exists */
>> +	if (wdd->ops->owner == NULL)
>> +		return -ENODATA;
>
> This check is invalid when the driver is built in.

Will have a look at it. Thanks!

Kind regards,
Wim.

