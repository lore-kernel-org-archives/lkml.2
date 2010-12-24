Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595Ab0LXLiM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 06:38:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:37574 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180Ab0LXLiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 06:38:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,223,1291622400"; 
   d="scan'208";a="690460273"
Date: Fri, 24 Dec 2010 12:38:06 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>, myungjoo.ham@gmail.com
Subject: Re: [PATCH v3 2/4] MFD MAX8998/LP3974: Support LP3974 RTC
Message-ID: <20101224113805.GI27832@sortiz-mobl>
References: <1293094419-24221-1-git-send-email-myungjoo.ham@samsung.com>
 <1293094419-24221-3-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293094419-24221-3-git-send-email-myungjoo.ham@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi MyungJoo,

On Thu, Dec 23, 2010 at 05:53:37PM +0900, MyungJoo Ham wrote:
> The first releases of LP3974 have a large delay in RTC registers,
> which requires 2 seconds of delay after writing to a rtc register
> (recommended by National Semiconductor's engineers)
> before reading it. If the device name is "lp3974-regerr", the rtc driver
> assumes that such delays are required. If the device name is "lp3974",
> the rtc driver does not. Although we have not seen LP3974s without
> requiring such delays, we assume that such LP3974s will be released
> soon (or they have done so already) and they are supported by "lp3974".
> 
> This patch adds delays with msleep when writing values to RTC registers
> if the device name is "lp3974-regerr".
As Mark pointed out, I'd prefer to add a regerr flag to the driver platform
data and decide which cell to add from there.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
