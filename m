Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308Ab1HHJhS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 05:37:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60528 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751847Ab1HHJhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 05:37:13 -0400
Date: Mon, 8 Aug 2011 18:37:05 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Danny Huang <dahuang@nvidia.com>
Cc: "lrg@ti.com" <lrg@ti.com>, "mike@compulab.co.il" <mike@compulab.co.il>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Xin Xie <xxie@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: tps6586x: add SMx slew rate setting
Message-ID: <20110808093703.GC12376@opensource.wolfsonmicro.com>
References: <1312457662-4490-1-git-send-email-dahuang@nvidia.com>
 <20110804121237.GA9959@opensource.wolfsonmicro.com>
 <1BA5D2DFD2730747A2B3725B59933B93C07A47561C@HKMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1BA5D2DFD2730747A2B3725B59933B93C07A47561C@HKMAIL01.nvidia.com>
X-Cookie: You will have long and healthy life.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 07:51:15PM +0800, Danny Huang wrote:
> Thanks for the feedback.
> The reason for using driver_data is that I can't find a proper field in regulator_init_data for the slew rate setting.
> I'll do some correction based on the feedback and try to add a new field for the slew rate setting.

No, this is OK - we should really rename the driver_data field, it's
very misleading.  However:

> +       return tps6586x_write(parent, reg, setting->slew_rate);

what happens if the user sets zero for the slew rate (eg, if another
field is added to the platform data that they want to set)?  Is this a
sane setting (like the chip default) or might it break something?
