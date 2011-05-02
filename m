Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758968Ab1EBW5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 18:57:20 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36975 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221Ab1EBW5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 18:57:19 -0400
Date: Mon, 2 May 2011 23:57:08 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Martin Persson <martin.persson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 0/4] Pinmux subsystem
Message-ID: <20110502225708.GD28001@n2100.arm.linux.org.uk>
References: <1304363768-30338-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304363768-30338-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 09:16:08PM +0200, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This patchset creates a pinmux subsystem and switches U300 to use that new
> subsystem as an example. The problem is not that fantastically hard to
> solve in a general way, nobody got around to it because it requires some
> upfront code I believe, and this is my stab at it.

While I like the idea of consolidating the pinmuxing stuff, I'm not sure
about having a struct pin_mux pointer in each bus types device structure.
It'd mean this would have to be added to platform devices as well...

Then there's SA1100 (and PXA?) to consider with its IrDA setup, where its
necessary to switch the pin muxing during driver operation, when switching
between SIR and FIR modes (SIR uses the UART, FIR uses a separate hardware
block.)

So any per-device pinmuxing subsystem also needs a way that a driver can
change the pinmuxing of its associated pins on the fly too.
