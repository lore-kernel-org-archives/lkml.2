Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776Ab2ADGTW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 01:19:22 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6530 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321Ab2ADGTT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 01:19:19 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 03 Jan 2012 22:19:19 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Laxman Dewangan <ldewangan.com@nvidia.com>
CC: "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Wed, 4 Jan 2012 11:49:14 +0530
Subject: RE: [PATCH] regulator: Rail is said to be enable only if this and
 supply rails are enabled.
Thread-Topic: [PATCH] regulator: Rail is said to be enable only if this and
 supply rails are enabled.
Thread-Index: AczKVJaJw9khZvZ+SaOhlZZPetEHKgAUZeVA
Message-ID: <96C9D994977DD0439FB6D3FE3B13DD907DBD3A9C2E@BGMAIL01.nvidia.com>
References: <1325570983-3700-1-git-send-email-ldewangan@nvidia.com>
 <20120103201624.GC2843@opensource.wolfsonmicro.com>
In-Reply-To: <20120103201624.GC2843@opensource.wolfsonmicro.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> Sent: Wednesday, January 04, 2012 1:46 AM +0530
> >
> > The given rail is said to be enabled only if this rail is eanbled
> > along with supply rail.
> > Adding check for the supply rail whether it is enabled or not when
> > query about rail enabled.
> 
> This feels wrong - the code in general assumes that the parents will all
> be enabled for an enabled child (and does the required stuff on enable
> and disable).  Doing the check isn't unreasonable but if it fails we
> really ought to be complaining loudly as we're probably confused and
> things might be going wrong elsewhere.
>
Yes, in general checking of the parent rail is not really required but it is
good to have on safer side because it directly checks at the interface of
regulator level rather than the ref count and give the more correct results.

I came to this issue when I set the supply regulator for a rail and set the rail
is always on but the supply regulator was not always on. And so this function
returns true but actually the rail is not enabled because supply rail was not enabled.
Although it is fixed in other patch but such checks help more.

> We should also look at the bootstrapping code, we're not really making
> much effort to verify that the hardware configuration on boot is sane
> (though realistically it's unlikely that it won't be).
> 
> > Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> > ---
> > When consumer of any rails query about whether rail is enabled
> > or not, the function regulator_is_enabled() should return enabled
> > only if this rail and supply rail (both) are enabled.
> > if any one of rail, whether the given rail or supply rail, is enabled
> > then function should return as not enabled.
> 
> Please just put things in the changelog if they're useful.

I already send the 2nd patch for putting this info on changelog.

Thanks,
Laxman
