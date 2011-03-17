Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab1CQV4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 17:56:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:33836 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755928Ab1CQV4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 17:56:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,201,1299484800"; 
   d="scan'208";a="721352440"
Date: Thu, 17 Mar 2011 14:56:09 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-pci@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [RFT][PATCH] PCI / ACPI: Do not require MSI support for PCIe
 native features
Message-ID: <20110317215609.GA5917@xanatos>
References: <201103052254.48515.rjw@sisk.pl>
 <201103170119.17647.rjw@sisk.pl>
 <AANLkTim39fjrAp4OW_MfpbZkz-YYW5E2NOHuo1j=svmW@mail.gmail.com>
 <201103172222.33336.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103172222.33336.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 10:22:33PM +0100, Rafael J. Wysocki wrote:
> On Thursday, March 17, 2011, Yinghai Lu wrote:
> > 2011/3/16 Rafael J. Wysocki <rjw@sisk.pl>:
> > > On Tuesday, March 15, 2011, Sarah Sharp wrote:
> > >> On Tue, Mar 15, 2011 at 01:00:17AM +0100, Rafael J. Wysocki wrote:
> > >> > Well, I must admit I have no idea what the problem is.  OK, in addition to the
> > >> > above changes, please replace the "pci_ext_cfg_avail(root->bus->self)" in the
> > >> > same file with "true" and see if _that_ helps.
> > >>
> > >> Yay, that worked!  dmesg is attached.
> > >
> > > Good, at least we know what the problem is, now we only have to find the root
> > > cause. ;-)
> > >
> > > So, pci_ext_cfg_avail(root->bus->self) returns 0 on your machine, which is kind
> > > of unexpected (to put it lightly), so very likely we have uncovered a bug
> > > in the init code.
> > >
> > > Unfortunately, I may not be able to take care of this issue for the next few
> > > days, I'll let you know when I get back to it.
> > 
> > her .config does not define PCI_MMCONFIG
> > 
> > #
> > # Bus options (PCI etc.)
> > #
> > CONFIG_PCI=y
> > CONFIG_PCI_DIRECT=y
> > # CONFIG_PCI_MMCONFIG is not set
> 
> Ah, good catch, thanks!
> 
> @Sarah: you need to set that for PCI Express to work in general.

Oh, man, sorry to cause so much work to figure that out. :)  I'll
compile with that set and see if it helps.  Not sure why that config
worked on 2.6.37, but not 2.6.38.  I usually just run `make -j4` with
the old .config and basically pick the defaults, except for turning on
the occasional new USB device driver.

Sarah Sharp
