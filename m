Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab2JBQjn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 12:39:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932095Ab2JBQjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 12:39:40 -0400
Date: Tue, 2 Oct 2012 18:42:21 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Ingo Molnar <mingo@kernel.org>, Jeff Garzik <jgarzik@pobox.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Matthew Wilcox <willy@linux.intel.com>, x86@kernel.org,
        linux-pci@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH v3 -tip 5/5] AHCI: Support multiple MSIs
Message-ID: <20121002164220.GB2258@dhcp-26-207.brq.redhat.com>
References: <cover.1349074231.git.agordeev@redhat.com>
 <cc6441a31a2c600ad9ae33e7715de65b8d46a66f.1349074231.git.agordeev@redhat.com>
 <20121002050929.GD7756@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121002050929.GD7756@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 07:09:29AM +0200, Ingo Molnar wrote:
> > +irqreturn_t ahci_hw_interrupt(int irq, void *dev_instance)
> > +{
> > +	struct ata_port *ap_this = dev_instance;
> > +	struct ahci_port_priv *pp = ap_this->private_data;
> > +	struct ata_host *host = ap_this->host;
> > +	struct ahci_host_priv *hpriv = host->private_data;
> > +	void __iomem *mmio = hpriv->mmio;
> > +	unsigned int i;
> > +	u32 irq_stat, irq_masked;
> > +
> > +	VPRINTK("ENTER\n");
> 
> Is this per IRQ handler execution debugging code still needed? 
> Same for the other VPRINTK() lines in this patch.

These VPRINKs are only to make new handlers look like ahci_interrupt()
which did not change. I believe, if they need to go it is better to
remove them altogether, with a separate followup patch.

Jeff, what do you think?

Thanks!

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
