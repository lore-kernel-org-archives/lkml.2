Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab1CNLj4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 07:39:56 -0400
Received: from mga14.intel.com ([143.182.124.37]:62849 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754114Ab1CNLjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 07:39:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,315,1297065600"; 
   d="scan'208";a="402234012"
Date: Mon, 14 Mar 2011 12:39:50 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Alessandro Zummo <a.zummo@towertech.it>, kyungmin.park@samsung.com,
        myungjoo.ham@gmail.com
Subject: Re: [PATCH v5 2/4] MAX8997/8966 PMIC Regulator Driver Initial
 Release
Message-ID: <20110314113949.GM31153@sortiz-mobl>
References: <1299810886-19684-1-git-send-email-myungjoo.ham@samsung.com>
 <1299810886-19684-3-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299810886-19684-3-git-send-email-myungjoo.ham@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi MyungJoo,

On Fri, Mar 11, 2011 at 11:34:44AM +0900, MyungJoo Ham wrote:
> This patch supports PMIC/Regulator part of MAX8997/MAX8966 MFD.
> In this initial release, selecting voltages or current-limit
> and switching on/off the regulators are supported.
> 
> Controlling voltages for DVS with GPIOs is not implemented fully
> and requires more considerations: it controls multiple bucks (selection
> of 1, 2, and 5) at the same time with SET1~3 gpios. Thus, when DVS-GPIO
> is activated, we lose the ability to control the voltage of a single
> buck regulator independently; i.e., contolling a buck affects other two
> bucks. Therefore, using the conventional regulator framework directly
> might be problematic. However, in this driver, we try to choose
> a setting without such side effect of affecting other regulators and
> then try to choose a setting with the minimum side effect (the sum of
> voltage changes in other regulators).
> 
> On the other hand, controlling all the three bucks simultenously based
> on the voltage set table may help build cpufreq and similar system
> more robust; i.e., all the three voltages are consistent every time
> without glitches during transition.
Patch applied, with Mark's ACK.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
