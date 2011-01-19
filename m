Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab1ASKrB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 05:47:01 -0500
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:37981 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750984Ab1ASKrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 05:47:00 -0500
Date: Wed, 19 Jan 2011 12:40:32 +0200
From: Felipe Balbi <balbi@ti.com>
To: Yang Ruirui <ruirui.r.yang@tieto.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Felipe Balbi <felipe.balbi@nokia.com>,
        Heikki Krogerus <ext-heikki.krogerus@nokia.com>,
        Tejun Heo <tj@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Hema HK <hemahk@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb otg: use atomic notifier instead of blocking
 notifier
Message-ID: <20110119104032.GJ2505@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20110119092011.GA23624@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110119092011.GA23624@darkstar>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

On Wed, Jan 19, 2011 at 05:20:11PM +0800, Yang Ruirui wrote:
> 
> following bug happens with meego 2.6.35 kernel on nokia n900:

<snip>

> Actually the blocking notifier chain runs in process context, so not fit for use here.
> 
> For mainline kernel there's such issue as well.
> Here fix this problem by changing to use atomic_notifier.
> 
> Signed-off-by: Yang Ruirui <ruirui.r.yang@tieto.com>
> ---
>  drivers/usb/otg/ab8500-usb.c  |    6 +++---
>  drivers/usb/otg/twl4030-usb.c |    6 +++---
>  drivers/usb/otg/twl6030-usb.c |    6 +++---

you're missing the other transceivers:
drivers/usb/otg/langwell_otg.c
drivers/usb/otg/msm72k_otg.c
drivers/usb/otg/gpio_vbus.c
drivers/usb/otg/nop-usb-xceiv.c
drivers/usb/otg/ulpi.c
drivers/usb/otg/isp1301_omap.c

-- 
balbi
