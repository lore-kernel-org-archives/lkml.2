Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828Ab2D0HZO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 03:25:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38778 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab2D0HZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 03:25:12 -0400
Date: Fri, 27 Apr 2012 15:25:05 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Dong Aisheng <b29396@freescale.com>, b20223@freescale.com,
        linus.walleij@stericsson.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        kernel@pengutronix.de, cjb@laptop.org, s.hauer@pengutronix.de,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 2/4] pinctrl: pinctrl-imx: add imx pinctrl core driver
Message-ID: <20120427072503.GP2234@S2101-09.ap.freescale.net>
References: <1335451227-27709-1-git-send-email-b29396@freescale.com>
 <1335451227-27709-2-git-send-email-b29396@freescale.com>
 <20120426144446.GN9142@game.jcrosoft.org>
 <20120426151536.GO9142@game.jcrosoft.org>
 <20120427054842.GJ2234@S2101-09.ap.freescale.net>
 <20120427062816.GQ9142@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120427062816.GQ9142@game.jcrosoft.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 08:28:16AM +0200, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 13:48 Fri 27 Apr     , Shawn Guo wrote:
> > On Thu, Apr 26, 2012 at 05:15:36PM +0200, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > > We have on Imx mxc at91 and other SoC controler hich you configure per pin
> > > 
> > > which means one pin have multiple function and the same function is on
> > > multiple pins
> > > 
> > > so the groups are just a list of possible pins
> > > 
> > > Instead of re-inventing bindings we do need to come with a common binding whre
> > > it's possible
> > > 
> > > So instead I proppose (send in the v2) to use common way to describe the group
> > > 
> > Let's see how many nodes we will have in device tree.  For imx6q
> > example, there are 332 pins and each pin has up to 8 function selects.
> > We will end up with having 332 x 8 = 2656 sub nodes under node
> > "functions".  Device tree simply cannot afford such a bloating.
> device tree can offord it
> 
No.  Device tree maintainers has told that.  Looking into the clock DT
binding discussion, you will find that Grant does not like to have
even 100~200 nodes to represent an entire clock tree in the DT.

With your proposal (actually this has been proposed long time before),
to represent the pins for a 24bit display, it easily consumes 28 nodes
on mach-mxs, while my binding only needs one node.  So in short, the
proposal has been discussed and it's not a sensible one.

Regards,
Shawn

> except you are going to have hundereds of duplicated pinctrl configuration
> as different board will have different mux which is impossbile to maintain
> either
> 
> and I do not expect we add all the configuration possible but just the common
> one
> 
> Best Regards,
> J.
