Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab1HHNdD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 09:33:03 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40515 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751692Ab1HHNdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 09:33:02 -0400
Date: Mon, 8 Aug 2011 14:32:59 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Danny Huang <dahuang@nvidia.com>
Cc: "lrg@ti.com" <lrg@ti.com>, "mike@compulab.co.il" <mike@compulab.co.il>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Xin Xie <xxie@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: tps6586x: add SMx slew rate setting
Message-ID: <20110808133259.GA5719@opensource.wolfsonmicro.com>
References: <1312457662-4490-1-git-send-email-dahuang@nvidia.com> <20110804121237.GA9959@opensource.wolfsonmicro.com> <1BA5D2DFD2730747A2B3725B59933B93C07A47561C@HKMAIL01.nvidia.com> <20110808093703.GC12376@opensource.wolfsonmicro.com> <1BA5D2DFD2730747A2B3725B59933B93C07A475743@HKMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1BA5D2DFD2730747A2B3725B59933B93C07A475743@HKMAIL01.nvidia.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 08, 2011 at 08:28:30PM +0800, Danny Huang wrote:

> Zero is a valid setting for the regulator but not the default setting.
> The default setting is 0x07.
> This might affect the system stability under some particular condition.
> I thought that users should pick a proper setting before init.

It'd be good to do something like make the variable wider than the
register then require that users set an out of band bit to program the
value to zero.  This would improve robustness in hte case where someone
relies on a zero initialized platform data by default.
