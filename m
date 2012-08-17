Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab2HQITh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 04:19:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755000Ab2HQITY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 04:19:24 -0400
Date: Fri, 17 Aug 2012 10:19:08 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Jeff Garzik <jgarzik@pobox.com>,
        Matthew Wilcox <willy@linux.intel.com>, linux-doc@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 4/5] PCI, MSI: Enable multiple MSIs with
 pci_enable_msi_block_auto()
Message-ID: <20120817081907.GI2246@dhcp-26-207.brq.redhat.com>
References: <cover.1345124063.git.agordeev@redhat.com>
 <447517b3acece13b7e7ce86fdd4d73abe28d81f4.1345124063.git.agordeev@redhat.com>
 <CAErSpo7RVnHQNVok9YQ7PiAAOL=XFTq_PMQmFNgFQhH9tZzy8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo7RVnHQNVok9YQ7PiAAOL=XFTq_PMQmFNgFQhH9tZzy8A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 10:00:39AM -0600, Bjorn Helgaas wrote:
> On Thu, Aug 16, 2012 at 8:49 AM, Alexander Gordeev <agordeev@redhat.com> wrote:
> > -4.2.3 pci_disable_msi
> > +4.2.3 pci_enable_msi_block_auto
> > +
> > +int pci_enable_msi_block_auto(struct pci_dev *dev, int *count)
> > +
> > +This variation on pci_enable_msi() call allows a device driver to request
> > +the maximum possible number of MSIs.  The MSI specification only allows
> > +interrupts to be allocated in powers of two, up to a maximum of 2^5 (32).
> > +
> > +If this function returns 0, it has succeeded in allocating as many
> > +interrupts as the device supports.
> > +
> > +If this function returns a positive number, it indicates that it has
> > +succeeded, but the number of allocated interrupts is less than the number
> > +of interrupts the device supports. The returned value in this case is the
> > +number of allocated interrupts.
> 
> Seems like it would be simpler to avoid the special case of returning
> zero.  You could return a negative value for failure, otherwise return
> the number of interrupts allocated.

But this special case is important, because some drivers would not get
satisfied with just any number of interrupts allocated (i.e. few Intel AHCI
chips (seems) have hardware logic that compares qmask vs qsize and simply
falls back to single interrupt if they are not equal).

So I see the fact that maximum possible number of interrupts were allocated
at least as important than the number itself.

> Then you could also dispense with the "int *count" argument, because
> the caller could just look at the return value.

What about returning the number of allocated interrtupts while storing the
number of supported interrupts to "int *count" (or maxcount)?

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
