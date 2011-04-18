Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab1DRQC6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 12:02:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48294 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755433Ab1DRQCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 12:02:50 -0400
Date: Mon, 18 Apr 2011 17:02:47 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
        a.zummo@towertech.it, johnpol@2ka.mipt.ru, cbou@mail.ru,
        dwmw2@infradead.org, lrg@slimlogic.co.uk
Subject: Re: [PATCH 14/14] regulator: 88pm8607: avoid to use constraint
 name in driver
Message-ID: <20110418160247.GF1765@opensource.wolfsonmicro.com>
References: <1303135451-26362-15-git-send-email-haojian.zhuang@marvell.com>
 <20110418143044.GF2466@opensource.wolfsonmicro.com>
 <BANLkTi=EFdzNN5GYNbGn+B8H=13C6W7s3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=EFdzNN5GYNbGn+B8H=13C6W7s3A@mail.gmail.com>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 11:38:00PM +0800, Haojian Zhuang wrote:
> On Mon, Apr 18, 2011 at 10:30 PM, Mark Brown

> > Why not just use #defines in the header?  It'd be less error prone if
> > nothing else.

> I don't understand this. desc.name is assigned in regulator driver.
> pdata->driver_data is assigned in platform driver. I need to use same
> name to link them together.

I assume that by "platform driver" you mean the machine driver for the
system?  What I'm saying is that instead of using a string to match it'd
be more normal to use an enum in the driver header, that way if someone
typos the string or something then there will be a build failure whereas
with strings like this there will only be a runtime failure.

Part of the problem here is that your changelogs aren't really saying
why you're making these changes...
