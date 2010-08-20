Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab0HTWJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 18:09:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:14179 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821Ab0HTWJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 18:09:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,242,1280732400"; 
   d="scan'208";a="598742235"
Date: Sat, 21 Aug 2010 00:09:51 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Kyungmin Park <kmpark@infradead.org>
Cc: linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        broonie@opensource.wolfsonmicro.com, jy0922.shim@samsung.com
Subject: Re: [PATCH] MFD: LP3974 PMIC support
Message-ID: <20100820220950.GL3650@sortiz-mobl>
References: <20100802035422.GA2883@july>
 <AANLkTimkd5HLs7EyCX3--VO8fyJhXCBG-KMuG9wr0ZZk@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimkd5HLs7EyCX3--VO8fyJhXCBG-KMuG9wr0ZZk@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kyungmin,

On Thu, Aug 19, 2010 at 02:08:39PM +0900, Kyungmin Park wrote:
> Any comments? I hope it's included the 2.6.36 if possible.
It hopefully will be. I received the patch after the merge window opened
though.
Some comments on your patch:

> > +config MFD_LP3974
> > +       bool "National Semiconductor LP3974 PMIC Support"
> > +       depends on I2C=y
> > +       select MFD_CORE
> > +       select MFD_MAX8998
> > +       help
> > +         Say yes here to support for National Semiconductor LP3974. This is
> > +         a Power Management IC. This driver provies common support for
> > +         accessing the device, additional drivers must be enabled in order
> > +         to use the functionality of the device.
> > +         Note that it has same functionality with max8998.
As Jonathan mentioned, there really is no need for a Kconfig symbol. Just
change the existing Kconfig comments to add your device there.


> >  config MFD_WM8400
> >        tristate "Support Wolfson Microelectronics WM8400"
> >        select MFD_CORE
> > diff --git a/drivers/mfd/max8998.c b/drivers/mfd/max8998.c
> > index 0d68de2..cea9f48 100644
> > --- a/drivers/mfd/max8998.c
> > +++ b/drivers/mfd/max8998.c
> > @@ -30,6 +30,11 @@
> >  #include <linux/mfd/max8998.h>
> >  #include <linux/mfd/max8998-private.h>
> >
> > +enum max8998_type {
> > +       TYPE_MAX8998,
> > +       TYPE_LP3974,
> > +};
Not used, so please remove that.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
