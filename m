Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352Ab2IENUR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 09:20:17 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:57559 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab2IENUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 09:20:15 -0400
Date: Wed, 5 Sep 2012 14:20:07 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Don Dutile <ddutile@redhat.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-efi@vger.kernel.org,
        mfleming@intel.com, dwmw2@infradead.org, bhelgaas@google.com
Subject: Re: [PATCH V3 3/4] PCI: Add support for non-BAR ROMs
Message-ID: <20120905132007.GB16399@srcf.ucam.org>
References: <1345739803-21017-1-git-send-email-mjg@redhat.com>
 <1345739803-21017-4-git-send-email-mjg@redhat.com>
 <5046B688.1070902@redhat.com>
 <20120905022932.GA4087@srcf.ucam.org>
 <20120905134621.73afe48a@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120905134621.73afe48a@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 01:46:21PM +0100, Alan Cox wrote:
> On Wed, 5 Sep 2012 03:29:32 +0100
> Matthew Garrett <mjg@redhat.com> wrote:
> 
> > On Tue, Sep 04, 2012 at 10:18:48PM -0400, Don Dutile wrote:
> > > >  	/*
> > > >+	 * Some devices may provide ROMs via a source other than the BAR
> > > >+	 */
> > > >+	if (pdev->rom&&  pdev->romlen) {
> > > >+		*size = pdev->romlen;
> > > >+		return phys_to_virt((phys_addr_t)pdev->rom);
> > >                        ^^^^^
> > >                          ioremap_nocache() ? ... or is caching rom ok?
> > 
> > If it's appearing through this pathway then it's not actually in ROM, 
> > the platform has pulled it out of somewhere else.
> 
> If that somewhere else is on the PCI bus then it should be a bus not a
> virt translation surely ?

We've no good way of knowing what the firmware's giving us - we copy it 
to RAM in the EFI init process, so by the time we're here it certainly 
shouldn't be on the PCI bus.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
