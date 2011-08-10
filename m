Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab1HJSAr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 14:00:47 -0400
Received: from mga14.intel.com ([143.182.124.37]:3606 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754233Ab1HJSAp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 14:00:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="37147057"
From: "Mansoor, Illyas" <illyas.mansoor@intel.com>
To: "Liu, ShuoX" <shuox.liu@intel.com>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
CC: "Brown, Len" <len.brown@intel.com>,
        "Yanmin_zhang@linux.intel.com" <Yanmin_zhang@linux.intel.com>,
        Greg KH <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 10 Aug 2011 23:30:40 +0530
Subject: RE: [linux-pm] [PATCH v4] PM: add statistics debugfs file for
 suspend	to ram
Thread-Topic: [linux-pm] [PATCH v4] PM: add statistics debugfs file for
 suspend	to ram
Thread-Index: AcxXLyrpsr9S3QfeQOC8mVTWKF9jRQAV9fTg
Message-ID: <EB6073F1DF78F9439DFDCC701BC6466007B36A0CCE@bgsmsx502.gar.corp.intel.com>
References: <6E3BC7F7C9A4BF4286DD4C043110F30B5B847F42F9@shsmsx502.ccr.corp.intel.com>
In-Reply-To: <6E3BC7F7C9A4BF4286DD4C043110F30B5B847F42F9@shsmsx502.ccr.corp.intel.com>
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

> +struct suspend_stats suspend_stats;
>  static DEFINE_MUTEX(dpm_list_mtx);
>  static pm_message_t pm_transition;
> 
> @@ -464,8 +465,12 @@ void dpm_resume_noirq(pm_message_t state)
>  		mutex_unlock(&dpm_list_mtx);
> 
>  		error = device_resume_noirq(dev, state);
> -		if (error)
> +		if (error) {
> +			suspend_stats.failed_resume_noirq++;
> +			dpm_save_failed_step(SUSPEND_RESUME_NOIRQ);
> +			dpm_save_failed_dev(dev_name(dev));

Please make these statistics conditionally enabled, so on a production system
If we need to disable these statistics code we should be able to do so.

May be CONFIG_SUSPEND_STATS and convert those lines of code into function calls
That can be stubbed out when the config is not enabled.

-Illyas
