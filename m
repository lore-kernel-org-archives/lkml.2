Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab0I1NF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 09:05:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:6580 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753069Ab0I1NF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 09:05:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,247,1283756400"; 
   d="scan'208";a="841620498"
Date: Tue, 28 Sep 2010 15:06:11 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Hemanth V <hemanthv@ti.com>
Cc: Arun Murthy <arun.murthy@stericsson.com>, lars@metafoo.de,
        Andrew Morton <akpm@linux-foundation.org>, kernel@pengutronix.de,
        philipp.zabel@gmail.com, robert.jarzmik@free.fr, marek.vasut@gmail.com,
        eric.y.miao@gmail.com, rpurdie@rpsys.net, kgene.kim@samsung.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        STEricsson_nomadik_linux@list.st.com
Subject: Re: [PATCH 1/7] pwm: Add pwm core driver
Message-ID: <20100928130610.GB20749@sortiz-mobl>
References: <1285670134-18063-1-git-send-email-arun.murthy@stericsson.com>
 <1285670134-18063-2-git-send-email-arun.murthy@stericsson.com>
 <040c01cb5f0c$29bcb3b0$LocalHost@wipblrx0099946>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <040c01cb5f0c$29bcb3b0$LocalHost@wipblrx0099946>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 06:23:24PM +0530, Hemanth V wrote:
> ----- Original Message ----- From: "Arun Murthy"
> <arun.murthy@stericsson.com>
> 
> 
> >The existing pwm based led and backlight driver makes use of the
> >pwm(include/linux/pwm.h). So all the board specific pwm drivers will
> >be exposing the same set of function name as in include/linux/pwm.h.
> >As a result build fails in case of multi soc environments where each soc
> >has a pwm device in it.
> 
> This seems very specific to ST environment,  
No it's not. It's an issue Arun has hit while enabling one of the ST MFD chip,
but he's tackling a generic issue.

> looking at the driver list from
> ( [PATCH 4/7] pwm: Align existing pwm drivers with pwm-core ) it seems
> most multi SOC environments might support PWM in either one of the SOC.
> 
> arch/arm/plat-mxc/pwm.c
> arch/arm/plat-pxa/pwm.c
> arch/arm/plat-samsung/pwm.c
> arch/mips/jz4740/pwm.c
> drivers/mfd/twl6030-pwm.c
> 
> Unless people have examples of other SOCs which might use this,
> the better approach might be to go for a custom driver rather than changing
> the framework.
I wouldn't call the current pwm code a framework. It's a bunch of header
definitions that happens to work in the specific case of 1 pwm per
sub architecture.
What Arun is proposing is an actual framework. And it seems to be clean and
simple enough.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
