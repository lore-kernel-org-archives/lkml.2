Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564Ab1HNHYl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 03:24:41 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:36121 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab1HNHYi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 03:24:38 -0400
MIME-Version: 1.0
X-Originating-IP: [81.235.222.155]
In-Reply-To: <1313189697-21287-7-git-send-email-swarren@nvidia.com>
References: <1313189697-21287-1-git-send-email-swarren@nvidia.com>
	<1313189697-21287-7-git-send-email-swarren@nvidia.com>
Date: Sun, 14 Aug 2011 00:24:37 -0700
Message-ID: <CAOesGMheuUfSe1uUA6LxZ71V0-DR3XX7bEJqhVxJ-ZqrWWa1bA@mail.gmail.com>
Subject: Re: [RFC PATCH 06/12] arm/dt: Tegra: Add pinmux node
From: Olof Johansson <olof@lixom.net>
To: Stephen Warren <swarren@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        devicetree-discuss@lists.ozlabs.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Aug 12, 2011 at 3:54 PM, Stephen Warren <swarren@nvidia.com> wrote:
> Add a pinmux node to tegra20.dtsi in order to instantiate the future
> pinmux device. Add pinmux nodes to Harmony and Seaboard, which detail
> the entire default pinmux configuration. This configuration is identical
> to that in board-harmony/seaboard-pinmux.c.

Again, documentation for the binding is needed.

Seeing the table coded up now though, I wonder if it could make sense
to flip it around? The number of functions multiplexed out are fewer
than the pin groups (and this would be even more true on platforms
that have per-pin configurations and/or smaller groups).

I.e. something like:

    sdio4 {
            nvidia,pingroups = < DTA DTD >; // Not sure how to
reference this though -- integers would be hard to read. DTA/DTD
aren't valid values in the syntax.
            nvidia,pull-up
    },

And any pingroups not covered by a function would be left alone (one
could easily define a few no-op functions to set pull up/down and
tristate values on the unused groups).

[...]

> +       pinmux: pinmux@70000000 {
> +               ATA {

I would prefer seeing these in lower case (since device tree tends to
be no-caps). Should be easy to switch to strcasecmp in the code.

[...]
> +               CDEV2 {
> +                       nvidia,function = "PLLP_OUT4";

The string here is a bit unfortunate. It's really just used to map
from the string to an integer anyway, with the reverse mapping being
produced by the debugfs output. But especially if the function is
flipped above, the different pingroups referenced might not use the
same value for each function, so some sort of lookup will still be
needed. Not much to do about, it seems. :(


> +                       nvidia,pull = "down";

This should be done by discrete properties instead: nvidia,pull-up,
nvidia-pull-down (and omitted means normal), without values.


-Olof
