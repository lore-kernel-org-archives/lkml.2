Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab0EUMrB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 08:47:01 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:60011 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353Ab0EUMq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 08:46:59 -0400
Date: Fri, 21 May 2010 14:46:41 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Hemanth V <hemanthv@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: Re: [RFC] [PATCH] misc : ROHM BH1780GLI Ambient light sensor Driver
Message-ID: <20100521124641.GQ30801@buzzloop.caiaq.de>
References: <31752.10.24.255.17.1274441750.squirrel@dbdmail.itg.ti.com>
 <20100521120347.GP30801@buzzloop.caiaq.de>
 <035e01caf8e2$bb7b5580$LocalHost@wipblrx0099946>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <035e01caf8e2$bb7b5580$LocalHost@wipblrx0099946>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 06:10:00PM +0530, Hemanth V wrote:
> >On Fri, May 21, 2010 at 05:05:50PM +0530, Hemanth V wrote:
> >>+ mutex_lock(&ddata->lock);
> >>+
> >>+ error = bh1780_write(ddata, BH1780_REG_CONTROL, val, "CONTROL");
> >>+ if (error < 0) {
> >>+ mutex_unlock(&ddata->lock);
> >>+ return error;
> >>+ }
> >>+
> >>+ msleep(BH1780_PON_DELAY);
> >
> >Hmm, what do you wait for here?
> 
> Settling time delay required before lux read out

I thought so, but in fact you're just delaying the next two lines by
that:

> >>+ ddata->power_state = val;
> >>+ mutex_unlock(&ddata->lock);

... which doesn't make sense to me.

I can believe there is need to wait for the value to settle, but I think
it's the wrong place where you're doing it currently.

> >>+static int __devinit bh1780_probe(struct i2c_client *client,
> >>+ const struct i2c_device_id *id)
> >>+{
> >>+ int ret;
> >>+ struct bh1780_data *ddata = NULL;
> >
> >The initialization isn't needed.
> 
> This is basically added for the first goto error, to prevent
> any garbage values

Sorry, you're right. Ignore this comment :)

Thanks,
Daniel

