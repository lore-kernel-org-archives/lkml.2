Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759742Ab2BNJtB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 04:49:01 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38748 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756480Ab2BNJs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 04:48:59 -0500
Date: Tue, 14 Feb 2012 09:48:35 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, grant.likely@secretlab.ca,
        avictor.za@gmail.com, tglx@linutronix.de, plagnioj@jcrosoft.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/9] ARM: at91/snapper9260: move gpio_to_irq out of
	structure initialization
Message-ID: <20120214094835.GB13673@n2100.arm.linux.org.uk>
References: <1329144189-4535-1-git-send-email-nicolas.ferre@atmel.com> <e0557a2864e52e017a0e931c6c64fd341ae21559.1329139662.git.nicolas.ferre@atmel.com> <4F396C4C.9060108@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F396C4C.9060108@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 14, 2012 at 07:02:20AM +1100, Ryan Mallon wrote:
> On 14/02/12 01:43, Nicolas Ferre wrote:
> 
> > gpio_to_irq() implementation will be moved from a macro to a
> > plain function: we cannot use it in a structure initialization
> > anymore.
> 
> What was the reason for the change? It was originally a macro for 
> exactly this reason.

gpio_to_irq() is supposed to work not only for built-in GPIOs, but also
GPIOs provided by other devices.  Having it as a definition which only
works for the SoC GPIOs is broken.
