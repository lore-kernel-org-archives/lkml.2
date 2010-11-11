Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab0KKMGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 07:06:48 -0500
Received: from www.tglx.de ([62.245.132.106]:53752 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755665Ab0KKMGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 07:06:47 -0500
Date: Thu, 11 Nov 2010 13:06:39 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 4/6] ce4100: Add errata fixes for UART on CE4100
In-Reply-To: <4CDBDD4A.9030702@gmail.com>
Message-ID: <alpine.LFD.2.00.1011111306210.2900@localhost6.localdomain6>
References: <cover.1289331834.git.dirk.brandewie@gmail.com> <395c11879580e72e3a47272ef8cf5e04fa334210.1289331834.git.dirk.brandewie@gmail.com> <alpine.LFD.2.00.1011111231430.2900@localhost6.localdomain6> <4CDBD91A.2010805@gmail.com>
 <alpine.LFD.2.00.1011111246200.2900@localhost6.localdomain6> <4CDBDD4A.9030702@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Nov 2010, Dirk Brandewie wrote:

> On 11/11/2010 03:47 AM, Thomas Gleixner wrote:
> > On Thu, 11 Nov 2010, Dirk Brandewie wrote:
> > 
> > > On 11/11/2010 03:34 AM, Thomas Gleixner wrote:
> > > > 
> > > > 
> > > > > +	 * Over ride the legacy port configuration that comes from
> > > > > +	 * asm/serial.h. Using the ioport driver then switching to the
> > > > > +	 * PCI memmaped driver hangs the IOAPIC
> > > > > +	 */
> > > > > +	if (up->iotype !=  UPIO_MEM32) {
> > > > > +		up->uartclk  = 14745600;
> > > > > +		up->mapbase = 0xdffe0200;
> > > > 
> > > >     What does the uartclk, mapbase fixups in the CONFIG_EARLY_PRINTK=n
> > > > case ?
> > > > 
> > > This is setup in the PCI driver patch #3 in the series
> > 
> > I just can't find it there, that's why I'm asking :)
> The weird clock is dealt with in:
> +	[pbn_ce4100_1_115200] = {
> +		.flags		= FL_BASE0,
> +		.num_ports	= 1,
> +		.base_baud	= 921600,
> +		.reg_shift      = 2,
> +	},
> 
> That map base is setup in the generic pci driver in setup_port(). I didn't
> need to do anything special.

Thanks for the clarification.

       tglx
