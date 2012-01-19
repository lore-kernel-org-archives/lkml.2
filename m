Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab2ASK0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 05:26:47 -0500
Received: from mx01.sz.bfs.de ([194.94.69.103]:23870 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211Ab2ASK0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 05:26:45 -0500
Message-ID: <4F17EFE1.3060804@bfs.de>
Date: Thu, 19 Jan 2012 11:26:41 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
        "Igor M. Liplianin" <liplianin@me.by>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch 2/2] [media] ds3000: off by one in ds3000_read_snr()
References: <20120117073021.GB11358@elgon.mountain> <4F16FC26.80306@bfs.de> <20120119093327.GI3356@mwanda>
In-Reply-To: <20120119093327.GI3356@mwanda>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 19.01.2012 10:33, schrieb Dan Carpenter:
> On Wed, Jan 18, 2012 at 06:06:46PM +0100, walter harms wrote:
>>
>>
>> Am 17.01.2012 08:30, schrieb Dan Carpenter:
>>> This is a static checker patch and I don't have the hardware to test
>>> this, so please review it carefully.  The dvbs2_snr_tab[] array has 80
>>> elements so when we cap it at 80, that's off by one.  I would have
>>> assumed that the test was wrong but in the lines right before we have
>>> the same test but use "snr_reading - 1" as the array offset.  I've done
>>> the same thing here.
>>>
>>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>>>
>>> diff --git a/drivers/media/dvb/frontends/ds3000.c b/drivers/media/dvb/frontends/ds3000.c
>>> index af65d01..3f5ae0a 100644
>>> --- a/drivers/media/dvb/frontends/ds3000.c
>>> +++ b/drivers/media/dvb/frontends/ds3000.c
>>> @@ -681,7 +681,7 @@ static int ds3000_read_snr(struct dvb_frontend *fe, u16 *snr)
>>>  			snr_reading = dvbs2_noise_reading / tmp;
>>>  			if (snr_reading > 80)
>>>  				snr_reading = 80;
>>> -			*snr = -(dvbs2_snr_tab[snr_reading] / 1000);
>>> +			*snr = -(dvbs2_snr_tab[snr_reading - 1] / 1000);
>>>  		}
>>>  		dprintk("%s: raw / cooked = 0x%02x / 0x%04x\n", __func__,
>>>  				snr_reading, *snr);
>>
>> hi dan,
>>
>> perhaps it is more useful to do it in the check above ?
> 
> It looks like the check is correct but we need to shift all the
> values by one.  Again, I don't have this hardware, I'm just going by
> the context.
> 
I do not have the hardware either so this is pure theoretical.

Access to the data field depends on the value of dvbs2_noise_reading/tmp
even when the data are reasonable like 50/100 snr_reading would become 0
and the index suddenly is -1.

just my 2 cents.

re,
 wh


>> thinking about that why not replace the number (80) with ARRAY_SIZE() ?
> 
> That would be a cleanup, yes but it could go in a separate patch.
> 
> regards,
> dan carpenter
> 
