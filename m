Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab1HHM2h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 08:28:37 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11535 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab1HHM2g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 08:28:36 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 08 Aug 2011 05:28:35 -0700
From: Danny Huang <dahuang@nvidia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "lrg@ti.com" <lrg@ti.com>, "mike@compulab.co.il" <mike@compulab.co.il>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Xin Xie <xxie@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 8 Aug 2011 20:28:30 +0800
Subject: RE: [PATCH] regulator: tps6586x: add SMx slew rate setting
Thread-Topic: [PATCH] regulator: tps6586x: add SMx slew rate setting
Thread-Index: AcxVrskVDJeoqhR5TxqOvq4U1Qv1wQAEtQcQ
Message-ID: <1BA5D2DFD2730747A2B3725B59933B93C07A475743@HKMAIL01.nvidia.com>
References: <1312457662-4490-1-git-send-email-dahuang@nvidia.com>
 <20110804121237.GA9959@opensource.wolfsonmicro.com>
 <1BA5D2DFD2730747A2B3725B59933B93C07A47561C@HKMAIL01.nvidia.com>
 <20110808093703.GC12376@opensource.wolfsonmicro.com>
In-Reply-To: <20110808093703.GC12376@opensource.wolfsonmicro.com>
Accept-Language: zh-TW, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-TW, en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown, Sent: Monday, August 08, 2011 17:37
> On Fri, Aug 05, 2011 at 07:51:15PM +0800, Danny Huang wrote:
> > Thanks for the feedback.
> > The reason for using driver_data is that I can't find a proper field in
> regulator_init_data for the slew rate setting.
> > I'll do some correction based on the feedback and try to add a new field for
> the slew rate setting.
> 
> No, this is OK - we should really rename the driver_data field, it's
> very misleading.  However:
> 
> > +       return tps6586x_write(parent, reg, setting->slew_rate);
> 
> what happens if the user sets zero for the slew rate (eg, if another
> field is added to the platform data that they want to set)?  Is this a
> sane setting (like the chip default) or might it break something?

Zero is a valid setting for the regulator but not the default setting.
The default setting is 0x07.
This might affect the system stability under some particular condition.
I thought that users should pick a proper setting before init.

