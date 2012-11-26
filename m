Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614Ab2KZQmO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 11:42:14 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40950 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab2KZQmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 11:42:10 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCHv9 1/3] Runtime Interpreted Power Sequences
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Alex Courbot <acourbot@nvidia.com>, Alexandre Courbot <gnurou@gmail.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mark Zhang <markz@nvidia.com>, Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <20121122214021.GA14771@avionic-0098.adnet.avionic-design.de>
References: <1353149747-31871-1-git-send-email-acourbot@nvidia.com> <1353149747-31871-2-git-send-email-acourbot@nvidia.com> <20121120215429.B621F3E1821@localhost> <13540495.epaCf4JVn9@percival> <20121122133941.24B883E129E@localhost> <20121122214021.GA14771@avionic-0098.adnet.avionic-design.de>
Date: Mon, 26 Nov 2012 15:34:53 +0000
Message-Id: <20121126153453.2AA023E1AAA@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Nov 2012 22:40:21 +0100, Thierry Reding <thierry.reding@avionic-design.de> wrote:
> On Thu, Nov 22, 2012 at 01:39:41PM +0000, Grant Likely wrote:
> [...]
> > I do think that each sequence should be contained within a single
> > property, but I'm open to other suggestions.
> 
> IIRC a very early prototype did implement something like that. However
> because of the resource issues this had to be string based, so that the
> sequences looked somewhat like (Alex, correct me if I'm wrong):
> 
> 	power-on = <"REGULATOR", "power", 1, "GPIO", "enable", 1>;
> 
> Instead we could possibly have something like:
> 
> 	power-on = <0 &reg 1,
> 		    1 &gpio 42 0 1>;

Yes, that would work, although I still think it would be a good idea to
split the used resources off into the gpios/pwms/regs/etc properties.

> Where the first cell in each entry defines the type (0 = regulator, 1 =
> GPIO) and the rest would be a regular OF specifier for the given type of
> resource along with some defined parameter such as enable/disable,
> voltage, delay in ms, ... I don't know if that sounds any better. It
> looks sort of cryptic but it is more "in the spirit of" DT, right Grant?

It is still kind of a ham-handed approach, but it does fit better with
existing conventions than the hierarchy of nodes does.

g.
