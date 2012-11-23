Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab2KWKlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 05:41:47 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39406 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab2KWKlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 05:41:45 -0500
Date: Fri, 23 Nov 2012 10:41:40 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linus.walleij@linaro.org, grant.likely@secretlab.ca,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Vipul Kumar Samar <vipulkumar.samar@st.com>
Subject: Re: [PATCH] gpio: stmpe: Add DT support for stmpe gpio
Message-ID: <20121123104140.GP17471@gmail.com>
References: <912d88b8906ce87cf5459cf3d5798e03bfce34c7.1353649737.git.viresh.kumar@linaro.org>
 <20121123103400.GO17471@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121123103400.GO17471@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  static struct mfd_cell stmpe_gpio_cell = {
> >  	.name		= "stmpe-gpio",
> > +	.of_compatible	= "st,stmpe-gpio",
> 
> There's no need for any of the STMPE to have their own compatible
> string, as they are MFD devices. They are registered as platform
> devices from the MFD subsystem.

Whoops, I've written this in the wrong place. 

Sorry, for the confusion. It does need to be here.

> >  	.resources	= stmpe_gpio_resources,
> >  	.num_resources	= ARRAY_SIZE(stmpe_gpio_resources),
> >  };
> >  
> >  static struct mfd_cell stmpe_gpio_cell_noirq = {
> >  	.name		= "stmpe-gpio",
> > +	.of_compatible	= "st,stmpe-gpio",

... and here.

> > +++ b/Documentation/devicetree/bindings/gpio/gpio-stmpe.txt
> > @@ -0,0 +1,18 @@
> > +STMPE gpio
> > +----------
> > +
> > +Required properties:
> > + - compatible: "st,stmpe-gpio"

... but this is wrong.

> > +Example:
> > +	stmpe_gpio {
> > +		compatible = "st,stmpe-gpio";
> > +		st,norequest-mask = <0x20>;	//gpio 5 can't be used
> > +	};

As is the example.

So will be the the DT - if you've already written it.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
