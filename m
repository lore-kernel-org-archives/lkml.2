Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab1JQPvt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 11:51:49 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11172 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756315Ab1JQPvr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 11:51:47 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 17 Oct 2011 08:51:12 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Shawn Guo <shawn.guo@freescale.com>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stijn Devriendt <highguy@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>
Date: Mon, 17 Oct 2011 08:51:11 -0700
Subject: RE: pinctrl_config APIs, and other pinmux questions
Thread-Topic: pinctrl_config APIs, and other pinmux questions
Thread-Index: AcyK5scuuBqZRimpTqGMm2qhVtXn+gB/EzOA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173BE1A4B1@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF173BE1A166@HQMAIL01.nvidia.com>
 <20111014145900.GA28728@S2100-06.ap.freescale.net>
 <74CDBE0F657A3D45AFBB94109FB122FF173BE1A275@HQMAIL01.nvidia.com>
 <20111015031215.GA29039@S2100-06.ap.freescale.net>
In-Reply-To: <20111015031215.GA29039@S2100-06.ap.freescale.net>
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

Shawn Guo wrote at Friday, October 14, 2011 9:12 PM:
> On Fri, Oct 14, 2011 at 08:53:33AM -0700, Stephen Warren wrote:
...
> > Having the driver expose a list of all possible combinations of pin
> > configurations seems impractical, for the same reason as I objected to
> > the original proposal for how the driver listed functions; there are
> > simply far too many pin config parameters and legal value to list the
> > entire set of combinations.
> >
> I did not mean to list the entire set of combinations.  For given
> function, the applicable number of config should be very limited.
> For most cases, it could be just one.  For imx6q usdhc example, it's
> 3, for 50M, 100M and 200M SD bus clock cases.

Shawn,

Are you talking about entries in the (board-specific) mapping table, which
I agree would contain the useful subset of combinations of options, or a
list of possible settings exposed by the SoC driver, which would have to
expose all possibilities, or they wouldn't be available for the mapping
table to select from?

In the case of "a list of possible settings exposed by the SoC driver",

* If such a list (of combinations) were to exist, I think it'd need to
include all combinations (the cross-product of all individual config
params) in general.

* I can certainly imagine that for some SoCs, or for a particular device
on a SoC, or for a particular board, only a subset of those would be useful,
and hence a limited set would be useful. However, that selection is up to
the board mapping table not the SoC driver in general.

* In Tegra's case at least, I think a number of the numeric values (e.g.
pull strength with range 0..31) may be for board calibration, and besides
that, most combinations of param values would be useful in some case, and
hence we'd always have to expose everything, in order to allow the board
mapping table to be able to pick anything the designer needed.

* As such, I think the SoC driver should at most list the legal range for
each param individually, and let the board-specific mapping table choose
the combination(s) required.

-- 
nvpublic

