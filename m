Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab1BSKTs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 05:19:48 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:33474 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753252Ab1BSKTq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 05:19:46 -0500
From: "TK, Pratheesh Gangadhar" <pratheesh@ti.com>
To: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "Chatterjee, Amit" <amit.chatterjee@ti.com>,
        "hjk@linutronix.de" <hjk@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sat, 19 Feb 2011 15:49:25 +0530
Subject: RE: [PATCH 1/2] PRUSS UIO driver support
Thread-Topic: [PATCH 1/2] PRUSS UIO driver support
Thread-Index: AcvPgriB5LyS/jJOQz6obFbr4Yj2rgAmp5Lg
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024B83C0DA@dbde02.ent.ti.com>
References: <1298041530-26855-1-git-send-email-pratheesh@ti.com>
 <1298041530-26855-2-git-send-email-pratheesh@ti.com>
 <201102181644.17634.arnd@arndb.de>
In-Reply-To: <201102181644.17634.arnd@arndb.de>
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
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Friday, February 18, 2011 9:14 PM
> To: linux-arm-kernel@lists.infradead.org
> Cc: TK, Pratheesh Gangadhar; davinci-linux-open-
> source@linux.davincidsp.com; gregkh@suse.de; Chatterjee, Amit;
> hjk@linutronix.de; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 1/2] PRUSS UIO driver support
> 
> On Friday 18 February 2011, Pratheesh Gangadhar wrote:
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
> Looks basically ok, but there are two limitations that I see that you
> might consider fixing.
> 
> Oh, and you should put the Signed-off-by statement below the changelog,
> not above it, but that has nothing to do with the code.
> 
> > +/*
> > + * Host event IRQ numbers from PRUSS
> > + * 3 PRU_EVTOUT0 PRUSS Interrupt
> > + * 4 PRU_EVTOUT1 PRUSS Interrupt
> > + * 5 PRU_EVTOUT2 PRUSS Interrupt
> > + * 6 PRU_EVTOUT3 PRUSS Interrupt
> > + * 7 PRU_EVTOUT4 PRUSS Interrupt
> > + * 8 PRU_EVTOUT5 PRUSS Interrupt
> > + * 9 PRU_EVTOUT6 PRUSS Interrupt
> > + * 10 PRU_EVTOUT7 PRUSS Interrupt
> > +*/
> > +
> > +#define MAX_PRUSS_EVTOUT_INSTANCE	(8)
> > +
> > +static struct clk *pruss_clk;
> > +static struct uio_info *info[MAX_PRUSS_EVTOUT_INSTANCE];
> > +static void *ddr_virt_addr;
> > +static dma_addr_t ddr_phy_addr;
> 
> By making all of these static variables, you limit youself to
> a single PRUSS instance in the system. It's generally better
> to write device drivers in a way that makes it possible to
> have multiple instances, e.g. by moving these four variables
> into the 'priv' part of struct uio_info.

Ok, I agree with making them non-static. Making them part of uio_info might
not be desired. PRUSS_EVOUT_INSTANCE is not same as PRUSS instances. Each
PRUSS can have up to 8 event out interrupt lines to host ARM.
> 
> > +static irqreturn_t pruss_handler(int irq, struct uio_info *dev_info)
> > +{
> > +	return IRQ_HANDLED;
> > +}
> 
> An empty interrupt handler is rather pointless. I guess you really
> notify user space when the interrupt handler gets called, as this
> is the main point of a UIO driver as far as I understand it.
> 
As discussed in the later E-mails, UIO core takes care of this.
Will cover this in following responses.

Thanks,
Pratheesh
