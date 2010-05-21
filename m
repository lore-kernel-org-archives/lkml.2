Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602Ab0EUOuo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 10:50:44 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:52719 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755793Ab0EUOum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 10:50:42 -0400
Date: Fri, 21 May 2010 16:50:23 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Hemanth V <hemanthv@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: Re: [RFC] [PATCH] misc : ROHM BH1780GLI Ambient light sensor Driver
Message-ID: <20100521145023.GT30801@buzzloop.caiaq.de>
References: <31752.10.24.255.17.1274441750.squirrel@dbdmail.itg.ti.com>
 <20100521120347.GP30801@buzzloop.caiaq.de>
 <035e01caf8e2$bb7b5580$LocalHost@wipblrx0099946>
 <20100521124641.GQ30801@buzzloop.caiaq.de>
 <03b301caf8ee$4dc484b0$LocalHost@wipblrx0099946>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03b301caf8ee$4dc484b0$LocalHost@wipblrx0099946>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 07:32:50PM +0530, Hemanth V wrote:
> >On Fri, May 21, 2010 at 06:10:00PM +0530, Hemanth V wrote:
> >>>On Fri, May 21, 2010 at 05:05:50PM +0530, Hemanth V wrote:
> >>>>+ mutex_lock(&ddata->lock);
> >>>>+
> >>>>+ error = bh1780_write(ddata, BH1780_REG_CONTROL, val, "CONTROL");
> >>>>+ if (error < 0) {
> >>>>+ mutex_unlock(&ddata->lock);
> >>>>+ return error;
> >>>>+ }
> >>>>+
> >>>>+ msleep(BH1780_PON_DELAY);
> >>>
> >>>Hmm, what do you wait for here?
> >>
> >>Settling time delay required before lux read out
> >
> >I thought so, but in fact you're just delaying the next two lines by
> >that:
> >
> >>>>+ ddata->power_state = val;
> >>>>+ mutex_unlock(&ddata->lock);
> >
> >... which doesn't make sense to me.
> >
> >I can believe there is need to wait for the value to settle, but I think
> >it's the wrong place where you're doing it currently.
> >
> 
> I could move it one line down,  but not really release the mutex.
> Which other place would you suggest.

Ah, you just need to wait for the power register to take effect. I
didn't get it, sorry. I tought the delay was supposed to be inbetween
the write of one register and the read of another.

So that all looks sane to me then. Once the other minor things are
fixed, feel free to add my

  Reviewed-by: Daniel Mack <daniel@caiaq.de>

Thanks,
Daniel

