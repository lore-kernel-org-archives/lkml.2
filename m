Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114Ab0ETTpS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 15:45:18 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58947 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176Ab0ETTpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 15:45:16 -0400
Date: Thu, 20 May 2010 20:45:10 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: felipe.balbi@nokia.com
Cc: Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>, David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/5] gpiolib: introduce set_debounce method
Message-ID: <20100520194509.GB10739@sirena.org.uk>
References: <1274090554-19420-1-git-send-email-felipe.balbi@nokia.com> <1274090554-19420-2-git-send-email-felipe.balbi@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274090554-19420-2-git-send-email-felipe.balbi@nokia.com>
X-Cookie: Dr. Jekyll had something to Hyde.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 01:02:30PM +0300, felipe.balbi@nokia.com wrote:
> From: Felipe Balbi <felipe.balbi@nokia.com>
> 
> Few architectures, like OMAP, allow you to set
> a debouncing time for the gpio before generating
> the IRQ. Teach gpiolib about that.
> 
> Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

This would be generally useful for embedded systems, especially where
the interrupt concerned is a wake source.  It allows drivers to avoid
spurious interrupts from noisy sources so if the hardware supports it
the driver can avoid having to explicitly wait for the signal to become
stable and software has to cope with fewer events.  We've lived without
it for quite some time, though.
