Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab1HZQAP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 12:00:15 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16777 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556Ab1HZQAM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 12:00:12 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 26 Aug 2011 08:59:46 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Jamie Iles <jamie@jamieiles.com>
CC: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
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
Date: Fri, 26 Aug 2011 08:59:44 -0700
Subject: RE: [PATCH v3 11/13] of: add property iteration helpers
Thread-Topic: [PATCH v3 11/13] of: add property iteration helpers
Thread-Index: Acxj0kJB+Ap2QeauSLuCKjAfayWsGgANmBMA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04B24A40C8@HQMAIL01.nvidia.com>
References: <1314315824-9687-1-git-send-email-swarren@nvidia.com>
 <1314315824-9687-12-git-send-email-swarren@nvidia.com>
 <20110826092632.GB3926@pulham.picochip.com>
In-Reply-To: <20110826092632.GB3926@pulham.picochip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jamie Iles wrote at Friday, August 26, 2011 3:27 AM:
> On Thu, Aug 25, 2011 at 05:43:42PM -0600, Stephen Warren wrote:
> > This patch adds macros for_each_u32_property_value and
> > for_each_string_property_value, which iterate over an array of values
> > within a device-tree property. Usage is for example:
> >
> > struct of_iter_string_prop iter;
> > for_each_string_property_value(iter, np, "pins")
> >         printk("Got value %s\n", iter.value);
> >
> > Signed-off-by: Stephen Warren <swarren@nvidia.com>
> 
> Nicely implemented!

Thanks!

> For the !CONFIG_OF case, I *think* that
> of_iter_u32_prop and of_iter_string_prop can be empty struct's, but I
> wouldn't want to bet money on that!

Empty structs themselves certainly did compile OK, but the code that
uses these macros references iter.value directly, and isn't under #ifdef
CONFIG_OF, so that field has to exist.

I suppose an alternative would be to add an accessor function:

struct of_iter_string_prop iter;
for_each_string_property_value(iter, np, "pins")
        printk("Got value %s\n", of_iter_string_value(iter));

which would return NULL/"" when !CONFIG_OF, and hence allow iter.value
to be removed too. Do you think that's a good approach? It'd be easy to
implement.

-- 
nvpublic

