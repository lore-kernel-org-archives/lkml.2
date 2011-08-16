Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab1HPOBf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 10:01:35 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:61115 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab1HPOBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 10:01:32 -0400
MIME-Version: 1.0
In-Reply-To: <201108161509.17157.arnd@arndb.de>
References: <1313440100-17131-1-git-send-email-swarren@nvidia.com>
	<201108161509.17157.arnd@arndb.de>
Date: Tue, 16 Aug 2011 16:01:31 +0200
Message-ID: <CACRpkdaVx=6AJ5DFjVN1ZYQ++hu9pT6WxD9n+pqmYVaCf1xawg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 00/13] arm/tegra: Initialize GPIO & pinmux from DT
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Colin Cross <ccross@android.com>, Erik Gilling <konkers@android.com>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        devicetree-discuss@lists.ozlabs.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Belisko Marek <marek.belisko@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 3:09 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> I do think that you should keep Linus Walleij on Cc in these emails, since
> he first started pushing for a common pinmux layer, and we need to make
> sure that the binding works for all SoCs, not just for tegra.

Sorry for slipping off the pinmux stuff, I will make it my goal to recap
discussion and try to post a new patchset this week.

Concepts have grown, I see Stephen have created the new concept
of e.g. bias groups which is a real good idea

One problem is that I wanted to start out small with the pinctrl
subsystem, and now it looks like it has to do a *lot* of stuff from
day 1 to be of any use ...

One specific thing worries me: Grant asked me to make sure
to NOT create a global pin number space for the pinmuxes (and thus
pinctrl). This means that in order to proceed, mappings of pinmux
groups or pincontrol (such as bias) groups, each device using such
an entity need to reference the intended pincontroller/mux instance.

Say mmc instance 0 need pingroup foo on pincontroller bar
means that there must be a specific reference from mmc.0:s
struct device * to pinctrl bar:s struct device *. Maybe this is
peanuts in DT, sorry not enough insight.

I wonder if this has bearing on how the device tree need to be
structured to be future proof? (Hopefully not.)

Yours,
Linus Walleij
