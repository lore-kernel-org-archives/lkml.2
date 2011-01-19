Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab1ASJE6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 04:04:58 -0500
Received: from mga11.intel.com ([192.55.52.93]:60754 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753069Ab1ASJE4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 04:04:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,343,1291622400"; 
   d="scan'208";a="878812648"
From: "Dong, Chuanxiao" <chuanxiao.dong@intel.com>
To: "Tardy, Pierre" <pierre.tardy@intel.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cjb@laptop.org" <cjb@laptop.org>, "ohad@wizery.com" <ohad@wizery.com>
Date: Wed, 19 Jan 2011 17:04:18 +0800
Subject: RE: [PATCH v1 1/3]mmc: implemented runtime pm for mmc host
Thread-Topic: [PATCH v1 1/3]mmc: implemented runtime pm for mmc host
Thread-Index: AcuzxUMTTjCRN6kDQo+D/jJpKwzH1gCb6uFAACqFtKAAE6N1oAAicLyw
Message-ID: <5D8008F58939784290FAB48F5497519835247E72AD@shsmsx502.ccr.corp.intel.com>
References: <20110114082310.GB27523@intel.com>
 <8250E4885F9967469CAC3FB5CBA2CE69934E7AA2FE@irsmsx501.ger.corp.intel.com>
 <5D8008F58939784290FAB48F54975198351D4FA654@shsmsx502.ccr.corp.intel.com>
 <8250E4885F9967469CAC3FB5CBA2CE69934E7AAB20@irsmsx501.ger.corp.intel.com>
In-Reply-To: <8250E4885F9967469CAC3FB5CBA2CE69934E7AAB20@irsmsx501.ger.corp.intel.com>
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

Hi Pierre,
I think the runtime pm should not have any dependency with clock gating. Even the MMC driver won't clock gate SD/MMC card, host controller should still enter runtime suspend state, right?
So if auto suspended delay could be changed by user, then we can use pm_suspend_schedule to specify the latency which is longer than 8 clock cycle.

Thanks
Chuanxiao
> -----Original Message-----
> From: Tardy, Pierre
> Sent: Wednesday, January 19, 2011 12:39 AM
> To: Dong, Chuanxiao; linux-mmc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; cjb@laptop.org; ohad@wizery.com
> Subject: RE: [PATCH v1 1/3]mmc: implemented runtime pm for mmc host
> 
> > > I'm also worried about this patch not taking in account the 8 clock cycles before
> > > shutting down the clock, contrary to the clock gating fw.
> > > If you power down hc, you will also gate the clock. So the sdio protocol might not
> be
> > > strictly followed.
> > As mmc spec said, 8 clock cycles is needed. That is right.
> > But I think if we have set the auto suspended delay for host, runtime pm core
> could make sure host to
> > wait at least the auto suspended delay before shutting down the power of the
> device. So if the auto
> > suspended delay is longer than 8 clock cycles, the mmc protocol can be followed,
> right?
> I disagree. You cannot enforce this. It depends on clock speed, that can vary with
> sdio cards.
> User can change the autosuspend delay to whatever he wants, it should just
> change performance, but not functionality.
> 
> Why don't you just take my clock gating version?
> Its working well, I'm using this for 2 weeks, and follow the linux-mmc latest
> improvement.
> 
> Regards,
> Pierre
> 

