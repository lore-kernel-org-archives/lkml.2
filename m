Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab1EVUAi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 16:00:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:37002 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754564Ab1EVUAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 16:00:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,252,1304319600"; 
   d="scan'208";a="440949230"
Date: Sun, 22 May 2011 22:00:27 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>, linux-kernel@vger.kernel.org,
        dmitry.torokhov@gmail.com, a.zummo@towertech.it, johnpol@2ka.mipt.ru,
        cbou@mail.ru, dwmw2@infradead.org, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 06/14] mfd: pxa-w1: MFD driver for PXA 1wire control +
 DS1WM chip
Message-ID: <20110522200026.GC18610@sortiz-mobl>
References: <1303135451-26362-7-git-send-email-haojian.zhuang@marvell.com>
 <20110426094836.GD2659@sortiz-mobl>
 <BANLkTinpFBfOEOR6Ox1ufEHZo3qwRq8zhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinpFBfOEOR6Ox1ufEHZo3qwRq8zhA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Haojian,

On Sat, May 14, 2011 at 10:21:25PM +0800, Haojian Zhuang wrote:
> On Tue, Apr 26, 2011 at 5:48 PM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> > Hi Haojian,
> >
> > On Mon, Apr 18, 2011 at 10:04:03PM +0800, Haojian Zhuang wrote:
> >> This driver provides registers and IRQ of PXA3xx chips to the ds1wm driver.
> > I see why this is needed, but I really think the ds1wm driver should be
> > converted to a regular platform device. The MFD driver below is just adding a
> > useless middle layer between your platform code and the ds1wm one.
> >
> I'm OK to use the regulator platform device for ds1wm driver except
> for one concern.
> ds1wm driver is designed for mfd cell driver. I need to update it as
> regulator platform
> driver first. cell->enable() / cell->disable() is used to enable clock
> for ds1wm driver.
> So I need to change the API from cell->enable/disable to clk_enable()
> / clk_disable().
> 
> But the key issue is that there's no common structure for clkdev. Now
> clkdev is only
> designed for deeply machine depend.
> 
> From my view is that we need a common structure for clkdev. Then mfd driver can
> get benefit from this. Some client driver can be written as regulator
> platform device.
> And mfd driver can use them seamless. What's your opinion?
I may be missing your point, but what is preventing you from calling the clock
API from drivers/w1/masters/ds1wm.c, the same way you're calling it from this
patch ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
