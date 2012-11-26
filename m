Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab2KZLy6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 06:54:58 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7017 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab2KZLy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 06:54:56 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 26 Nov 2012 03:50:00 -0800
From: Alex Courbot <acourbot@nvidia.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Alexandre Courbot <gnurou@gmail.com>,
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
Subject: Re: [PATCHv9 1/3] Runtime Interpreted Power Sequences
Date: Mon, 26 Nov 2012 20:49:53 +0900
Message-ID: <3319894.UD2L7QhyVv@percival>
Organization: NVIDIA
User-Agent: KMail/4.9.3 (Linux/3.6.7-1-ARCH; KDE/4.9.3; x86_64; ; )
In-Reply-To: <20121122214021.GA14771@avionic-0098.adnet.avionic-design.de>
References: <1353149747-31871-1-git-send-email-acourbot@nvidia.com> <20121122133941.24B883E129E@localhost> <20121122214021.GA14771@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 November 2012 05:40:21 Thierry Reding wrote:
> On Thu, Nov 22, 2012 at 01:39:41PM +0000, Grant Likely wrote:
> [...]
> 
> > I do think that each sequence should be contained within a single
> > property, but I'm open to other suggestions.
> 
> IIRC a very early prototype did implement something like that. However
> because of the resource issues this had to be string based, so that the
> sequences looked somewhat like (Alex, correct me if I'm wrong):
> 
> 	power-on = <"REGULATOR", "power", 1, "GPIO", "enable", 1>;

You're right. Back when the burning sun of July was beating down a little bit 
too hard on my head.

https://lkml.org/lkml/2012/7/9/30

> Instead we could possibly have something like:
> 
> 	power-on = <0 &reg 1,
> 		    1 &gpio 42 0 1>;
> 
> Where the first cell in each entry defines the type (0 = regulator, 1 =
> GPIO) and the rest would be a regular OF specifier for the given type of
> resource along with some defined parameter such as enable/disable,
> voltage, delay in ms, ... I don't know if that sounds any better. It
> looks sort of cryptic but it is more "in the spirit of" DT, right Grant?
> 
> Writing this down, it seems to me like even that proposal was already
> discussed at some point. Again, Alex may remember better.

The idea that we had was to use preprocessor support in DTC to use macros 
instead of strings for the step type. We also thought about using phandles 
directly in there as well, but this would require some more API support.

Anyway, at the current point we are not even sure whether we want or need 
power seqs in the DT - so let's keep this topic on hold for a while. We can 
still introduce the feature without DT support, and if it eventually turns out 
during this winter that expressing power seqs in the DT makes sense, we will 
have plenty of archives to read in front of the fire.

Alex.

