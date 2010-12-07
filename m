Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415Ab0LGMGm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 07:06:42 -0500
Received: from mga01.intel.com ([192.55.52.88]:62204 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142Ab0LGMGk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 07:06:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,310,1288594800"; 
   d="scan'208";a="633923112"
From: "Dong, Chuanxiao" <chuanxiao.dong@intel.com>
To: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "adrian.hunter@nokia.com" <adrian.hunter@nokia.com>,
        "Mai, Leonard" <leonard.mai@intel.com>,
        Wolfram Sang <w.sang@pengutronix.de>
Date: Tue, 7 Dec 2010 20:06:15 +0800
Subject: RE: [PATVH v3 0/3]mmc: set a suitable max_discard_sectors value for
 HC
Thread-Topic: [PATVH v3 0/3]mmc: set a suitable max_discard_sectors value
 for HC
Thread-Index: AcuSFCMEeiFz76HAQk6kl9WpC5YQ5AD8lW4g
Message-ID: <5D8008F58939784290FAB48F54975198320B3E4E71@shsmsx502.ccr.corp.intel.com>
References: <20101202112526.GA10358@intel.com>
In-Reply-To: <20101202112526.GA10358@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-puzzleid: {41E84D29-90A5-48A2-B923-CF67EA393E12}
x-cr-hashedpuzzle: KKx2 LheH clQb c/p9 gRgP hhDe rNkF r2d5 t7J4 5y7e
 AAwXDw== ABZdcQ== ABgHCA== AC58Hw== AFHCyg==
 AH2DXQ==;8;YQBkAHIAaQBhAG4ALgBoAHUAbgB0AGUAcgBAAG4AbwBrAGkAYQAuAGMAbwBtADsAYQBrAHAAbQBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGEAbABhAG4AQABsAGkAbgB1AHgALgBpAG4AdABlAGwALgBjAG8AbQA7AGEAcgBqAGEAbgBAAGwAaQBuAHUAeAAuAGkAbgB0AGUAbAAuAGMAbwBtADsAYwBqAGIAQABsAGEAcAB0AG8AcAAuAG8AcgBnADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AGwAaQBuAHUAeAAtAG0AbQBjAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwB3AC4AcwBhAG4AZwBAAHAAZQBuAGcAdQB0AHIAbwBuAGkAeAAuAGQAZQA=;Sosha1_v1;7;{41E84D29-90A5-48A2-B923-CF67EA393E12};YwBoAHUAYQBuAHgAaQBhAG8ALgBkAG8AbgBnAEAAaQBuAHQAZQBsAC4AYwBvAG0A;Tue,
 07 Dec 2010 12:06:15
 GMT;UgBFADoAIABbAFAAQQBUAFYASAAgAHYAMwAgADAALwAzAF0AbQBtAGMAOgAgAHMAZQB0ACAAYQAgAHMAdQBpAHQAYQBiAGwAZQAgAG0AYQB4AF8AZABpAHMAYwBhAHIAZABfAHMAZQBjAHQAbwByAHMAIAB2AGEAbAB1AGUAIABmAG8AcgAgAEgAQwA=
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
Can these patches be accepted? My SDHCI host controller really needs these patches to use Trim/Erase feature.
If anyone has concern about these patches, do please let me know and I would like to fix them. Thanks.

> -----Original Message-----
> From: linux-mmc-owner@vger.kernel.org
> [mailto:linux-mmc-owner@vger.kernel.org] On Behalf Of Chuanxiao Dong
> Sent: Thursday, December 02, 2010 7:25 PM
> To: linux-mmc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; cjb@laptop.org; arjan@linux.intel.com;
> alan@linux.intel.com; akpm@linux-foundation.org; adrian.hunter@nokia.com
> Subject: [PATVH v3 0/3]mmc: set a suitable max_discard_sectors value for HC
> 
> Hi,
> 	This is the version 3 patch which set a suitable max_discard_sectors
> 	value for SDHCI host controller. In this patch, a new quirk is added for
> 	such controller.
> 
> 	max_discard_sectors is a parameter of MMC driver request queue. This
> 	value can limit how many sectors will be passed down to host for
> 	erasing. The original value for this parameter is UINT_MAX which means
> 	there is no limitation for the count of sectors to pass down for
> 	erasing.
> 
> 	But some SDHCI host controller cannot erase too many sectors at one
> 	time. It may generate a timeout interrupt since the time erasing used is
> 	longer than the timeout time host can wait.
> 
> 	So these patches add a new quirk for such SDHCI host controller and let
> 	it erase only signle eraseblock each time. This will be safe for such
> 	SDHCI host to use.
> 
> 	patch1: add a new quirk for SDHCI host controller. Also add a new
> 	routine mmc_set_discard_limit which is used to set max_discard_sectors
> 	value for such SDHCI host controller.
> 	patch2: set timeout control register for such SDHCI host controller.
> 	patch3: add this quirk for MFLD SDHCI host controller.
> 
> 	Change-log:
> 	patch1: let mmc_set_discard_limit can return value UINT_MAX.
> 	patch2: no change.
> 	patch3: no change.
> 
> Thanks
> Chuanxiao
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
