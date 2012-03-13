Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760141Ab2CMJOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 05:14:14 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37162 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760089Ab2CMJOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 05:14:12 -0400
MIME-Version: 1.0
In-Reply-To: <1331316873-20052-1-git-send-email-swarren@wwwdotorg.org>
References: <1331316873-20052-1-git-send-email-swarren@wwwdotorg.org>
Date: Tue, 13 Mar 2012 10:14:11 +0100
Message-ID: <CACRpkdY3BAD+w3X6ZLPpfkO2=yKFjbU=N11wPP4v7TfZqcy7Dg@mail.gmail.com>
Subject: Re: [PATCH] dt: pinctrl: Document device tree binding
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@stericsson.com>, B29396@freescale.com,
        s.hauer@pengutronix.de, dongas86@gmail.com, shawn.guo@linaro.org,
        thomas.abraham@linaro.org, tony@atomide.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 9, 2012 at 7:14 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
> @@ -0,0 +1,118 @@
> +== Introduction ==
> +
> +Hardware modules that control pin multiplexing or configuration parameters
> +such as pull-up/down, tri-state, drive-strength etc are designated as pin
> +controllers. Each pin controller must be represented as a node in device tree,
> +just like any other hardware module.

Maybe put in a reference to Documentation/pinctrl.txt for in-depth
discussion? Also some stuff may be moved over there as generic
information. A lot of the text here does not seem to be about the
device tree ...

However maybe the use case is outside the Linux kernel too
and in that case I'm happy with it.

> +For a client device to operate correctly, certain pin controllers must
> +set up certain specific pin configurations. Some client devices need a
> +single static pin configuration, e.g. set up during initialization. Others
> +need to reconfigure pins at run-time, for example to tri-state pins when the
> +device is inactive. Hence, each client device can define a set of named
> +states. The number and names of those states is defined by the client device's
> +own binding.

Just so I understand: is "pin configuration" here strictly what we
handle in pinconf.c or does it include multiplexing (pinmux.c)?

I guess it's not multiplexing, just making sure.

Maybe state explicitly that multiplexing is not part of pin config,
else someone will invariably get confused.

> +Note that pin controllers themselves may also be client devices of themselves.

Insert something about this being known as config hogging.

The rest I barely understand so I leave it for the others to discuss...

Yours,
Linus Walleij
