Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab0HWMn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 08:43:29 -0400
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:29118 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751978Ab0HWMn2 (ORCPT
	<rfc822;groupwise-jlee@novell.com:3:2>);
	Mon, 23 Aug 2010 08:43:28 -0400
Message-Id: <4C72F987020000230001F296@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Mon, 23 Aug 2010 06:43:19 -0600
From: "Joey Lee" <jlee@novell.com>
To: <mjg59@srcf.ucam.org>
Cc: <gregkh@suse.de>, <trenn@suse.de>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Dennis.Jansen@web.de>
Subject: Re: [PATCH] Add intel drm blacklist to intel_opregion_present
 detect
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew, 

於 一，2010-08-23 於 12:49 +0100，Matthew Garrett 提到：
> On Mon, Aug 23, 2010 at 07:40:48PM +0800, Lee, Chun-Yi wrote:
> > There have some machines not support by i915 drm driver, e.g. MSI U110/U150,
> > there are use poulsbo chip and drm driver not support it because legal issue.
> > Those machines's acpi backlight control actually work fine and don't need apply
> > the intel opregion support.
> > So, add intel drm blacklist to intel_opregion_present, it can enable the acpi
> > brightness interface on Poulsbo/Morrestown.
> 
> I'm still kind of reluctant about this - doing the blacklisting here 
> means that there's no way for a native driver to inhibit registration 
> from occuring until after opregion setup has taken place, and we found 
> that that was necessary on some 915 so I suspect it is on gma500 as

I read the bug:
 https://bugzilla.kernel.org/show_bug.cgi?id=11259#c28
And your patch comment:
 https://patchwork.kernel.org/patch/13147/

I think there have some machines implement _BCL by using opregion, so
causes the issues. But, there sill have many machines implement _BCL by
using EC to control backlight.
Unfortunately, there have no way can detect the difference.

>  
> well. Perhaps it should just be done as a module option, and then 
> distributions who want to deal with this case could set it by default?
> 

OK, I put a module option also a way to fix the issue for those machines
that were implemented acpi method by call EC. I will put a module option
in acpi video driver then send to you after testing finished.

> > +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_MRST_VGA_0) },
> > +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_MRST_VGA_1) },
> > +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_MRST_VGA_2) },
> > +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_MRST_VGA_3) },
> > +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_MRST_VGA_4) },
> > +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_MRST_VGA_5) },
> > +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_MRST_VGA_6) },
> > +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_MRST_VGA_7) },
> 
> Moorestown doesn't have ACPI, so I don't think there's any need to 
> include these.
> 

OH! OK, thank's  for your review!

Joey Lee

