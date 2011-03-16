Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751202Ab1CPNd3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 09:33:29 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:40065 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928Ab1CPNd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 09:33:28 -0400
Date: Wed, 16 Mar 2011 14:32:56 +0100
From: Jean Delvare <khali@linux-fr.org>
To: ben-linux@fluff.org
Cc: Bernhard Walle <walle@corscience.de>, ddaney@caviumnetworks.com,
        ralf@linux-mips.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: octeon: Make the timeout independent of CONFIG_HZ
Message-ID: <20110316143256.1353b0a9@endymion.delvare>
In-Reply-To: <20110124150005.577b0235@endymion.delvare>
References: <4D3D7290.9050203@corscience.de>
	<1295872826-22129-1-git-send-email-walle@corscience.de>
	<20110124150005.577b0235@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Jan 2011 15:00:05 +0100, Jean Delvare wrote:
> On Mon, 24 Jan 2011 13:40:26 +0100, Bernhard Walle wrote:
> > Since the timeout in the struct i2c_adapter use jiffies as unit and a
> > timeout should be independent of CONFIG_HZ, use a value of HZ/50 which
> > is equal to the current value 2 for CONFIG_HZ=100.
> > 
> > Signed-off-by: Bernhard Walle <walle@corscience.de>
> 
> Acked-by: Jean Delvare <khali@linux-fr.org>
> 
> Ben, please apply.

Ben, I can't see this fix in your tree, it seems it got lost?

> > ---
> >  drivers/i2c/busses/i2c-octeon.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/i2c/busses/i2c-octeon.c b/drivers/i2c/busses/i2c-octeon.c
> > index 4cffda5..d07e5c7 100644
> > --- a/drivers/i2c/busses/i2c-octeon.c
> > +++ b/drivers/i2c/busses/i2c-octeon.c
> > @@ -469,7 +469,7 @@ static struct i2c_adapter octeon_i2c_ops = {
> >  	.owner = THIS_MODULE,
> >  	.name = "OCTEON adapter",
> >  	.algo = &octeon_i2c_algo,
> > -	.timeout = 2,
> > +	.timeout = HZ/50,
> >  };
> >  
> >  /**
> 
> 


-- 
Jean Delvare
