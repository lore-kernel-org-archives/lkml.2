Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab1AJT3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 14:29:49 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:37138 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab1AJT3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 14:29:46 -0500
Date: Mon, 10 Jan 2011 20:29:34 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Heasley, Seth" <seth.heasley@intel.com>
Cc: "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 2.6.37] irq: irq and pci_ids patch for Intel DH89xxCC 
 DeviceIDs
Message-ID: <20110110202934.5e4924b8@endymion.delvare>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25C1AF9090@orsmsx501.amr.corp.intel.com>
References: <201101101058.13515.seth.heasley@intel.com>
	<20110110201430.7ab599c4@endymion.delvare>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25C1AF9090@orsmsx501.amr.corp.intel.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Jan 2011 11:19:15 -0800, Heasley, Seth wrote:
> >> --- linux-2.6.37/arch/x86/pci/irq.c.orig	2011-01-04
> >16:50:19.000000000 -0800
> >> +++ linux-2.6.37/arch/x86/pci/irq.c	2011-01-06 14:16:00.000000000
> >-0800
> >> @@ -611,6 +611,15 @@
> >>  		r->set = pirq_piix_set;
> >>  		return 1;
> >>  	}
> >> +
> >> +	if ((device >= PCI_DEVICE_ID_INTEL_DH89XXCC_LPC_MIN) &&
> >> +		(device <= PCI_DEVICE_ID_INTEL_DH89XXCC_LPC_MAX)) {
> >> +		r->name = "PIIX/ICH";
> >> +		r->get = pirq_piix_get;
> >> +		r->set = pirq_piix_set;
> >> +		return 1;
> >> +	}
> >> +
> >
> >I'm curious why we have separate sections for INTEL_5_3400_SERIES,
> >INTEL_COUGARPOINT and now INTEL_DH89XXCC? We do the same thing for all
> >3, so it would make sense to merge the tests to avoid duplicating the
> >code.
> 
> Some products are defining a range of DeviceIDs rather than one or two specific IDs, so these blocks are for catching any DeviceID in the range.  I'm certainly open to suggestion for a better way to handle these, and I agree that the current way is awkward.

I understand the need to have separate blocks for separate IDs and for
ID ranges. But all the ranges could be covered by the same block:

	if ((device >= PCI_DEVICE_ID_INTEL_5_3400_SERIES_LPC_MIN && 
	     device <= PCI_DEVICE_ID_INTEL_5_3400_SERIES_LPC_MAX)
	 || (device >= PCI_DEVICE_ID_INTEL_COUGARPOINT_LPC_MIN && 
	     device <= PCI_DEVICE_ID_INTEL_COUGARPOINT_LPC_MAX)) {
		r->name = "PIIX/ICH";
		r->get = pirq_piix_get;
		r->set = pirq_piix_set;
		return 1;
	}

-- 
Jean Delvare
