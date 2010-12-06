Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477Ab0LFLc1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 06:32:27 -0500
Received: from mga11.intel.com ([192.55.52.93]:61179 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393Ab0LFLcZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 06:32:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,305,1288594800"; 
   d="scan'208";a="864935801"
From: "Dong, Chuanxiao" <chuanxiao.dong@intel.com>
To: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "kmpark@infradead.org" <kmpark@infradead.org>,
        "Mai, Leonard" <leonard.mai@intel.com>
Date: Mon, 6 Dec 2010 19:32:05 +0800
Subject: RE: [PATCH v2 0/4]enable Background operations and HPI feature for
	eMMC4.41 card
Thread-Topic: [PATCH v2 0/4]enable Background operations and HPI feature for
	eMMC4.41 card
Thread-Index: AcuS4/mTsy2A7jH9Rbunc5ihbp68VgCVONRQ
Message-ID: <5D8008F58939784290FAB48F54975198320B3E49EC@shsmsx502.ccr.corp.intel.com>
References: <20101203121315.GA18655@intel.com>
In-Reply-To: <20101203121315.GA18655@intel.com>
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
I have updated the HW reset feature patch to be version4, but no one has given me any comment....
Does any want to review these patches?

> -----Original Message-----
> From: linux-mmc-owner@vger.kernel.org
> [mailto:linux-mmc-owner@vger.kernel.org] On Behalf Of Chuanxiao Dong
> Sent: Friday, December 03, 2010 8:13 PM
> To: linux-mmc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; cjb@laptop.org; akpm@linux-foundation.org;
> arjan@linux.intel.com; alan@linux.intel.com; kmpark@infradead.org
> Subject: [PATCH v2 0/4]enable Background operations and HPI feature for
> eMMC4.41 card
> 
> Hi,
> 	This is the version 2 patch to enable background operations and HPI
> 	feature for eMMC4.41 card. Both of these two features are optional.
> 
> 	Background operations can be started when user request queue is idle. So
> 	each time user start to handle a new request, driver should check
> 	whether the card is doing BKOPS. If so, should wait until BKOPS is done
> 	or use a HPI command to interrupt it if eMMC card support HPI. The
> 	serial patches were designed as this work flow.
> 
> 	This version patch only use HPI to interrupt background operation,
> 	didnot implement to interrupt foreground operations.
> 
> 	patch1: enable background operations feature for supported eMMC card.
> 	patch2: start to do background operations when user request queue is
> 	idle. Check whether card is doing BKOPS when start a new user request.
> 	patch3: enable HPI for supported eMMC card.
> 	patch4: use HPI command to interrupt BKOPS.
> 
> 	change-log:
> 
> 	patch2: remove the added workqueue in the version 1 patch. This
> 	workqueue is used to put card in runtime suspend state. Since current
> 	MMC driver has not a runtime power management in card block layer, just
> 	remove this workqueue. Define erro response to be macro
> R1_ERROR_RESPONSE
> 
> 	patch3: fixed community comment. Thanks for Kyungmin Park.
> 
> Thanks
> Chuanxiao
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
