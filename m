Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab2JAKWf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 06:22:35 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43609 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab2JAKWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 06:22:33 -0400
Date: Mon, 1 Oct 2012 11:22:28 +0100
From: Lee Jones <lee.jones@linaro.org>
To: "Rajanikanth H.V" <rajanikanth.hv@stericsson.com>
Cc: francescolavra.fl@gmail.com, arnd@arndb.de, anton.vorontsov@linaro.org,
        linus.walleij@stericsson.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, STEricsson_nomadik_linux@list.st.com
Subject: Re: [PATCH 1/4] mfd: ab8500: add devicetree support for fuelgauge
Message-ID: <20121001102228.GD6682@gmail.com>
References: <1349064513-31301-1-git-send-email-rajanikanth.hv@stericsson.com>
 <1349064513-31301-2-git-send-email-rajanikanth.hv@stericsson.com>
 <20121001094929.GB6682@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121001094929.GB6682@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, some mistakes:

> > From: "Rajanikanth H.V" <rajanikanth.hv@stericsson.com>
> > 
> > - This patch adds device tree support for fuelguage driver
> > - optimize bm devices platform_data usage and of_probe(...)
> >   Note: of_probe() routine for battery managed devices is made
> >   common across all bm drivers.

Spelling errors in here.

> > +		dev_err(dev, "invalid battery-info node\n");
> > +		return -EINVAL;
> > +	}
> > +	if (of_property_read_bool(np_bat_supply,
> > +			"thermistor-on-batctrl") == false){
> 
> Replace with: 
>         if (of_get_property(np_bat_supply, "thermistor-on-batctr", NULL))
> 	        np_bat_supply =  true;

This should be: 

         if (of_get_property(np_bat_supply, "thermistor-on-batctr", NULL))
 	        thermistor = NTC_INTERNAL;
         else
                thermistor = NTC_EXTERNAL;

> <remove>
> 
> > +		dev_warn(dev, "missing property thermistor-on-batctrl\n");
> > +		thermistor = NTC_EXTERNAL;
> > +	}
> 
> </remove>

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
