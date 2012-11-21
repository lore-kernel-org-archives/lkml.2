Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab2KUMmw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 07:42:52 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:56030 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab2KUMmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 07:42:50 -0500
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
Date: Wed, 21 Nov 2012 13:43:15 +0100
Message-ID: <1633136.U5nCbqepA4@avalon>
User-Agent: KMail/4.9.2 (Linux/3.5.7-gentoo; KDE/4.9.2; x86_64; ; )
In-Reply-To: <20121121051633.GF6570@verge.net.au>
References: <1353464863-10281-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1353464863-10281-12-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <20121121051633.GF6570@verge.net.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon,

On Wednesday 21 November 2012 14:16:33 Simon Horman wrote:
> On Wed, Nov 21, 2012 at 03:27:12AM +0100, Laurent Pinchart wrote:
> > Add arch code to register the PFC platform device instead of calling the
> > driver directly. Platform device registration in the sh-pfc driver will
> > be removed.
> 
> I'm not really sure that I understand the motivation for
> moving platform device registration from the driver into
> mach-shmobile. Could you explain this a little?

Sure.

The traditional device model associates a driver with a device. For historical 
reasons mach-shmobile doesn't define and register a platform device for PFC 
hardware but calls an initialization function directly in the PFC driver, 
passing it what is essentially platform data, including resources.

The PFC driver needs a struct device to pass to the pinctrl subsystem. As no 
struct device corresponding to the hardware is created by mach-shmobile, the 
driver creates one, registers it and registers itself as a platform driver. 
The probe function is thus called synchronously, with a valid struct 
platform_device.

This is a hack that can't support device tree based instantiation, as the 
platform device will be created when the platform is populated from the DT in 
that case. To support DT (and to remove the hack), I've moved platform device 
registration to mach-shmobile as it should be, like already done for all (or 
most, I haven't checked if there's no similar hacks in other drivers) the 
platform devices. This allows converting a board to DT by just adding the PFC 
device node in the DT and removing the platform device registration call in 
board code.

I hope this made the intend of this part of the patch series clear. If not, 
just tell me and I'll try to provide more explanations.

-- 
Regards,

Laurent Pinchart

