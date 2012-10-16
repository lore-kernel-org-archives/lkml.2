Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab2JPVIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 17:08:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:34284 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753935Ab2JPVIX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 17:08:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,595,1344236400"; 
   d="scan'208";a="235983273"
From: "Keller, Jacob E" <jacob.e.keller@intel.com>
To: David Miller <davem@davemloft.net>,
        "bhutchings@solarflare.com" <bhutchings@solarflare.com>
CC: "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "haicheng.li@linux.intel.com" <haicheng.li@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tshimizu818@gmail.com" <tshimizu818@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "haicheng.lee@gmail.com" <haicheng.lee@gmail.com>
Subject: RE: [PATCH 1/2] Fix build error caused by broken PCH_PTP module
 dependency.
Thread-Topic: [PATCH 1/2] Fix build error caused by broken PCH_PTP module
 dependency.
Thread-Index: AQHNmrQfHjagKXbftEK+cknyb+YM0ZefOYcAgACPDoCAAAFLgIAAAycAgAeO0wCAAUTPAIAAMdoAgBQhtoCAAAI1gP//mD3Q
Date: Tue, 16 Oct 2012 21:08:20 +0000
Message-ID: <02874ECE860811409154E81DA85FBB5830C157F1@ORSMSX105.amr.corp.intel.com>
References: <1349300710.2763.8.camel@bwh-desktop.uk.solarflarecom.com>
	<20121003.204336.1981040659629176119.davem@davemloft.net>
	<1350418167.2649.47.camel@bwh-desktop.uk.solarflarecom.com>
 <20121016.161721.460693104731176775.davem@davemloft.net>
In-Reply-To: <20121016.161721.460693104731176775.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: netdev-owner@vger.kernel.org [mailto:netdev-owner@vger.kernel.org]
> On Behalf Of David Miller
> Sent: Tuesday, October 16, 2012 1:17 PM
> To: bhutchings@solarflare.com
> Cc: richardcochran@gmail.com; haicheng.li@linux.intel.com;
> netdev@vger.kernel.org; tshimizu818@gmail.com; linux-
> kernel@vger.kernel.org; haicheng.lee@gmail.com
> Subject: Re: [PATCH 1/2] Fix build error caused by broken PCH_PTP module
> dependency.
> 
> From: Ben Hutchings <bhutchings@solarflare.com>
> Date: Tue, 16 Oct 2012 21:09:27 +0100
> 
> > I think the various kconfig options should be changed as follows:
> >
> > 1. Only PTP_1588_CLOCK selects PPS.
> > 2. Nothing depends on EXPERIMENTAL.  (This stuff has been in for 18
> >    months and it's even being backported to RHEL 6 now.)
> > 3. Either:
> >    (a) The per-driver PHC options select nothing, and the driver options
> >        do e.g.:
> > 	select PTP_1588_CLOCK if IGB_PTP
> >    (b) The per-driver PHC options are removed and the driver options do:
> > 	select PTP_1588_CLOCK
> >        (i.e. PHC support is unconditional)
> >
> > Any objections to this, or preference for (a) vs (b)?
> 
> No objections, prefer (b).

No objections here, I also prefer (b). The feature shouldn't have much impact unless enabled via hwtstamp_ioctl, and it drastically reduces requirement on end-user needing to enable PHC support.

- Jake

> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
