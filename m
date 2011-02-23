Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab1BWWEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 17:04:21 -0500
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:51908 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753090Ab1BWWEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 17:04:20 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAJYTZU1R8sEZ/2dsb2JhbACmHnS8Tw2FUQQ
Date: Wed, 23 Feb 2011 23:04:18 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Mike Waychison <mikew@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] [PATCH 5/10] Generic Watchdog Timer Driver
Message-ID: <20110223220418.GA15279@infomag.iguana.be>
References: <20110223204330.GA7417@infomag.iguana.be> <4D65832C.9020203@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D65832C.9020203@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

>> diff --git a/drivers/watchdog/core/watchdog_dev.c b/drivers/watchdog/core/watchdog_dev.c
>> index 2bf4f67..b80c6e6 100644
>> --- a/drivers/watchdog/core/watchdog_dev.c
>> +++ b/drivers/watchdog/core/watchdog_dev.c
>> @@ -221,6 +221,26 @@ static long watchdog_ioctl(struct file *file, unsigned int cmd,
>>   			return -EOPNOTSUPP;
>>   		watchdog_ping(wdd);
>>   		return 0;
>> +	case WDIOC_SETTIMEOUT:
>> +		if ((wdd->ops->set_timeout == NULL) ||
>> +		    !(wdd->info->options&  WDIOF_SETTIMEOUT))
>> +			return -EOPNOTSUPP;
>> +		if (get_user(val, p))
>> +			return -EFAULT;
>
> Should we sanity check that val > 0 here?  I realize that the driver  
> would need to do it's own sanity checking, but a value of 0 or < 0 makes  
> no sense to the core itself.
>
> Maybe timeout is best expressed as u32 if this is the case.

the sanity check is what is needed in patch 11. Here we should check that the value is between the low and high timeout value.
The timeout value should be an unsigned int at least. Up till now we used values from 1 till 65535.

I'll look into the code to see what val exactly was...

Kind regards,
Wim.

