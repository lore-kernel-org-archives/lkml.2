Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab1HZQQl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 12:16:41 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63552 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab1HZQQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 12:16:38 -0400
Date: Fri, 26 Aug 2011 17:16:33 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Jamie Iles <jamie@jamieiles.com>, Grant Likely <grant.likely@secretlab.ca>,
        Colin Cross <ccross@android.com>, Erik Gilling <konkers@android.com>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Belisko Marek <marek.belisko@gmail.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v3 11/13] of: add property iteration helpers
Message-ID: <20110826161633.GB2802@pulham.picochip.com>
References: <1314315824-9687-1-git-send-email-swarren@nvidia.com>
 <1314315824-9687-12-git-send-email-swarren@nvidia.com>
 <20110826092632.GB3926@pulham.picochip.com>
 <74CDBE0F657A3D45AFBB94109FB122FF04B24A40C8@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF04B24A40C8@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 08:59:44AM -0700, Stephen Warren wrote:
> Jamie Iles wrote at Friday, August 26, 2011 3:27 AM:
> > For the !CONFIG_OF case, I *think* that
> > of_iter_u32_prop and of_iter_string_prop can be empty struct's, but I
> > wouldn't want to bet money on that!
> 
> Empty structs themselves certainly did compile OK, but the code that
> uses these macros references iter.value directly, and isn't under #ifdef
> CONFIG_OF, so that field has to exist.
> 
> I suppose an alternative would be to add an accessor function:
> 
> struct of_iter_string_prop iter;
> for_each_string_property_value(iter, np, "pins")
>         printk("Got value %s\n", of_iter_string_value(iter));
> 
> which would return NULL/"" when !CONFIG_OF, and hence allow iter.value
> to be removed too. Do you think that's a good approach? It'd be easy to
> implement.

I think I prefer what you have now rather than a separate accessor, but 
I'm happy either way!

Jamie
