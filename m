Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab1GIFoh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 01:44:37 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:32792 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751644Ab1GIFog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 01:44:36 -0400
X-Sasl-enc: Uv5aF4C7mbW+Z0M8IJmIzsk6VyIb73B0k9/fTPyffQ4u 1310190274
Date: Fri, 8 Jul 2011 22:44:24 -0700
From: Greg KH <greg@kroah.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        Graeme Gregory <gg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] regmap: Add generic non-memory mapped register
 access API
Message-ID: <20110709054424.GA14692@kroah.com>
References: <20110709044923.GB13074@opensource.wolfsonmicro.com>
 <1310187044-13269-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310187044-13269-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 09, 2011 at 01:50:41PM +0900, Mark Brown wrote:
> There are many places in the tree where we implement register access for
> devices on non-memory mapped buses, especially I2C and SPI. Since hardware
> designers seem to have settled on a relatively consistent set of register
> interfaces this can be effectively factored out into shared code.  There
> are a standard set of formats for marshalling data for exchange with the
> device, with the actual I/O mechanisms generally being simple byte
> streams.
> 
> We create an abstraction for marshaling data into formats which can be
> sent on the control interfaces, and create a standard method for
> plugging in actual transport underneath that.
> 
> This is mostly a refactoring and renaming of the bottom level of the
> existing code for sharing register I/O which we have in ASoC. A
> subsequent patch in this series converts ASoC to use this.  The main
> difference in interface is that reads return values by writing to a
> location provided by a pointer rather than in the return value, ensuring
> we can use the full range of the type for register data.  We also use
> unsigned types rather than ints for the same reason.
> 
> As some of the devices can have very large register maps the existing
> ASoC code also contains infrastructure for managing register caches.
> This cache work will be moved over in a future stage to allow for
> separate review, the current patch only deals with the physical I/O.
> We also only deal with access to a single register at a time initially
> as this is the most common case.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Acked-by: Liam Girdwood <lrg@ti.com>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
