Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab1BSLad (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 06:30:33 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50108 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662Ab1BSLaa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 06:30:30 -0500
From: "TK, Pratheesh Gangadhar" <pratheesh@ti.com>
To: "Hans J. Koch" <hjk@hansjkoch.de>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "Chatterjee, Amit" <amit.chatterjee@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Sat, 19 Feb 2011 17:00:12 +0530
Subject: RE: [PATCH 1/2] PRUSS UIO driver support
Thread-Topic: [PATCH 1/2] PRUSS UIO driver support
Thread-Index: AcvPiVm7T6RLx76kTmiz3S6GTY+hlAAlq1Cw
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024B83C0E8@dbde02.ent.ti.com>
References: <1298041530-26855-1-git-send-email-pratheesh@ti.com>
 <1298041530-26855-2-git-send-email-pratheesh@ti.com>
 <20110218163147.GD4684@local>
In-Reply-To: <20110218163147.GD4684@local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Hans J. Koch [mailto:hjk@hansjkoch.de]
> Sent: Friday, February 18, 2011 10:02 PM
> To: TK, Pratheesh Gangadhar
> Cc: davinci-linux-open-source@linux.davincidsp.com; hjk@hansjkoch.de;
> gregkh@suse.de; Chatterjee, Amit; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org
> Subject: Re: [PATCH 1/2] PRUSS UIO driver support
> 
> On Fri, Feb 18, 2011 at 08:35:29PM +0530, Pratheesh Gangadhar wrote:
> > Signed-off-by: Pratheesh Gangadhar <pratheesh@ti.com>
> >
> > This patch implements PRUSS (Programmable Real-time Unit Sub System)
> > UIO driver which exports SOC resources associated with PRUSS like
> > I/O, memories and IRQs to user space. PRUSS is dual 32-bit RISC
> > processors which is efficient in performing embedded tasks that
> > require manipulation of packed memory mapped data structures and
> > efficient in handling system events that have tight real time
> > constraints. This driver is currently supported on Texas Instruments
> > DA850, AM18xx and OMAPL1-38 devices.
> > For example, PRUSS runs firmware for real-time critical industrial
> > communication data link layer and communicates with application stack
> > running in user space via shared memory and IRQs.
> 
> I see a few issues, comments below.
> 
> Thanks,
> Hans
> 
> > ---
> >  drivers/uio/Kconfig     |   10 ++
> >  drivers/uio/Makefile    |    1 +
> >  drivers/uio/uio_pruss.c |  250
> +++++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 261 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/uio/uio_pruss.c
> >
> > diff --git a/drivers/uio/Kconfig b/drivers/uio/Kconfig
> > index bb44079..631ffe3 100644
> > --- a/drivers/uio/Kconfig
> > +++ b/drivers/uio/Kconfig
> > @@ -94,4 +94,14 @@ config UIO_NETX
> >  	  To compile this driver as a module, choose M here; the module
> >  	  will be called uio_netx.
> >
> > +config UIO_PRUSS
> > +	tristate "Texas Instruments PRUSS driver"
> > +	depends on ARCH_DAVINCI_DA850
> > +	default n
> 
> That line is unneccessary, "n" is already the default.
> 
Ok, will fix in the next version.
> > +	help
> > +	  PRUSS driver for OMAPL138/DA850/AM18XX devices
> > +	  PRUSS driver requires user space components
> > +	  To compile this driver as a module, choose M here: the module
> > +	  will be called uio_pruss.
> > +
> >  endif
> > +#define MAX_PRUSS_EVTOUT_INSTANCE	(8)
> 
> The brackets are not needed.
> 
Will fix in the next version.
> > +
> > +static struct clk *pruss_clk;
> > +static struct uio_info *info[MAX_PRUSS_EVTOUT_INSTANCE];
> 
> is it really neccessary to allocate that statically?
> 
> > +static void *ddr_virt_addr;
> > +static dma_addr_t ddr_phy_addr;
> > +
Agree - not necessary - will fix.

> > +static irqreturn_t pruss_handler(int irq, struct uio_info *dev_info)
> > +{
> > +	return IRQ_HANDLED;
> > +}
> 
> ROTFL. That reminds me of an old story. The last time I wrote this, and
> Greg dared to post it, we received this reply:
> 
> http://marc.info/?l=linux-kernel&m=116604101232144&w=2
> 
> So, if you really have a _very_ good reason why this _always_ works on
> _any_ DA850 board, add a comment that explains why. Otherwise the whole
> patch set will be doomed.
> 
It always worked for me during the tests on the h/w. So did not bother to dig into the details then. From AM1808/AM1810 ARM Microprocessor System Reference Guide (http://focus.ti.com/general/docs/lit/getliterature.tsp?literatureNumber=sprugm9a&fileType=pdf), section 11.3.1 Interrupt processing
The interrupt processing block does the following tasks:
	-Synchronization of slower and asynchronous interrupts
	- Conversion of polarity to active high
	- Conversion of interrupt type to pulse interrupts
After the processing block, all interrupts will be active-high pulses

Interrupt processing is the first step in INTC h/w which maps system interrupts to ARM (host) interrupts (FIQ, IRQ). 

However I am willing to clean this up to meet the kernel guidelines and good practices... 
> > +
> > +static int __devinit pruss_probe(struct platform_device *dev)
> > +{
> > +	int ret = -ENODEV;
> > +	int count = 0;
> > +	struct resource *regs_pruram, *regs_l3ram, *regs_ddr;
> > +	char *string;
> > +	for (count = 0; count < MAX_PRUSS_EVTOUT_INSTANCE; count++) {
> > +		info[count]->mem[0].addr = regs_pruram->start;
> > +		info[count]->mem[0].size =
> > +		    regs_pruram->end - regs_pruram->start + 1;
> > +		if (!info[count]->mem[0].addr
> > +		    || !(info[count]->mem[0].size - 1)) {
> 
> That size check looks fishy. If somebody forgot to set the size it's OK ?
> 
size is set just previous line, right? If regs_prum_ram->end== regs_prum_ram->start - then there is something wrong... 

> > +			dev_err(&dev->dev, "Invalid memory resource\n");
> > +			break;
> > +		}
> > +		info[count]->mem[0].internal_addr =
> > +		    ioremap(regs_pruram->start, info[count]->mem[0].size);
> > +		if (!info[count]->mem[0].internal_addr) {
> > +			dev_err(&dev->dev,
> > +				"Can't remap memory address range\n");
> > +			break;
> > +		}
> > +		/* Register PRUSS IRQ lines */
> > +		info[count]->irq = IRQ_DA8XX_EVTOUT0 + count;
> > +
> > +		info[count]->irq_flags = IRQF_SHARED;
> 
> How do you handle shared interrupts with the handler above?
> 
> > +		info[count]->handler = pruss_handler;
> 
> And how do you make sure your interrupts are not level triggered? The
> handler above will hang for level triggered interrupts.

As mentioned above interrupt controller (ARM INTC) converts interrupt type to pulse. After required processing is complete - user space handler clears the interrupt from PRUSS.

Thanks,
Pratheesh
