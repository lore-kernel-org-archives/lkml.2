Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632Ab1BLKnE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 05:43:04 -0500
Received: from mga01.intel.com ([192.55.52.88]:10649 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447Ab1BLKm4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 05:42:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,461,1291622400"; 
   d="scan'208";a="657017213"
From: "Dong, Chuanxiao" <chuanxiao.dong@intel.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "adrian.hunter@nokia.com" <adrian.hunter@nokia.com>
Date: Sat, 12 Feb 2011 18:42:51 +0800
Subject: RE: [PATCH v4 1/3]mmc: set max_discard_sectors value for mmc queue
Thread-Topic: [PATCH v4 1/3]mmc: set max_discard_sectors value for mmc queue
Thread-Index: AcvKkDqgy47k/+1qTGmf7iBQ2bEiYQADPN3A
Message-ID: <5D8008F58939784290FAB48F54975198358C2EF87A@shsmsx502.ccr.corp.intel.com>
References: <20110212062214.GB25519@intel.com>
 <201102120938.16626.arnd@arndb.de>
In-Reply-To: <201102120938.16626.arnd@arndb.de>
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

> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Saturday, February 12, 2011 4:38 PM
> To: Dong, Chuanxiao
> Cc: linux-mmc@vger.kernel.org; cjb@laptop.org; linux-kernel@vger.kernel.org;
> akpm@linux-foundation.org; adrian.hunter@nokia.com
> Subject: Re: [PATCH v4 1/3]mmc: set max_discard_sectors value for mmc queue
> 
> On Saturday 12 February 2011 07:22:14 Chuanxiao Dong wrote:
> > max_discard_sectors value is UINT_MAX which means kernel block layer can pass
> > down unlimited sectors to MMC driver to erase. But erasing so many sectors may
> > delay some other important I/O requests. This is not preferred.
> >
> > So use 'pref_erase' to set a suitable max_discard_sectors value for mmc queue to
> > avoid erasing too many sectors at one time.
> >
> > Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
> 
> I'm not sure about this one. pref_erase on SDHC cards should be the *minimum*
> unit you can erase in one request, not the maximum. Erasing an arbitrary
Hi Arnd,
I found the comment in mmc_init_erase() function which explains the 'pref_erase':
'pref_erase' is defined as a guide to limit erases to that size and alignment.
So I think it is not the minimum unit driver can erase, also not the maximum erase unit. It just a guide erase size for driver which can avoid holding host controller too long to response other I/O requests.

> number of allocation units on an SDHC card should complete almost instantly,
> because it only needs to update a single table with the allocation units.
>
> Discarding partial allocation units will take a lot longer, because the
> card then has to copy over the remaining blocks.
Is discarding started when card is idle or right after erase command? Can it cause some other I/O requests delayed?

