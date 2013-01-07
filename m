Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662Ab3AGHrz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 02:47:55 -0500
Received: from mga01.intel.com ([192.55.52.88]:8874 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098Ab3AGHrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 02:47:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,422,1355126400"; 
   d="scan'208";a="273683097"
Subject: Re: [PATCH] SPI: SSP SPI Controller driver v3
From: channing <chao.bi@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        sylvain.centelles@intel.com, ken.k.mills@intel.com,
        jun.d.chen@intel.com, alan@linux.intel.com
In-Reply-To: <CACRpkdaw7Yc0OetPWK7Cv=JsVPOs6b1Tr-=4jE5Vz4oTD6f07Q@mail.gmail.com>
References: <1355818296.11831.287.camel@bichao>
	 <20121219095616.GV2261@intel.com>
	 <CACRpkdaw7Yc0OetPWK7Cv=JsVPOs6b1Tr-=4jE5Vz4oTD6f07Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Jan 2013 16:05:43 +0800
Message-ID: <1357545943.28451.9.camel@bichao>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-07 at 00:36 +0100, Linus Walleij wrote:
> On Wed, Dec 19, 2012 at 10:56 AM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> > On Tue, Dec 18, 2012 at 04:11:36PM +0800, chao bi wrote:
> >>
> >> This patch is to implement SSP SPI controller driver, which has been applied and
> >> validated on intel Moorestown & Medfield platform. The patch are originated by
> >> Ken Mills <ken.k.mills@intel.com> and Sylvain Centelles <sylvain.centelles@intel.com>,
> >> migrating to lateset Linux mainline SPI framework by Channing <chao.bi@intel.com>
> >> and Chen Jun <jun.d.chen@intel.com> according to their integration & validation
> >> on Medfield platform.
> >
> > This is the same IP block as used in PXA, right? With few modifications
> > here and there. Is there a reason not to use spi-pxa2xx.c?
> 
> This needs to be investigated. Two drivers for the same or closely related
> hardware block is never a good sign...
> 
> Yours,
> Linus Walleij

Dear Linus ,Mika and Grant,

Thanks for your remind.

Frankly I'm currently not sure whether they share same IP.. per your reminds, I tried to find but get 
limited info about PXA SSP's IP, from the code, looks like they have part of registers the same. 

As far as I know, spi-pxa2xx.c is specific for SSP controller of PXA2XX/PXA3XX core, right? While Medfield 
platform is embedded with ATOM core, the SSP driver we upload is validated on SSP controller of ATOM. In my 
view, they're specific for different AP & Platforms, if compare the 2 files, there are still many difference 
in how they works, if to choose a driver for Intel Medfild/Moorestown platform, I believe spi-intel-mid-ssp.c 
driver could be a more mature solution. 

What do you think? please correct me if I'm mistaken.

-chao

