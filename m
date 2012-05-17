Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab2EQUhL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 16:37:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59430 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563Ab2EQUhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 16:37:08 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH RESEND v9 1/2] gpio: Adjust of_xlate API to support multiple GPIO chips
To: Roland Stigge <stigge@antcom.de>, glikely@secretlab.ca, arm@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, devicetree-discuss@lists.ozlabs.org,
        rob.herring@calxeda.com
Cc: Roland Stigge <stigge@antcom.de>
In-Reply-To: <1337200832-26630-1-git-send-email-stigge@antcom.de>
References: <1337200832-26630-1-git-send-email-stigge@antcom.de>
Date: Thu, 17 May 2012 14:37:06 -0600
Message-Id: <20120517203706.6B8223E0621@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2012 22:40:31 +0200, Roland Stigge <stigge@antcom.de> wrote:
> This patch changes the of_xlate API to make it possible to manipulate the
> actual used gc. This way, multiple GPIO banks can be supported with the same DT
> registered GPIO controller.
> 
> The issue was discussed upon the integration of LPC32xx's DT support for its
> GPIO (see separate patch).
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>

I still wasn't happy with this approach, so I bugged Arnd and we
discussed some options.  So, I think I've got a better solution that
doesn't change the signature of of_xlate.  Instead it allows of_xlate
to return an error code and still have multiple banks referring to the
same gpio_chip.

I've just posted the series.  Can you try it out and make sure it
works for you?

g.
