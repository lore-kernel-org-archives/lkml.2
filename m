Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461Ab0IWKzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 06:55:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:42162 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754429Ab0IWKzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 06:55:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,222,1283756400"; 
   d="scan'208";a="327837987"
Date: Thu, 23 Sep 2010 11:08:05 +0100
From: Alan Cox <alan@linux.intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Feng Tang <feng.tang@intel.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, greg@kroah.com, x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH v3 4/4] x86, earlyprintk: add hsu early console for
 Intel Medfield platform
Message-ID: <20100923110805.2fe5b2a9@linux.intel.com>
In-Reply-To: <20100921162627.GA21459@dumpdata.com>
References: <1284361736-23011-1-git-send-email-feng.tang@intel.com>
	<1284361736-23011-5-git-send-email-feng.tang@intel.com>
	<20100921162627.GA21459@dumpdata.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Is there a link to a PDF of the device in question?

Not that I know of at least so far.

> > + */
> > +#define HSU_PORT2_PADDR		0xffa28180
> 
> Is it _always_ that address?

Yes.

> > +
> > +static void __iomem *phsu;
> > +
> > +void hsu_early_console_init(void)
> > +{
> > +	u8 lcr;
> > +
> > +	phsu = (void
> > *)set_fixmap_offset_nocache(FIX_EARLYCON_MEM_BASE,
> > +
> > HSU_PORT2_PADDR); +
> > +	/* Disable FIFO */
> > +	writeb(0x0, phsu + UART_FCR);
> 
> No detection? What happens if you don't have the device (say in
> production it gets removed) and we try to use earlyprintk=hsu? Won't
> we have some trouble?

Same as if you try and use the other serial console drivers that way.
It's a bit tricky to do much about because to be sure you've got this
stuff you need to have done a whole ton of work which then makes the
early console pointless.

> 
> > +
> > +	/* Set to default 115200 bps, 8n1 */
> 
> Is that OK? Should there be some parsing of the baudrate data?

For a serial console yes - for an early console robustness is
everything, and its an embedded development environment so fixed
configuration really isn't a problem.
