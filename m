Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab2ABNZE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 08:25:04 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40482 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab2ABNZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 08:25:02 -0500
Date: Mon, 2 Jan 2012 13:25:00 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linus.walleij@stericsson.com
Subject: Re: [PATCHv3 1/3] gpio: add a driver for the Synopsys DesignWare
 APB GPIO block
Message-ID: <20120102132500.GB18443@sirena.org.uk>
References: <1325508798-25439-1-git-send-email-jamie@jamieiles.com>
 <1325508798-25439-2-git-send-email-jamie@jamieiles.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325508798-25439-2-git-send-email-jamie@jamieiles.com>
X-Cookie: 1 bulls, 3 cows.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 02, 2012 at 12:53:16PM +0000, Jamie Iles wrote:
> The Synopsys DesignWare block is used in some ARM devices (picoxcell)
> and can be configured to provide multiple banks of GPIO pins.
> 
> v3:	- depend on rather than select IRQ_DOMAIN
> 	- split IRQ support into a separate patch
> v2:	- use Rob Herring's irqdomain in generic irq chip patches
> 	- use reg property to indicate bank index
> 	- support irqs on both edges based on LinusW's u300 driver

Put stuff like this after the ---, it shouldn't end up in git history.

> +- #interrupt-cells : Specifies the number of cells needed to encode an
> +interrupt.  Shall be set to 2.  The first cell defines the interrupt number,
> +the second encodes the triger flags encoded as:

> +	bits[3:0] trigger type and level flags.
> +		1 = low-to-high edge triggered
> +		2 = high-to-low edge triggered
> +		4 = active high level-sensitive
> +		8 = active low level-sensitive

This looks like a straight mapping of the Linux constants to device
tree.  This seems sensible and reasonable and since we're forced to use
magic numbers by the binding it'd be really good if we could standardise
on using this for new drivers to reduce the pain for people writing and
reading device tree bindings.  To help with that could you factor this
out into a separate document that other drivers can reference?
