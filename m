Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759913Ab2CTMVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 08:21:19 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45236 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759754Ab2CTMVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 08:21:17 -0400
MIME-Version: 1.0
In-Reply-To: <1331931269-12262-5-git-send-email-swarren@wwwdotorg.org>
References: <1331931269-12262-1-git-send-email-swarren@wwwdotorg.org>
	<1331931269-12262-5-git-send-email-swarren@wwwdotorg.org>
Date: Tue, 20 Mar 2012 13:21:16 +0100
Message-ID: <CACRpkdaxVUCqm-2k0n+Mr_dB-RdxJ3=6TDb_GObTh5TD8ssqzw@mail.gmail.com>
Subject: Re: [PATCH 5/8] pinctrl: core device tree mapping table parsing support
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@stericsson.com>, B29396@freescale.com,
        s.hauer@pengutronix.de, dongas86@gmail.com, shawn.guo@linaro.org,
        thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 9:54 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> During pinctrl_get(), if the client device has a device tree node, look
> for the common pinctrl properties there. If found, parse the referenced
> device tree nodes, with the help of the pinctrl drivers, and generate
> mapping table entries from them.
>
> During pinctrl_put(), free any results of device tree parsing.
>
> Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>

Can we have it in a separate file like devicetree.[c|h] and
some stubs in the .h file for platforms that does not select
CONFIG_OF?

This:

+static int register_mappings(struct pinctrl_map const *maps, unsigned num_maps,
+                            bool dup, bool locked)

Instead of making this static, move the prototype to core.h and
use that from devicetree.c.

One rationale: the day after tomorrow we will have to get configs
from ACPI, UEFI and what not.

Apart from that I like the looks of this thing!

Yours,
Linus Walleij
