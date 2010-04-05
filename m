Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756445Ab0DEUzK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 16:55:10 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:35211 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756266Ab0DEUzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 16:55:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=APLZciC/hZSje1+9gO8b7QqBFaj7rd+I9b4tZz1f83fHDEOd+4dG96dxWhdRwYHpZ6
         FayF4R5yGSQkc1D1WZ0ROxzH1t/XzaAUmmIn0EjIhh1xOVXtvHyawAiWI3tX0kdm4Mux
         xKSyVzDADIRdgWKCNUh3dnwngTiwBhSA73MMg=
Date: Mon, 5 Apr 2010 13:54:56 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>, power@bughost.org,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: A few questions and issues with dynticks, NOHZ and powertop
Message-ID: <20100405205455.GB4576@core.coreip.homeip.net>
References: <20100403223328.GA4507@comet.dominikbrodowski.net>
 <20100403235326.GA23445@core.coreip.homeip.net>
 <20100404103515.GA4962@comet.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100404103515.GA4962@comet.dominikbrodowski.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 04, 2010 at 12:35:15PM +0200, Dominik Brodowski wrote:
> Hi Dmitry,
> 
> On Sat, Apr 03, 2010 at 04:53:26PM -0700, Dmitry Torokhov wrote:
> > On Sun, Apr 04, 2010 at 12:33:28AM +0200, Dominik Brodowski wrote:
> > > 
> > > 4) SynPS/2 touchpad: 
> > > Why does moving the touchpad lead to sooo many IRQs? I can't look as fast
> > > as the mouse pointer seems to get new data:
> > >   62,5% (473,1)       <interrupt> : PS/2 keyboard/mouse/touchpad 
> > > 
> > 
> > 80 pps @ 6 bytes/packet = 480 interrupts/sec.
> > 
> > You can try using psmouse.rate=40 to limit it to 40 pps which should
> > bring it to the rate of standard PS/2 mouse at the expense of
> > sensitivity...
> 
> Excellent. Maybe this could be added to the Tips&Tricks section at the
> Powertop website?
> 

Do not see the point - the touchpad does not generate interrupts while
you are not touching it and while you are touching it the machine is not
going to sleep. The only reason I see for lowering the rate is if your
keyboard contrioller can not handle it (some Toshibas couldn't).

> I guess obtaining all 6 bytes at once is not really possible?

No. i8042 is byte-oriented.

> It
> seems a new byte only appears ~1.75 ms after the last one, at least on my
> notebook, so waiting for this is not an option...
> 
> Best,
> 	Dominik
> 
> 
> PS: Dmitry, got something small for you in return:

Thanks, will apply.
> 
> 
> [PATCH] i8042: spelling fix
> 
> Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
> 
> diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
> index 9302ba0..f61233e 100644
> --- a/drivers/input/serio/i8042.c
> +++ b/drivers/input/serio/i8042.c
> @@ -38,7 +38,7 @@ MODULE_PARM_DESC(noaux, "Do not probe or use AUX (mouse) port.");
>  
>  static bool i8042_nomux;
>  module_param_named(nomux, i8042_nomux, bool, 0);
> -MODULE_PARM_DESC(nomux, "Do not check whether an active multiplexing conrtoller is present.");
> +MODULE_PARM_DESC(nomux, "Do not check whether an active multiplexing controller is present.");
>  
>  static bool i8042_unlock;
>  module_param_named(unlock, i8042_unlock, bool, 0);

-- 
Dmitry
