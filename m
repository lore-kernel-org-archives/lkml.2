Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab1BHQKB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 11:10:01 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:23748 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791Ab1BHQKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 11:10:00 -0500
Date: Tue, 8 Feb 2011 17:09:51 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Eibach, Dirk" <Eibach@gdsys.de>
Cc: "Guenter Roeck" <guenter.roeck@ericsson.com>,
        <linux-kernel@vger.kernel.org>, <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH] hwmon: Consider LM64 temperature offset
Message-ID: <20110208170951.2cc64a62@endymion.delvare>
In-Reply-To: <48D3D52125C49B43AE880038E2E5314BB5BE41@SRV101.gdsys.de>
References: <1297170966-13101-1-git-send-email-eibach@gdsys.de>
	<20110208152815.GA13436@ericsson.com>
	<48D3D52125C49B43AE880038E2E5314BB5BE41@SRV101.gdsys.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dirk,

On Tue, 8 Feb 2011 16:54:52 +0100, Eibach, Dirk wrote:
> 
> Dear Guenter, 
> 
> > Chip id is already detected in lm63_detect. You don't need to 
> > detect it again.
> > The more common approach would be something along the line of
> > 	data->kind = id->driver_data;
> >     You would then use
> > 	if (data->kind == lm64)
> >     throughout the code. In addition to that, you could define
> > 	data->kind = id->driver_data;
> > 	if (data->kind == lm64)
> > 		data->offset = 16000;
> >     which would save you the repeated recalculation of offset 
> > as mentioned before.
> 
> I don't understand, what structures "data" and "id" you are referring to

data is struct lm63_data and id is const struct i2c_device_id which is
passed as a second parameter to the probe function.

> here and where the fields driver_data and kind come from. I remember to
> have seen such in older kernels, but wasn't that replaced sometime ago?

There were indeed some changes in this area in the past few years, but
what Guenter says still applies to current kernels. Look at lm90_probe()
in drivers/hwmon/lm90.c for an example (amongst may others.)

-- 
Jean Delvare
