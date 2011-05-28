Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814Ab1E1KfK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 06:35:10 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33854 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab1E1KfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 06:35:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NBDdjCUZzexdBXQdjwjsGlbk8W/juJhlQSmWjF/mF/h4Lu/0hUQ8W9wbJqq4yerF5h
         Sb0EpUzIMZn4e7ioBQJqatrAse1HUYyF8mOzYd7S0AOzvTX1xAV72K9KqXaDFNLheGz3
         Ar1WLWTfTeCJUGS0lMf81l5FJ8qQ2CfecA7hg=
Date: Sat, 28 May 2011 13:33:05 +0300
From: Mika Westerberg <mika.westerberg@iki.fi>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "ryan@bluewatersys.com" <ryan@bluewatersys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH 1/5] dmaengine: add ep93xx DMA support
Message-ID: <20110528103305.GB15220@acer>
References: <cover.1306082097.git.mika.westerberg@iki.fi>
 <e6777eb9f7228ee1dadec1f0c9f16c3afc44c307.1306082097.git.mika.westerberg@iki.fi>
 <0D753D10438DA54287A00B027084269764D331A4B2@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0D753D10438DA54287A00B027084269764D331A4B2@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 08:38:41PM -0500, H Hartley Sweeten wrote:
> >  
> > +config EP93XX_DMA
> > +	bool "Cirrus Logic EP93xx DMA support"
> > +	depends on ARCH_EP93XX
> > +	select DMA_ENGINE
> > +	help
> > +	  Enable support for the Cirrus Logic EP93xx M2P/M2M DMA controller.
> > +
> >  config DMA_ENGINE
> >  	bool
> 
> The old dma-m2p support was always builtin.  Should ARCH_EP93XX select
> EP93XX_DMA to keep this, or should it be added to the ep93xx_defconfig?

There are no users for the DMA in ep93xx_defconfig so I think that it
shouldn't be selected by default. I was planning to change platform code to be
conditionally compiled, like:

arch/arm/mach-ep93xx/Makefile:

+obj-$(CONFIG_EP93XX_DMA)       += dma.o

Any objections?
