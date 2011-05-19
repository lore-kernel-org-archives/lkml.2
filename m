Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932939Ab1ESQKc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 12:10:32 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:40651 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507Ab1ESQKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 12:10:31 -0400
Date: Thu, 19 May 2011 09:10:29 -0700
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@lists.ozlabs.org, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFCv7 0/2] CARMA Board Support
Message-ID: <20110519161029.GC28291@ovro.caltech.edu>
References: <1297467270-29576-1-git-send-email-iws@ovro.caltech.edu>
 <1305778421.7481.38.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305778421.7481.38.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 02:13:41PM +1000, Benjamin Herrenschmidt wrote:
> On Fri, 2011-02-11 at 15:34 -0800, Ira W. Snyder wrote:
> > Hello everyone,
> > 
> > This is the seventh posting of these drivers, taking into account comments
> > from earlier postings. I've made sure that the drivers both pass checkpatch
> > without any errors or warnings. I would appreciate as much review as you
> > can offer, so that these can get into the next merge cycle. They've been
> > sitting outside mainline for far too long.
> 
> This has been bitrotting for way too long indeed. I'm sticking this into
> powerpc -next today.
> 

Thanks Ben.

I'll grab the -next tree and make sure it builds on my board. I don't
think any API's have changed, but I will send an updated version if they
have.

Thanks,
Ira

> > RFCv6 -> RFCv7:
> > - reference count private data structure (to support unbind)
> > - use #defines instead of hex values for registers
> > - keep lines <=80 characters
> > 
> > RFCv5 -> RFCv6:
> > - change locking in several functions
> > - use list_move_tail() to simplify code
> > - remove unused helper functions
> > 
> > RFCv4 -> RFCv5:
> > - remove unecessary locking per review comments
> > - do not clobber return values from *_interruptible()
> > - explicitly track buffer DMA mapping
> > - use #defines instead of raw hex addresses
> > - change enable sysfs attribute to root-writeable only
> > 
> > RFCv3 -> RFCv4:
> > - updates for DATA-FPGA version 2
> > 
> > RFCv2 -> RFCv3:
> > - use miscdevice framework (removing the carma class)
> > - add bitfile readback capability to the programmer
> > 
> > RFCv1 -> RFCv2:
> > - change comments to kerneldoc format
> > - Kconfig improvements
> > - use the videobuf_dma_sg API in the programmer
> > - updates for Freescale DMAEngine DMA_SLAVE API changes
> > 
> > KNOWN ISSUES:
> > - untested with a setup that can generate interrupts (will get access soon)
> > - does not handle runtime "unbind"
> > 
> > Information about the CARMA board:
> > 
> > The CARMA board is essentially an MPC8349EA MDS reference design with a
> > 1GHz ADC and 4 high powered data processing FPGAs connected to the local
> > bus. It is all packed into a compact PCI form factor. It is used at the
> > Owens Valley Radio Observatory as the main component in the correlator
> > system.
> > 
> > For board information, see:
> > http://www.mmarray.org/~dwh/carma_board/index.html
> > 
> > For DATA-FPGA register layout, see:
> > http://www.mmarray.org/memos/carma_memo46.pdf
> > 
> > These drivers are the necessary pieces to get the data processing FPGAs
> > working and producing data. Despite the fact that the hardware is custom
> > and we are the only users, I'd still like to get the drivers upstream.
> > Several people have suggested that this is possible.
> > 
> > Some further patches will be forthcoming. I have a driver for the LED
> > subsystem and the PPS subsystem. The LED register layout is expected to
> > change soon, so I won't post the driver until that is finished. The PPS
> > driver will be posted seperately from this patch series; it is very
> > generic.
> > 
> > Thanks to everyone who has provided comments on earlier versions!
> > 
> > Ira W. Snyder (2):
> >   misc: add CARMA DATA-FPGA Access Driver
> >   misc: add CARMA DATA-FPGA Programmer support
> > 
> >  drivers/misc/Kconfig                    |    1 +
> >  drivers/misc/Makefile                   |    1 +
> >  drivers/misc/carma/Kconfig              |   18 +
> >  drivers/misc/carma/Makefile             |    2 +
> >  drivers/misc/carma/carma-fpga-program.c | 1141 ++++++++++++++++++++++++
> >  drivers/misc/carma/carma-fpga.c         | 1433 +++++++++++++++++++++++++++++++
> >  6 files changed, 2596 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/misc/carma/Kconfig
> >  create mode 100644 drivers/misc/carma/Makefile
> >  create mode 100644 drivers/misc/carma/carma-fpga-program.c
> >  create mode 100644 drivers/misc/carma/carma-fpga.c
> > 
> 
> 
