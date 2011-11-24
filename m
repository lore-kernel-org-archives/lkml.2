Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab1KXJ4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 04:56:09 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52512 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab1KXJ4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 04:56:07 -0500
Date: Thu, 24 Nov 2011 09:56:03 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jamie Iles <jamie@jamieiles.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: linux-next: manual merge of the at91 tree with the arm-soc tree
Message-ID: <20111124095603.GA5048@totoro>
References: <20111124121611.fe102955910da2b603032d07@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111124121611.fe102955910da2b603032d07@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Thu, Nov 24, 2011 at 12:16:11PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the at91 tree got conflicts in
> arch/arm/mach-at91/board-cap9adk.c, arch/arm/mach-at91/board-cpu9krea.c,
> arch/arm/mach-at91/board-cpuat91.c,
> arch/arm/mach-at91/board-snapper9260.c and
> arch/arm/mach-at91/include/mach/board.h between commit 84e0cdb0a262
> ("macb: unify at91 and avr32 platform data") from the arm-soc tree and
> commit 1509f4847dd1 ("at91/boards: use -EINVAL for invalid gpio") from
> the at91 tree.
> 
> I fixed them up (see below) and can carry the fix as necessary.
> 
> However, it looks to me that struct macb_platform_data (in
> include/linux/platform_data/macb.h) will need its phy_irq_pin members
> changed to int as well (which may have other consequences).

That looks correct to me.  I've just posted a patch to convert 
phy_irq_pin to an int and from inspection that shouldn't break anything 
by itself.

The macb driver doesn't currently use the phy_irq_pin member, but the 
at91_ether driver does and that compares to 0 for no IRQ so the 
assignment of -EINVAL _could_.

Jamie
