Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214Ab1C1Ug4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 16:36:56 -0400
Received: from the.earth.li ([46.43.34.31]:41106 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753911Ab1C1Ugy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 16:36:54 -0400
Date: Mon, 28 Mar 2011 13:36:53 -0700
From: Jonathan McDowell <noodles@earth.li>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Re-add quirk for ServerWorks bridge secondary buses
Message-ID: <20110328203653.GL4835@earth.li>
References: <20110324043652.GA4835@earth.li>
 <AANLkTikiZ_JYUcobRF6T_=DMXCc=Em8f1U_eD_rQRSRu@mail.gmail.com>
 <20110324182751.GC4835@earth.li>
 <AANLkTimDV5m0Ug5H76HcdfFNrJaZcdGrChxVpCp9dMW6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimDV5m0Ug5H76HcdfFNrJaZcdGrChxVpCp9dMW6@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 05:58:30PM -0700, Bjorn Helgaas wrote:
> On Thu, Mar 24, 2011 at 11:27 AM, Jonathan McDowell
> <noodles@earth.li>wrote:
> 
> > On Wed, Mar 23, 2011 at 10:50:20PM -0700, Bjorn Helgaas wrote:
>
> > > I assume that since you don't have a standard BIOS, you don't have
> > > ACPI?
> >
> > Nope. Nor DMI. As previously mentioned there is a custom ASIC, but
> > it's hidden behind these bridges.
> >
> 
> Thanks.   Looks like your box doesn't even have PCI BIOS, so
> pcibios_last_bus == -1 until pci_fixup_serverworks() updates it, so we
> only scan bus 00.
> 
> Another option would be to boot with "pci=lastbus=0xff".  If you just
> have a box or two, that might be the easiest solution, but I guess I'm
> not opposed to a quirk like this.  It's a firmware workaround, not a
> hardware bug, and the message is irrelevant and possibly distracting
> on machines with decent firmware, but it's not terrible.

I've managed to get detection of the non-standard BIOS working, so I can
actually quirk much more specifically now for my purposes. I don't
believe there's any need to take this upstream if no one else is
reporting problems.

J.

-- 
"This sentence no verb." -- Robin Stevens, ox.talk
This .sig brought to you by the letter T and the number 42
Product of the Republic of HuggieTag
