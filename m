Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab1DSIM6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 04:12:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49149 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751490Ab1DSIM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 04:12:56 -0400
Date: Tue, 19 Apr 2011 09:13:04 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Haojian Zhuang <hzhuang1@marvell.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "johnpol@2ka.mipt.ru" <johnpol@2ka.mipt.ru>,
        "cbou@mail.ru" <cbou@mail.ru>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>
Subject: Re: [PATCH 14/14] regulator: 88pm8607: avoid to use constraint name
 in driver
Message-ID: <20110419081303.GD16357@opensource.wolfsonmicro.com>
References: <1303135451-26362-15-git-send-email-haojian.zhuang@marvell.com>
 <20110418143044.GF2466@opensource.wolfsonmicro.com>
 <BANLkTi=EFdzNN5GYNbGn+B8H=13C6W7s3A@mail.gmail.com>
 <20110418160247.GF1765@opensource.wolfsonmicro.com>
 <25B60CDC2F704E4E9D88FFD52780CB4C05CF05B425@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25B60CDC2F704E4E9D88FFD52780CB4C05CF05B425@SC-VEXCH1.marvell.com>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 07:45:06PM -0700, Haojian Zhuang wrote:

> >I assume that by "platform driver" you mean the machine driver for the
> >system?  What I'm saying is that instead of using a string to match it'd
> >be more normal to use an enum in the driver header, that way if someone
> >typos the string or something then there will be a build failure whereas
> >with strings like this there will only be a runtime failure.

> It's nearly same whatever it's string or index number. In machine driver,
> it's more convenient on using string. Otherwise, I still need to create

You're saying it's more convenient but you're not saying why.  I'd say
that the lack of build time checking I mentioned is actually unhelpful.

> a new integer array to store index since I transfer them into regulator data
> by driver_data parameter in regulator_init_data.

You already need to add a char * to store the name, adding an enum
instead isn't a substantial difference...
