Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab0K3HXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 02:23:48 -0500
Received: from mga02.intel.com ([134.134.136.20]:48136 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753716Ab0K3HXq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 02:23:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,279,1288594800"; 
   d="scan'208";a="682261817"
From: "Dong, Chuanxiao" <chuanxiao.dong@intel.com>
To: "cjb@laptop.org" <cjb@laptop.org>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Date: Tue, 30 Nov 2010 15:21:15 +0800
Subject: RE: [PATCH v2 0/3]mmc: set a suitable max_discard_sectors value for
 HC
Thread-Topic: [PATCH v2 0/3]mmc: set a suitable max_discard_sectors value
 for HC
Thread-Index: AcuG/1GS3DNVRxWlTHOgij/8obLNFgJWNIxQ
Message-ID: <5D8008F58939784290FAB48F54975198313E0F4220@shsmsx502.ccr.corp.intel.com>
References: <20101118085951.GA18161@intel.com>
In-Reply-To: <20101118085951.GA18161@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-puzzleid: {3518DE2B-9CA8-45BF-9618-242C28DE4476}
x-cr-hashedpuzzle: DdkA FITy GoaO LMqC O0uy S3Qv VM2u hc2Q h4Cz taUm xOXu
 xOv+ yY+6 z8jk 1rPe
 9Gbr;6;YQBrAHAAbQBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGEAbABhAG4AQABsAGkAbgB1AHgALgBpAG4AdABlAGwALgBjAG8AbQA7AGEAcgBqAGEAbgBAAGwAaQBuAHUAeAAuAGkAbgB0AGUAbAAuAGMAbwBtADsAYwBqAGIAQABsAGEAcAB0AG8AcAAuAG8AcgBnADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AGwAaQBuAHUAeAAtAG0AbQBjAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcA;Sosha1_v1;7;{3518DE2B-9CA8-45BF-9618-242C28DE4476};YwBoAHUAYQBuAHgAaQBhAG8ALgBkAG8AbgBnAEAAaQBuAHQAZQBsAC4AYwBvAG0A;Tue,
 30 Nov 2010 07:21:15
 GMT;UgBFADoAIABbAFAAQQBUAEMASAAgAHYAMgAgADAALwAzAF0AbQBtAGMAOgAgAHMAZQB0ACAAYQAgAHMAdQBpAHQAYQBiAGwAZQAgAG0AYQB4AF8AZABpAHMAYwBhAHIAZABfAHMAZQBjAHQAbwByAHMAIAB2AGEAbAB1AGUAIABmAG8AcgAgAEgAQwA=
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,
I have submitted several patches to this mail list since Oct.25, but didn't get any response.
Do you have any plan to review them? I would like to fix all of them if you have concern about them.

Below are my patches, but no response got from each since the first submission.
1. eMMC4.4 hardware reset feature, the first submission was at Oct.25. Last patch list:
https://patchwork.kernel.org/patch/334931/
https://patchwork.kernel.org/patch/334941/
2. eMMC4.4 enhanced area feature, the first submission was at Oct.26. Last patch list:
https://patchwork.kernel.org/patch/282052/
3. usage of eMMC trim. This submission is a workaround for some sdhci host controller which cannot erase the whole device at one time. The first submission was at Nov.11. Last patch list:
https://patchwork.kernel.org/patch/335361/
https://patchwork.kernel.org/patch/335381/
https://patchwork.kernel.org/patch/335411/

I expect any comment from all of you.

Thanks
Chuanxiao

> -----Original Message-----
> From: linux-mmc-owner@vger.kernel.org
> [mailto:linux-mmc-owner@vger.kernel.org] On Behalf Of Chuanxiao Dong
> Sent: Thursday, November 18, 2010 5:00 PM
> To: cjb@laptop.org
> Cc: linux-mmc@vger.kernel.org; linux-kernel@vger.kernel.org;
> alan@linux.intel.com; arjan@linux.intel.com
> Subject: [PATCH v2 0/3]mmc: set a suitable max_discard_sectors value for HC
> 
> Hello Chris,
> 	  These are the version 2 patches of setting a suitable
> 	  max_discard_sectors value for sdhci host controller.
> 
> 	  The max_discard_sectors determines how many sectors will be passed
> 	  down to host controller for erasing. The default value is UNIT_MAX
> 	  which means the block layer can pass down unlimited sectors one time
> 	  to host controller. But for some kinds of SDHCI host controller, like
> 	  MFLD SDHCI host controller cannot erase so many sectors one time. It
> 	  will generate a timeout interrupt since the erasing time is longer
> 	  than the host controller waiting timeout time. This should be a
> 	  hardware architecture issue.
> 
> 	  So in these patches, add a new quirk to work around this. The new
> 	  quirk can help host controllers to set a safe max_discard_sectors value
> 	  for them.
> 
> 	  patch1: Add a new quirk for SDHCI host controller and a new mmc
> 	  capability which will help mmc core layer to set a suitable
> 	  max_discard_sectors value for it.
> 
> 	  patch2: Set the sdhci host controller timeout value to be the maximum
> 	  one for each erase command. This will be safe for this kind of SDHCI
> 	  host controller.
> 
> 	  patch3: Add the new quirk to MFLD SDHCI host controller.
> 
> Thanks
> Chuanxiao
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
