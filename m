Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030600Ab2GLKy4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 06:54:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:10758 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933711Ab2GLKyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 06:54:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="191683222"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: Wei Ni <wni@nvidia.com>, "Zhang, Rui" <rui.zhang@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "joe@perches.com" <joe@perches.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@ger.kernel.org" <linux-tegra@ger.kernel.org>,
        "acourbot@nvidia.com" <acourbot@nvidia.com>
Subject: RE: How to use the generic thermal sysfs.
Thread-Topic: How to use the generic thermal sysfs.
Thread-Index: AQHNYBhwfglBqKFiaEq9VEEbCoJV25cld52Q
Date: Thu, 12 Jul 2012 10:54:01 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB5915287C@BGSMSX101.gar.corp.intel.com>
References: <1342088573.27605.101.camel@tegra-chromium-2>
In-Reply-To: <1342088573.27605.101.camel@tegra-chromium-2>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q6CAt2Uk005799

Hi,

> -----Original Message-----
> From: Wei Ni [mailto:wni@nvidia.com]
> Sent: Thursday, July 12, 2012 3:53 PM
> To: Zhang, Rui; Brown, Len; akpm@linux-foundation.org; khali@linux-fr.org;
> joe@perches.com; R, Durgadoss
> Cc: linux-kernel@vger.kernel.org; linux-tegra@ger.kernel.org;
> acourbot@nvidia.com
> Subject: How to use the generic thermal sysfs.
> 
> Hi, all
> I'm working on the tegra thermal throttling upstream issue.
> The tegra30 board use the nct1008 as the thermal sensor, and the lm90 is
> the sensor driver. We want to use the generic thermal sysfs.
> 
> My question is where should we register the thermal zone device? We may
> have two place to do it:
> 1. register it in the sensor driver, such as lm90.c
> In this way, the sensor driver doesn't need to export any APIs, such as
> get_temp.

This approach is preferred.

> 2. register in my tegra thermal framework.
> In this way, the sensor driver need to export some APIs, which are used
> to register the ops and do any other things.

What do you mean by "my tegra thermal framework" ? Where does the source
file for this sit in the mainline kernel ?

> 
> How should I do it?
> 
> And in current codes, there have the event notification, in the form of
> a netlink event. But it's difficult to be used in the kernel, it's
> normally for the communication with user-space. How about to add a
> notify call chain for it? So when the sensor has irq alert, it can send
> a notify to my thermal framework in kernel.

We are working on a notification API from any generic sensor driver to
the thermal framework.
Please have a look at the 'notify_thermal_framework' API in the patch here:
http://www.spinics.net/lists/linux-acpi/msg36049.html

Thanks,
Durga

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
