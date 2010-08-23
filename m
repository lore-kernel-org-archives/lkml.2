Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344Ab0HWLts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 07:49:48 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:44130 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab0HWLtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 07:49:47 -0400
Date: Mon, 23 Aug 2010 12:49:38 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, jlee@novell.com,
        Dennis.Jansen@web.de, linux-acpi@vger.kernel.org, trenn@suse.de
Subject: Re: [PATCH] Add intel drm blacklist to intel_opregion_present
	detect
Message-ID: <20100823114938.GA19879@srcf.ucam.org>
References: <1282563648-21935-1-git-send-email-jlee@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282563648-21935-1-git-send-email-jlee@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 07:40:48PM +0800, Lee, Chun-Yi wrote:
> There have some machines not support by i915 drm driver, e.g. MSI U110/U150,
> there are use poulsbo chip and drm driver not support it because legal issue.
> Those machines's acpi backlight control actually work fine and don't need apply
> the intel opregion support.
> So, add intel drm blacklist to intel_opregion_present, it can enable the acpi
> brightness interface on Poulsbo/Morrestown.

I'm still kind of reluctant about this - doing the blacklisting here 
means that there's no way for a native driver to inhibit registration 
from occuring until after opregion setup has taken place, and we found 
that that was necessary on some 915 so I suspect it is on gma500 as 
well. Perhaps it should just be done as a module option, and then 
distributions who want to deal with this case could set it by default?

> +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_MRST_VGA_0) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_MRST_VGA_1) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_MRST_VGA_2) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_MRST_VGA_3) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_MRST_VGA_4) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_MRST_VGA_5) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_MRST_VGA_6) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_MRST_VGA_7) },

Moorestown doesn't have ACPI, so I don't think there's any need to 
include these.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
