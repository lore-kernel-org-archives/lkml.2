Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab1C1ImG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 04:42:06 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:49090 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751755Ab1C1ImE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 04:42:04 -0400
Date: Mon, 28 Mar 2011 11:41:59 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: balbi@ti.com, gregkh@suse.de, linux-arm-msm@vger.kernel.org,
        ablay@codeaurora.org,
        "'open list:USB GADGET/PERIPH...'" <linux-usb@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5 v8] usb: Adding SuperSpeed support to dummy_hcd
Message-ID: <20110328084157.GH2251@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1300867372-20811-1-git-send-email-tlinder@codeaurora.org>
 <20110325134730.GO2609@legolas.emea.dhcp.ti.com>
 <000201cbec79$3a7dc4f0$af794ed0$@org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000201cbec79$3a7dc4f0$af794ed0$@org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 27, 2011 at 02:19:25PM +0200, Tanya Brokhman wrote:
> Hi
> 
> > >
> > >  MODULE_DESCRIPTION (DRIVER_DESC);
> > >  MODULE_AUTHOR ("David Brownell");
> > > @@ -220,6 +223,7 @@ static inline struct dummy *gadget_dev_to_dummy
> > (struct device *dev)
> > >  }
> > >
> > >  static struct dummy			*the_controller;
> > > +static struct dummy			*the_ss_controller;
> > 
> > the only thing I don't like, is why you splitted the ss controller to a
> > separate controller. Why don't you use the same ? From SW perspective,
> > we can treat SS and HS/FS/LS controllers as one unit.
> > 
> 
> Actually I'm not sure about that... Because SS controller handles things a
> bit differently than HS/FS/LS. For example look at set_ss_link_state(), the
> port status is reported differently than for HS/FS/LS devices.
> It could be done, I mean spare the the_ss_controller variable and use
> the_controller, and we did that at first, but later on we decided to go back
> to this implementation since the code got too complex. Since dummy_hcd.c is
> used for debugging purposes we decided that simplicity is the better
> approach here.

you can have two different functions and decide which one to call by
checking gadget->speed.

-- 
balbi
