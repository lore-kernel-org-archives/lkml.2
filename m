Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab0LNIa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 03:30:59 -0500
Received: from mga01.intel.com ([192.55.52.88]:52377 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756382Ab0LNIa5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 03:30:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,341,1288594800"; 
   d="scan'208";a="867941669"
From: "Dong, Chuanxiao" <chuanxiao.dong@intel.com>
To: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "kmpark@infradead.org" <kmpark@infradead.org>,
        "Mai, Leonard" <leonard.mai@intel.com>
Date: Tue, 14 Dec 2010 16:30:10 +0800
Subject: RE: [PATCH v5 0/4]implement eMMC4.4 standard HW reset feature
Thread-Topic: [PATCH v5 0/4]implement eMMC4.4 standard HW reset feature
Thread-Index: AcuXnH85wEN9oVp1SCCSILYcPs0lZADyz5ZA
Message-ID: <5D8008F58939784290FAB48F5497519833732FB9F2@shsmsx502.ccr.corp.intel.com>
References: <20101209122403.GA13236@intel.com>
In-Reply-To: <20101209122403.GA13236@intel.com>
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

Hi all,
This feature can reset eMMC card when card cannot response any command.
As eMMC4.4 standard recommended, the HW reset will only be launched when card occurs timeout errors.
To make sure card can be reset, using HW reset instead of using command 0.

So if this kind of scenario occurs, these patches will be useful. Is it acceptable?

> -----Original Message-----
> From: linux-mmc-owner@vger.kernel.org
> [mailto:linux-mmc-owner@vger.kernel.org] On Behalf Of Chuanxiao Dong
> Sent: Thursday, December 09, 2010 8:24 PM
> To: linux-mmc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; akpm@linux-foundation.org; cjb@laptop.org;
> kmpark@infradead.org; Mai, Leonard
> Subject: [PATCH v5 0/4]implement eMMC4.4 standard HW reset feature
> 
> Hi,
> 	This is the version 5 of HW reset feature implementation. HW reset can
> 	reset eMMC card when card occurs a read/write/erase timeout error. It is
> 	useful when eMMC card cannot correspond any command after occurs a
> timeout
> 	error.
> 
> 	change-log:
> 	patch1: use value 5 instead to judge whether eMMC card complies eMMC4.41
> 	standard.
> 	patch4: handle erase timeout error only when there was an error occurs
> 	after erase.
> 
> 	patch1: enable HW reset capability if card support.
> 
>  	patch2: add two new callback to implement HW reset in mmc core layer. In
>  	this patch, routine mmc_handle_timeout_error was added.
> 
>  	patch3: implement hardware_reset callback for sdhci host. A new callback
>  	reset_emmc was defined which will be each sdhci host controller to
>  	implement separately.
> 
>  	patch4: did a HW reset after each read/write/erase command if need.
> 
> Thanks
> Chuanxiao
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
