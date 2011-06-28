Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab1F1Fpd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 01:45:33 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:58951 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756433Ab1F1FoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 01:44:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jamie Iles <jamie@jamieiles.com>
Subject: Re: [PATCH 4/7] serial/8250: move DWAP support to arch/mips
Date: Tue, 28 Jun 2011 07:43:42 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>, linux-serial@vger.kernel.org
References: <1309211120-2803-1-git-send-email-arnd@arndb.de> <1309211120-2803-5-git-send-email-arnd@arndb.de> <20110627221541.GA5370@gallagher>
In-Reply-To: <20110627221541.GA5370@gallagher>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106280743.42952.arnd@arndb.de>
X-Provags-ID: V02:K0:gqHTEsx5i9Vet4Vqa6SUE75p23UiW0dS08ZCTHFiCGD
 7RJpAD5ImTQ4r/eWwE2H6dFOObLyBqkGoj3geG/IJDR4jdDa9z
 1u0Xo1F/VOC/HDUER1KJjITNpFab6MwokjGllFWzWdiLWkJjSd
 Nup+4mrpD40KPF+53CL8Ffv6/pIKWea+R8koM6VOIjLURsSdr/
 LaLOkPIGKf/hc55XMTKDg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 June 2011 00:15:41 Jamie Iles wrote:
> On Mon, Jun 27, 2011 at 11:45:17PM +0200, Arnd Bergmann wrote:
> > Only one board uses the UPIO_DWAP iotype, and nothing uses
> > the UPIO_DWAP32 iotype. It seems much cleaner to handle the
> > DWAP quirk as a new port type, and move the serial_out
> > accessor into the platform code. If more platforms start
> > using the DWAP port, that function can be moved into a
> > common location.
> 
> I posted a series[1] a couple of weeks back that does this for 
> DWAPB/DWAPB32 in a slightly different way which also removes the extra 
> interrupt handling into the platform code.

Yes, your series looks better than my patch (and works!), so let's
take that instead.

> Incidentally, I've been trying to mainline a platform (picoxcell) that 
> has a DWAPB (with 32-bit access requirement) but struggled to get 
> feedback on the SoC port but hope to resubmit as a device tree based 
> platform.

Ok. Please have a look at the xilinx zynq and the csr SiRFprimaII
submissions then. I'm planning to merge new platforms in 3.1, but
only ones that have been fully converted to the device tree and
require no board specific files. I have to admit that I mostly ignored
the picoxcell submission at the time, but I'll definitely review the
patches when you resubmit them.

> >  arch/mips/pmc-sierra/msp71xx/msp_serial.c |   32 ++++++++++-
> >  drivers/tty/serial/8250.c                 |   87 +++--------------------------
> >  drivers/tty/serial/8250_hub6.c            |   17 ++++++
> 
> Should the hub6 stuff be in this patch?

No, I must have accidentally folded that. I'll do a new patch for that.

> > +/* Save the LCR value so it can be re-written when a Busy Detect IRQ occurs. */
> > +static inline void dwapb_save_out_value(struct uart_port *p, int offset,
> > +					int value)
> > +{
> > +	struct uart_8250_port *up =
> > +		container_of(p, struct uart_8250_port, port);
> 
> I couldn't see that struct uart_8250_port is moved out of 8250.c, so I'm 
> not sure that this would work in here?

Right, I missed that as well.

Thanks!

	Arnd
