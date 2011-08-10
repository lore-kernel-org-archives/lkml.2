Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab1HJTxD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 15:53:03 -0400
Received: from mga03.intel.com ([143.182.124.21]:39179 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058Ab1HJTxC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 15:53:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="37181018"
From: "Mansoor, Illyas" <illyas.mansoor@intel.com>
To: Greg KH <gregkh@suse.de>
CC: "Liu, ShuoX" <shuox.liu@intel.com>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>,
        "Yanmin_zhang@linux.intel.com" <Yanmin_zhang@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 11 Aug 2011 01:22:56 +0530
Subject: RE: [linux-pm] [PATCH v4] PM: add statistics debugfs file for
 suspend	to ram
Thread-Topic: [linux-pm] [PATCH v4] PM: add statistics debugfs file for
 suspend	to ram
Thread-Index: AcxXliqCqs30fg3TTgiUmvFgYauvpwAAH3VA
Message-ID: <EB6073F1DF78F9439DFDCC701BC6466007B36A0D12@bgsmsx502.gar.corp.intel.com>
References: <6E3BC7F7C9A4BF4286DD4C043110F30B5B847F42F9@shsmsx502.ccr.corp.intel.com>
 <EB6073F1DF78F9439DFDCC701BC6466007B36A0CCE@bgsmsx502.gar.corp.intel.com>
 <20110810194529.GA5590@suse.de>
In-Reply-To: <20110810194529.GA5590@suse.de>
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

static pm_message_t pm_transition;
> > >
> > > @@ -464,8 +465,12 @@ void dpm_resume_noirq(pm_message_t state)
> > >  		mutex_unlock(&dpm_list_mtx);
> > >
> > >  		error = device_resume_noirq(dev, state);
> > > -		if (error)
> > > +		if (error) {
> > > +			suspend_stats.failed_resume_noirq++;
> > > +			dpm_save_failed_step(SUSPEND_RESUME_NOIRQ);
> > > +			dpm_save_failed_dev(dev_name(dev));
> >
> > Please make these statistics conditionally enabled, so on a production system
> > If we need to disable these statistics code we should be able to do so.
> 
> Why, are they taking time or space that is needed for something else?
> What's the downside here of just not always having this enabled?

Why have something that is not required/Used?
Its only useful if DEBUGFS is configured anyways

-Illyas
