Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab2K0LST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 06:18:19 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:56319 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab2K0LSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 06:18:17 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Simon Horman <horms@verge.net.au>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Subject: Re: [PATCH 11/42] ARM: shmobile: Register PFC platform device
Date: Tue, 27 Nov 2012 12:19:20 +0100
Message-ID: <1839728.Q4ibxGIjKp@avalon>
User-Agent: KMail/4.9.2 (Linux/3.5.7-gentoo; KDE/4.9.2; x86_64; ; )
In-Reply-To: <20121127022628.GD13206@verge.net.au>
References: <1353464863-10281-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1893460.x7qM5g2uhe@avalon> <20121127022628.GD13206@verge.net.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon,

On Tuesday 27 November 2012 11:26:28 Simon Horman wrote:
> On Mon, Nov 26, 2012 at 11:34:36AM +0100, Laurent Pinchart wrote:
> > On Monday 26 November 2012 10:02:05 Simon Horman wrote:
> > > On Wed, Nov 21, 2012 at 01:43:15PM +0100, Laurent Pinchart wrote:
> > > > On Wednesday 21 November 2012 14:16:33 Simon Horman wrote:
> > > > > On Wed, Nov 21, 2012 at 03:27:12AM +0100, Laurent Pinchart wrote:
> > > > > > Add arch code to register the PFC platform device instead of
> > > > > > calling the driver directly. Platform device registration in the
> > > > > > sh-pfc driver will be removed.
> > > > > 
> > > > > I'm not really sure that I understand the motivation for
> > > > > moving platform device registration from the driver into
> > > > > mach-shmobile. Could you explain this a little?
> > > > 
> > > > Sure.
> > > > 
> > > > The traditional device model associates a driver with a device. For
> > > > historical reasons mach-shmobile doesn't define and register a
> > > > platform device for PFC hardware but calls an initialization function
> > > > directly in the PFC driver, passing it what is essentially platform
> > > > data, including resources.
> > > > 
> > > > The PFC driver needs a struct device to pass to the pinctrl subsystem.
> > > > As no struct device corresponding to the hardware is created by
> > > > mach-shmobile, the driver creates one, registers it and registers
> > > > itself as a platform driver. The probe function is thus called
> > > > synchronously, with a valid struct platform_device.
> > > > 
> > > > This is a hack that can't support device tree based instantiation, as
> > > > the platform device will be created when the platform is populated
> > > > from the DT in that case. To support DT (and to remove the hack), I've
> > > > moved platform device registration to mach-shmobile as it should be,
> > > > like already done for all (or most, I haven't checked if there's no
> > > > similar hacks in other drivers) the platform devices. This allows
> > > > converting a board to DT by just adding the PFC device node in the DT
> > > > and removing the platform device registration call in board code.
> > > > 
> > > > I hope this made the intend of this part of the patch series clear. If
> > > > not, just tell me and I'll try to provide more explanations.
> > > 
> > > Thanks Laurent,
> > > 
> > > as it happens I was doing some work on pinmux and DT in as part of
> > > my kzm9g series, so what you describe above now makes a lot of sense to
> > > me.
> > > 
> > > For this and all the other shmobile patches in this series:
> > > 
> > > Acked-by: Simon Horman <horms@verge.net.au>
> > 
> > Thank you. I'll post a v2 of the patch set with board patches split
> > per-SoC as requested by Magnus to make backporting easier. As the
> > shmobile will significantly change, could you send me your ack on v2 ?
> > 
> > > BTW, my kzm9g work is not intended to conflict with your work in any way
> > > and I apologise if it does. I was just trying to make something quickly
> > > to allow kzm9g DT work to move a little further forward. I very much
> > > welcome your work in this area and naturally the kzm9g will use it once
> > > it is ready.
> >
> > No worries. I'll handle the conflict. Do you plan to push it for v3.8 or
> > v3.9 ?
> 
> Its too late for 3.8, so I was thinking about 3.9.
> 
> I have rebased things on your v2 series and things seem to be working.

Great :-)

> So I'm now dependent on your pinmux work.

OK, let's push the patches for v3.9 then. I'll wait for feedback on v2 and 
will submit a v3 with OF support for pinmuxing before the end of the week.

-- 
Regards,

Laurent Pinchart

