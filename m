Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab2KZBCJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 20:02:09 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:51942 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726Ab2KZBCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 20:02:08 -0500
Date: Mon, 26 Nov 2012 10:02:05 +0900
From: Simon Horman <horms@verge.net.au>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Subject: Re: [PATCH 11/42] ARM: shmobile: Register PFC platform device
Message-ID: <20121126010205.GF20490@verge.net.au>
References: <1353464863-10281-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1353464863-10281-12-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <20121121051633.GF6570@verge.net.au>
 <1633136.U5nCbqepA4@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1633136.U5nCbqepA4@avalon>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 01:43:15PM +0100, Laurent Pinchart wrote:
> Hi Simon,
> 
> On Wednesday 21 November 2012 14:16:33 Simon Horman wrote:
> > On Wed, Nov 21, 2012 at 03:27:12AM +0100, Laurent Pinchart wrote:
> > > Add arch code to register the PFC platform device instead of calling the
> > > driver directly. Platform device registration in the sh-pfc driver will
> > > be removed.
> > 
> > I'm not really sure that I understand the motivation for
> > moving platform device registration from the driver into
> > mach-shmobile. Could you explain this a little?
> 
> Sure.
> 
> The traditional device model associates a driver with a device. For historical 
> reasons mach-shmobile doesn't define and register a platform device for PFC 
> hardware but calls an initialization function directly in the PFC driver, 
> passing it what is essentially platform data, including resources.
> 
> The PFC driver needs a struct device to pass to the pinctrl subsystem. As no 
> struct device corresponding to the hardware is created by mach-shmobile, the 
> driver creates one, registers it and registers itself as a platform driver. 
> The probe function is thus called synchronously, with a valid struct 
> platform_device.
> 
> This is a hack that can't support device tree based instantiation, as the 
> platform device will be created when the platform is populated from the DT in 
> that case. To support DT (and to remove the hack), I've moved platform device 
> registration to mach-shmobile as it should be, like already done for all (or 
> most, I haven't checked if there's no similar hacks in other drivers) the 
> platform devices. This allows converting a board to DT by just adding the PFC 
> device node in the DT and removing the platform device registration call in 
> board code.
> 
> I hope this made the intend of this part of the patch series clear. If not, 
> just tell me and I'll try to provide more explanations.

Thanks Laurent,

as it happens I was doing some work on pinmux and DT in as part of
my kzm9g series, so what you describe above now makes a lot of sense to me.

For this and all the other shmobile patches in this series:

Acked-by: Simon Horman <horms@verge.net.au>


BTW, my kzm9g work is not intended to conflict with your work in any way
and I apologise if it does. I was just trying to make something quickly to
allow kzm9g DT work to move a little further forward. I very much welcome
your work in this area and naturally the kzm9g will use it once it is ready.

