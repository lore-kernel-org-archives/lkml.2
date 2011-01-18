Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541Ab1ARLhO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 06:37:14 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55257 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750745Ab1ARLhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 06:37:12 -0500
Date: Tue, 18 Jan 2011 11:37:10 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>, myungjoo.ham@gmail.com
Subject: Re: [PATCH v5] MFD MAX8998/LP3974: Support Charger
Message-ID: <20110118113709.GD26498@opensource.wolfsonmicro.com>
References: <20110104135651.GD24774@opensource.wolfsonmicro.com>
 <1294982579-10404-1-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294982579-10404-1-git-send-email-myungjoo.ham@samsung.com>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 02:22:59PM +0900, MyungJoo Ham wrote:
> With the new regulator, "CHARGER", users can control charging
> current and turn on and off the charger. Note that the charger
> specification of LP3974 is different from that of MAX8998.
> 
> driver/power/max8998.c supports power supply APIs for
> 
> 1. "ONLINE" monitors the charger status, which can be
> different from the status "CHARGER"; e.g., users allowed the charger
> to charge, but the MAX8998 chip decided not to do so.
> 
> 2. "PRESENT" monitors the battery status (the existence of the
> battery).
> 
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

My major concern here is still that the regulator and power drivers
aren't connected at all - it feels like either the regulator driver is
redundant or the power driver ought to be a consumer of the regulator
driver.
