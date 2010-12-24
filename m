Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458Ab0LXADt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 19:03:49 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:59351 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab0LXADq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 19:03:46 -0500
Date: Fri, 24 Dec 2010 09:02:10 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>, linux-arch@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Dan Williams <dan.j.williams@intel.com>, linux-sh@vger.kernel.org,
        Sascha Hauer <kernel@pengutronix.de>, linux-usb@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-media@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] dma_declare_coherent_memory: push ioremap() up to caller
Message-ID: <20101224000210.GD28151@linux-sh.org>
References: <201012240020.37208.jkrzyszt@tis.icnet.pl> <20101223235434.GA20587@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101223235434.GA20587@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 11:54:34PM +0000, Russell King - ARM Linux wrote:
> On Fri, Dec 24, 2010 at 12:20:32AM +0100, Janusz Krzysztofik wrote:
> > The patch tries to implement a solution suggested by Russell King, 
> > http://lists.infradead.org/pipermail/linux-arm-kernel/2010-December/035264.html. 
> > It is expected to solve video buffer allocation issues for at least a 
> > few soc_camera I/O memory less host interface drivers, designed around 
> > the videobuf_dma_contig layer, which allocates video buffers using 
> > dma_alloc_coherent().
> > 
> > Created against linux-2.6.37-rc5.
> > 
> > Tested on ARM OMAP1 based Amstrad Delta with a WIP OMAP1 camera patch, 
> > patterned upon two mach-mx3 machine types which already try to use the 
> > dma_declare_coherent_memory() method for reserving a region of system 
> > RAM preallocated with another dma_alloc_coherent(). Compile tested for 
> > all modified files except arch/sh/drivers/pci/fixups-dreamcast.c.
> > 
> > Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> > ---
> > I intended to quote Russell in my commit message and even asked him for 
> > his permission, but since he didn't respond, I decided to include a link 
> > to his original message only.
> 
> There's no problem quoting messages which were sent to public mailing
> lists, especially when there's a record of what was said in public
> archives too.
> 
> I think this is definitely a step forward.
> 
The -tip folks have started using LKML-Reference tags to help with this,
although I don't believe its usage is officially documented anywhere.
