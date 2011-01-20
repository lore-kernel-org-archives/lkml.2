Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab1ATB6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 20:58:53 -0500
Received: from ebb05.tieto.com ([131.207.168.36]:53937 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400Ab1ATB6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 20:58:52 -0500
X-AuditID: 83cfa824-b7b13ae000000ee5-13-4d3796da8f90
Date: Thu, 20 Jan 2011 10:06:38 +0800
From: Yang Ruirui <ruirui.r.yang@tieto.com>
To: Felipe Balbi <balbi@ti.com>
CC: Yang Ruirui R <ruirui.r.yang@tietoenator.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Felipe Balbi <felipe.balbi@nokia.com>,
        Heikki Krogerus <ext-heikki.krogerus@nokia.com>,
        Tejun Heo <tj@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Hema HK <hemahk@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb otg: use atomic notifier instead of blocking notifier
Message-ID: <20110120020638.GA24396@darkstar>
References: <20110119092011.GA23624@darkstar>
 <20110119104032.GJ2505@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110119104032.GJ2505@legolas.emea.dhcp.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 12:40:32PM +0200, Felipe Balbi wrote:
> hi,
> 
> On Wed, Jan 19, 2011 at 05:20:11PM +0800, Yang Ruirui wrote:
> > 
> > following bug happens with meego 2.6.35 kernel on nokia n900:
> 
> <snip>
> 
> > Actually the blocking notifier chain runs in process context, so not fit for use here.
> > 
> > For mainline kernel there's such issue as well.
> > Here fix this problem by changing to use atomic_notifier.
> > 
> > Signed-off-by: Yang Ruirui <ruirui.r.yang@tieto.com>
> > ---
> >  drivers/usb/otg/ab8500-usb.c  |    6 +++---
> >  drivers/usb/otg/twl4030-usb.c |    6 +++---
> >  drivers/usb/otg/twl6030-usb.c |    6 +++---
> 
> you're missing the other transceivers:
> drivers/usb/otg/langwell_otg.c
> drivers/usb/otg/msm72k_otg.c
> drivers/usb/otg/gpio_vbus.c
> drivers/usb/otg/nop-usb-xceiv.c
> drivers/usb/otg/ulpi.c
> drivers/usb/otg/isp1301_omap.c

Hi, thanks

Actually I does not found where notifiers are used in these files except
langwell_otg

For langwell_otg.c there's a wrapper struct named "intel mid_otg_xceiv"
in include/linux/usb/intel_mid_otg.h, it use an atomic notifier for
interrupt context.

So I think we'd better write another patch to make it use general
otg_transceiver for notifier or just keep current code. What's your opinion?

> 
> -- 
> balbi
