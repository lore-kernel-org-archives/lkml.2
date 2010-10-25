Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759429Ab0JYStM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 14:49:12 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38597 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380Ab0JYStK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 14:49:10 -0400
From: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
To: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>,
        "Hiroshi.DOYU@nokia.com" <Hiroshi.DOYU@nokia.com>
CC: "felipe.contreras@nokia.com" <felipe.contreras@nokia.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Mon, 25 Oct 2010 13:49:04 -0500
Subject: RE: [PATCHv5 0/4] iovmm: fixes for iovmm module
Thread-Topic: [PATCHv5 0/4] iovmm: fixes for iovmm module
Thread-Index: Act0c9afIdJ86QpkQBOgPCz/RR8CSQAAVYjQ
Message-ID: <496565EC904933469F292DDA3F1663E602F4936A90@dlee06.ent.ti.com>
References: <1288032731-541-1-git-send-email-x0095840@ti.com>
In-Reply-To: <1288032731-541-1-git-send-email-x0095840@ti.com>
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



Please discard this set of patches I will send them again with
The correct prefix (omap) to avoid confusion with other
Iommu componets.

Sorry for the noise.

Regards,
Fernando.

> -----Original Message-----
> From: Guzman Lugo, Fernando 
> Sent: Monday, October 25, 2010 1:52 PM
> To: Hiroshi.DOYU@nokia.com
> Cc: felipe.contreras@nokia.com; tony@atomide.com; 
> linux-kernel@vger.kernel.org; andy.shevchenko@gmail.com; 
> linux-omap@vger.kernel.org; Guzman Lugo, Fernando
> Subject: [PATCHv5 0/4] iovmm: fixes for iovmm module
> 
> Version 5:
> * Changes in "iommu: create new api to set valid da range"
>   - Change range variables to platform data structure.
> 
> Version 4:
> * Changes in "iommu: create new api to set valid da range"
>   - Validate range for fixed address.
>   - Change way of change boundaries to avoid possible overflow
>     instead of style :
>        start + bytes >= end     which start + end can overflow
>     use style:
>        end - start < bytes
> 
> Version 3:
> * change patch 2 base on Felipe Contreras' comments,
>   now it uses min_t and I deleted some blank lines.
> * patch "create new api to set valid da range" is base on
>   "iovmm: IVA2 MMU range is from 0x11000000 to 0xFFFFFFFF"
>   patch and on Hiroshi's comments and now it is added to
>   this set.
> 
> Version 2:
> * Removed "iovmm: fixes for iovmm module" that patch was already
>   sent.
> * Modified "iovmm: fix roundup for next area and end check for the
>   last area" patch, base on Davin Cohen's comments and rename it
>   to a proper name that describes what it is doing now.
> 
> *** BLURB HERE ***
> 
> Fernando Guzman Lugo (4):
>   iovmm: no gap checking for fixed address
>   iovmm: add superpages support to fixed da address
>   iovmm: replace __iounmap with omap_iounmap
>   iommu: create new api to set valid da range
> 
>  arch/arm/plat-omap/include/plat/iommu.h |    3 +
>  arch/arm/plat-omap/iommu.c              |   33 ++++++++++++
>  arch/arm/plat-omap/iovmm.c              |   84 
> ++++++++++++++++++-------------
>  3 files changed, 85 insertions(+), 35 deletions(-)
> 
> 