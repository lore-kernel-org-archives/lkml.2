Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab0DUKcW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 06:32:22 -0400
Received: from www.tglx.de ([62.245.132.106]:52290 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753993Ab0DUKcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 06:32:21 -0400
Date: Wed, 21 Apr 2010 12:31:50 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Tom Lyon <pugs@cisco.com>, hjk@linutronix.de, gregkh@suse.de,
       chrisw@sous-sol.org, joro@8bytes.org, avi@redhat.com,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] drivers/uio/uio_pci_generic.c: allow access for
 non-privileged processes
Message-ID: <20100421103148.GB1995@bluebox.local>
References: <4bccd3af.M/eSrn9OV22zg0A8%pugs@cisco.com>
 <20100421093849.GB30855@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100421093849.GB30855@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 12:38:49PM +0300, Michael S. Tsirkin wrote:
> 
> > +			j++;
> > +		}
> > +	}
> > +	for (i = 0, j = 0; i < PCI_STD_RESOURCE_END &&
> > +			   j < MAX_UIO_PORT_REGIONS; i++) {
> > +		if (pci_resource_flags(pdev, i) & IORESOURCE_IO) {
> > +			name = kmalloc(8, GFP_KERNEL);
> > +			if (name == NULL)
> > +				break;
> > +			sprintf(name, "iobar%d", i);
> > +			info->port[j].name = name;
> > +			info->port[j].start = pci_resource_start(pdev, i);
> > +			info->port[j].size = pci_resource_len(pdev, i);
> > +			info->port[j].porttype = UIO_PORT_X86;
> > +			j++;
> 
> At least on x86, I think io bar can not be mmapped.

That's right. porttype == UIO_PORT_X86 is only there for information
purposes. Userspace then knows that it cannot map this but has to use
things like inb(), outb() and friends after getting access rights with
ioperm()/iopl(). "start" and "size" gives userspace the information
needed to do this.

Thanks,
Hans


