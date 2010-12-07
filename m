Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751248Ab0LGFPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 00:15:21 -0500
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:37830
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750698Ab0LGFPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 00:15:18 -0500
Date: Mon, 6 Dec 2010 22:15:21 -0700
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Tobias Karnat <tobias.karnat@googlemail.com>
Cc: linux-acpi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        richard.coe@med.ge.com, jslaby@novell.com
Subject: Re: acpi_button: random oops on boot
Message-ID: <20101207051521.GA16804@helgaas.com>
References: <1291477752.5096.27.camel@Tobias-Karnat>
 <201012060928.11307.bjorn.helgaas@hp.com>
 <1291676503.24968.25.camel@Tobias-Karnat>
 <201012061626.45962.bjorn.helgaas@hp.com>
 <1291679699.6246.11.camel@Tobias-Karnat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291679699.6246.11.camel@Tobias-Karnat>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 07, 2010 at 12:54:59AM +0100, Tobias Karnat wrote:
> Am Montag, den 06.12.2010, 16:26 -0700 schrieb Bjorn Helgaas:
> > On Monday, December 06, 2010 04:01:43 pm Tobias Karnat wrote:
> > > No, it only crashes on boot (without the printk patch).
> > > If it happens the machine is completely dead, SysRq does not work.
> > > 
> > > However it is definitely the acpi_button module, because removing it
> > > also fixes this.
> > 
> > If it crashes on boot (not when loading an acpi_button module),
> > you must be building acpi_button into the static kernel.
> 
> It does crash on boot either if built-in to the kernel or as a module,
> However it does not crash if the module is loaded/unloaded after the
> machine has booted.
> 
> > The acpi_button driver has a fairly complicated add() method.
> > In the absence of a better idea, I might just comment out blocks
> > of it and try to isolate the problem.  For example, take out
> > all the input stuff, take out the wakeup GPE stuff, take out
> > the type/name setup, etc.
> 
> Couldn't this be a compiler issue?
> Adding some printk's to fix it seems to be insane.

Agreed, adding printk's is absolutely not any kind of fix.
I think it's more likely to be some sort of memory corruption or
race than a compiler problem.  I assume there is some old kernel
that works fine, even when compiled with the same compiler.

In addition to the isolation ideas I suggested above, you might
boot with "maxcpus=1" and turn on all the Kconfig memory debug
switches.

Bjorn
