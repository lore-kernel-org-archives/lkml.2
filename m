Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645Ab1CCJeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 04:34:21 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:42152 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753153Ab1CCJeT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 04:34:19 -0500
From: "TK, Pratheesh Gangadhar" <pratheesh@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hjk@hansjkoch.de" <hjk@hansjkoch.de>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "sshtylyov@mvista.com" <sshtylyov@mvista.com>,
        "Chatterjee, Amit" <amit.chatterjee@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 3 Mar 2011 14:54:12 +0530
Subject: RE: [PATCH v8 1/1] PRUSS UIO driver support
Thread-Topic: [PATCH v8 1/1] PRUSS UIO driver support
Thread-Index: AcvY3Os85gamCIJRTUmaiJdoMVa39QApiN9Q
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024C008718@dbde02.ent.ti.com>
References: <1299065886-30099-1-git-send-email-pratheesh@ti.com>
 <1299065886-30099-2-git-send-email-pratheesh@ti.com>
 <201103021422.27094.arnd@arndb.de>
In-Reply-To: <201103021422.27094.arnd@arndb.de>
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

Hi,

> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Wednesday, March 02, 2011 6:52 PM
> On Wednesday 02 March 2011, Pratheesh Gangadhar wrote:
> > +
> > +static struct clk *pruss_clk;
> > +static struct uio_info *info;
> > +static dma_addr_t sram_paddr, ddr_paddr;
> > +static void *prussio_vaddr, *sram_vaddr, *ddr_vaddr;
> > +
> 
> To my initial comment about these being single-instance
> variables, you said you'd change that, which has not happened
> yet.
> 
I will do this in next version. Also realized that in next SoC, 
PRU INTC base offset is different, so plan to add a platform_data
variable to make this portable.

+#define PINTC_HIDISR	0x4038
+#define PINTC_HIPIR	0x4900
+#define PINTC_HIER	0x5500 

These hard coding also need to go to make it fully portable.
+int intr_bit = (irq - IRQ_DA8XX_EVTOUT0 + 2);
+p->irq = IRQ_DA8XX_EVTOUT0 + cnt;

> Also, I now noticed that the types are wrong, you are
> missing __iomem annotations for MMIO ranges. Please make
> sure that the code builds fine with sparse and "make C=1",
> which will tell you about these problems.
> 
Thanks, this also helped to identify 2 unused lines in the code.

+		p->mem[1].internal_addr = sram_vaddr;
+		p->mem[2].internal_addr = ddr_vaddr;

Pratheesh
