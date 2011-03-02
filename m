Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077Ab1CBU5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 15:57:18 -0500
Received: from www.tglx.de ([62.245.132.106]:56761 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756796Ab1CBU5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 15:57:16 -0500
Date: Wed, 2 Mar 2011 21:56:37 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
cc: "Hans J. Koch" <hjk@hansjkoch.de>, Pratheesh Gangadhar <pratheesh@ti.com>,
        linux-kernel@vger.kernel.org, gregkh@suse.de, sshtylyov@mvista.com,
        amit.chatterjee@ti.com, davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v8 1/1] PRUSS UIO driver support
In-Reply-To: <201103022123.38050.arnd@arndb.de>
Message-ID: <alpine.LFD.2.00.1103022155030.2701@localhost6.localdomain6>
References: <1299065886-30099-1-git-send-email-pratheesh@ti.com> <1299065886-30099-2-git-send-email-pratheesh@ti.com> <20110302200956.GB23818@local> <201103022123.38050.arnd@arndb.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Mar 2011, Arnd Bergmann wrote:

> On Wednesday 02 March 2011 21:09:56 Hans J. Koch wrote:
> > > +static struct uio_info *info;
> > > +static dma_addr_t sram_paddr, ddr_paddr;
> > > +static void *prussio_vaddr, *sram_vaddr, *ddr_vaddr;
> > 
> > So the correct thing would be
> > 
> > static void __iomem *prussio_vaddr;
> > static void *sram_vaddr, *ddr_vaddr;
> 
> I also commented that it should not be a global variable at
> all, but a dynamic data structure referenced from the device.
> 
> Not important, but Pratheesh said he'd change it. If it stays
> a global variable, I'd at least expect an explanation why
> the static variable is considered better in this case.

I did not pick at that, because there is no indicator that we'll see
more than one PRUSS unit per SoC in the forseeable future.

Thanks,

	tglx
