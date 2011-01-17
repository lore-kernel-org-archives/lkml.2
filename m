Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab1AQLAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 06:00:07 -0500
Received: from mga02.intel.com ([134.134.136.20]:16164 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210Ab1AQLAC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 06:00:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,332,1291622400"; 
   d="scan'208";a="697564394"
From: "Tardy, Pierre" <pierre.tardy@intel.com>
To: "Dong, Chuanxiao" <chuanxiao.dong@intel.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cjb@laptop.org" <cjb@laptop.org>, "ohad@wizery.com" <ohad@wizery.com>
Date: Mon, 17 Jan 2011 10:59:25 +0000
Subject: RE: [PATCH v1 1/3]mmc: implemented runtime pm for mmc host
Thread-Topic: [PATCH v1 1/3]mmc: implemented runtime pm for mmc host
Thread-Index: AcuzxUMTTjCRN6kDQo+D/jJpKwzH1gCb6uFA
Message-ID: <8250E4885F9967469CAC3FB5CBA2CE69934E7AA2FE@irsmsx501.ger.corp.intel.com>
References: <20110114082310.GB27523@intel.com>
In-Reply-To: <20110114082310.GB27523@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> MMC host has a sysfs interface to let user specify the auto suspended delay.
> Each slot of the host controller can have a different delay for runtime
> suspended.


>   out:
> +	/* power off host controller */
> +	pm_runtime_put(&host->class_dev);
If you want to use autosuspend feature, then you need to use the function pm_runtime_put_autosuspend().


I'm also worried about this patch not taking in account the 8 clock cycles before shutting down the clock, contrary to the clock gating fw.
If you power down hc, you will also gate the clock. So the sdio protocol might not be strictly followed.


Regards,
Pierre
---------------------------------------------------------------------
Intel Corporation SAS (French simplified joint stock company)
Registered headquarters: "Les Montalets"- 2, rue de Paris, 
92196 Meudon Cedex, France
Registration Number:  302 456 199 R.C.S. NANTERRE
Capital: 4,572,000 Euros

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

