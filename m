Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab1JKTZI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 15:25:08 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:42442 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754933Ab1JKTZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 15:25:06 -0400
X-Sasl-enc: N2DfKZ3IeyNMQkyAoE1EjZrKhDy6laCEkBX0MecePjZF 1318361104
Date: Tue, 11 Oct 2011 13:24:47 -0600
From: Greg KH <greg@kroah.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jon Mason <mason@myri.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [01/38] PCI: Set PCI-E Max Payload Size on fabric
Message-ID: <20111011192447.GC1112@kroah.com>
References: <20111011165903.GA30976@kroah.com>
 <20111011165708.466042477@pistachio.kroah.org>
 <20111011172019.GI10838@kvack.org>
 <CAErSpo6JFTm4y35Nz7aNUgM3ynX52fM1-AwX7OTOwm3cminv1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAErSpo6JFTm4y35Nz7aNUgM3ynX52fM1-AwX7OTOwm3cminv1Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 12:14:05PM -0600, Bjorn Helgaas wrote:
> On Tue, Oct 11, 2011 at 11:20 AM, Benjamin LaHaise <bcrl@kvack.org> wrote:
> > Hello Greg,
> >
> > On Tue, Oct 11, 2011 at 10:55:11AM -0600, Greg KH wrote:
> >> --- a/drivers/pci/pci.c
> >> +++ b/drivers/pci/pci.c
> >> @@ -77,6 +77,8 @@ unsigned long pci_cardbus_mem_size = DEF
> >>  unsigned long pci_hotplug_io_size  = DEFAULT_HOTPLUG_IO_SIZE;
> >>  unsigned long pci_hotplug_mem_size = DEFAULT_HOTPLUG_MEM_SIZE;
> >>
> >> +enum pcie_bus_config_types pcie_bus_config = PCIE_BUS_PERFORMANCE;
> >> +
> >
> > This version of the patch incorrectly defaults to the new performance
> > mode.  Since we haven't even had that code in the 3.1 release yet, I don't
> > think it is suitable for a stable release.  This patch should be revised
> > to a version with default set to safe/don't-touch mode if it is to be
> > included.

Wait, I thought a patch farther in the series made it off by default,
yes, see patch 6 in this series for that one.

> It's not obvious that this fits the criteria for -stable
> (Documentation/stable_kernel_rules.txt).
> 
> For example, I can't tell what real problem this fixes.

Yeah, it's not obvious, but I have had a lot of reports that 3.0 does
not work on some systems without this set of patches.  Now figuring out
of those same systems ever worked at all is getting to be quite
difficult as I don't have access to the hardware, and the people that do
aren't responding to test requests.  But from what I gather, 2.6.32 did
work on these boxes, so it is a regression somehow, but I am not
positive of this.

Because of that, I've included these patches.  They default to off now,
but allow machines that were oopsing on bootup, to now work properly,
which is resolving regressions, so that would seem to meet stable
critera, right?

Now I'm very open to pushback, and if people really don't want these in
(i.e. the PCI maintainer(s) say no), then I'll drop them and work with
the distros to get them into their trees so that their customers's
systems will work properly.

thanks,

greg k-h
