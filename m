Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760594Ab0JGNYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 09:24:53 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:27835 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab0JGNYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 09:24:51 -0400
Date: Thu, 7 Oct 2010 15:24:42 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: Fix Kconfig dependencies
Message-ID: <20101007152442.1901a630@endymion.delvare>
In-Reply-To: <20101005155631.GA9399@sepie.suse.cz>
References: <1286199093-3576-1-git-send-email-mmarek@suse.cz>
	<20101004180346.59b10af7@endymion.delvare>
	<20101004223020.GA14702@sepie.suse.cz>
	<20101005100349.73914574@endymion.delvare>
	<20101005155631.GA9399@sepie.suse.cz>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On Tue, 5 Oct 2010 17:56:31 +0200, Michal Marek wrote:
> On Tue, Oct 05, 2010 at 10:03:49AM +0200, Jean Delvare wrote:
> > Hmm, too bad. What about the following then? It's nor exactly elegant,
> > but if it works for you...
> > 
> > ---
> >  drivers/i2c/Kconfig       |    3 ++-
> >  drivers/i2c/algos/Kconfig |   13 +++++++++++++
> >  2 files changed, 15 insertions(+), 1 deletion(-)
> > 
> > --- linux-2.6.36-rc6.orig/drivers/i2c/algos/Kconfig	2010-10-05 09:01:34.000000000 +0200
> > +++ linux-2.6.36-rc6/drivers/i2c/algos/Kconfig	2010-10-05 09:40:40.000000000 +0200
> > @@ -15,3 +15,16 @@ config I2C_ALGOPCA
> >  	tristate "I2C PCA 9564 interfaces"
> >  
> >  endmenu
> > +
> > +# In automatic configuration mode, we still have to define the
> > +# symbols to avoid unmet dependencies.
> > +
> > +if I2C_HELPER_AUTO
> > +config I2C_ALGOBIT
> > +	tristate
> > +config I2C_ALGOPCF
> > +	tristate
> > +config I2C_ALGOPCA
> > +	tristate
> > +endif
> > +
> > --- linux-2.6.36-rc6.orig/drivers/i2c/Kconfig	2010-10-05 09:01:34.000000000 +0200
> > +++ linux-2.6.36-rc6/drivers/i2c/Kconfig	2010-10-05 09:04:57.000000000 +0200
> > @@ -75,7 +75,8 @@ config I2C_HELPER_AUTO
> >  	  In doubt, say Y.
> >  
> >  config I2C_SMBUS
> > -	tristate "SMBus-specific protocols" if !I2C_HELPER_AUTO
> > +	tristate
> > +	prompt "SMBus-specific protocols" if !I2C_HELPER_AUTO
> 
> This works for me, thanks!
> 
> Acked-by: Michal Marek <mmarek@suse.cz>

OK, I've applied this patch. I doubt I can get it in Linus' tree before
2.6.36 is release though, my previous pull request wasn't even
acknowledged yet.

Then we will have to discuss about a better solution with Roman Zippel,
because what we have now is all but elegant. Will you start the
discussion, or should I?

-- 
Jean Delvare
