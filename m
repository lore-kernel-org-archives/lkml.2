Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab0EUODE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 10:03:04 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60998 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754781Ab0EUODB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 10:03:01 -0400
Message-ID: <03b301caf8ee$4dc484b0$LocalHost@wipblrx0099946>
From: "Hemanth V" <hemanthv@ti.com>
To: "Daniel Mack" <daniel@caiaq.de>
Cc: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
       <linux-input@vger.kernel.org>
References: <31752.10.24.255.17.1274441750.squirrel@dbdmail.itg.ti.com> <20100521120347.GP30801@buzzloop.caiaq.de> <035e01caf8e2$bb7b5580$LocalHost@wipblrx0099946> <20100521124641.GQ30801@buzzloop.caiaq.de>
Subject: Re: [RFC] [PATCH] misc : ROHM BH1780GLI Ambient light sensor Driver
Date: Fri, 21 May 2010 19:32:50 +0530
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3598
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3350
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----- 
From: "Daniel Mack" <daniel@caiaq.de>
To: "Hemanth V" <hemanthv@ti.com>
Cc: <linux-kernel@vger.kernel.org>; <linux-omap@vger.kernel.org>; 
<linux-input@vger.kernel.org>
Sent: Friday, May 21, 2010 6:16 PM
Subject: Re: [RFC] [PATCH] misc : ROHM BH1780GLI Ambient light sensor Driver


> On Fri, May 21, 2010 at 06:10:00PM +0530, Hemanth V wrote:
>> >On Fri, May 21, 2010 at 05:05:50PM +0530, Hemanth V wrote:
>> >>+ mutex_lock(&ddata->lock);
>> >>+
>> >>+ error = bh1780_write(ddata, BH1780_REG_CONTROL, val, "CONTROL");
>> >>+ if (error < 0) {
>> >>+ mutex_unlock(&ddata->lock);
>> >>+ return error;
>> >>+ }
>> >>+
>> >>+ msleep(BH1780_PON_DELAY);
>> >
>> >Hmm, what do you wait for here?
>>
>> Settling time delay required before lux read out
>
> I thought so, but in fact you're just delaying the next two lines by
> that:
>
>> >>+ ddata->power_state = val;
>> >>+ mutex_unlock(&ddata->lock);
>
> ... which doesn't make sense to me.
>
> I can believe there is need to wait for the value to settle, but I think
> it's the wrong place where you're doing it currently.
>

I could move it one line down,  but not really release the mutex.
Which other place would you suggest.


