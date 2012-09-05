Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab2IENZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 09:25:40 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:44772 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab2IENZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 09:25:38 -0400
Date: Wed, 5 Sep 2012 14:30:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg@redhat.com>
Cc: Don Dutile <ddutile@redhat.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-efi@vger.kernel.org,
        mfleming@intel.com, dwmw2@infradead.org, bhelgaas@google.com
Subject: Re: [PATCH V3 3/4] PCI: Add support for non-BAR ROMs
Message-ID: <20120905143010.557aa3fb@pyramind.ukuu.org.uk>
In-Reply-To: <20120905132007.GB16399@srcf.ucam.org>
References: <1345739803-21017-1-git-send-email-mjg@redhat.com>
	<1345739803-21017-4-git-send-email-mjg@redhat.com>
	<5046B688.1070902@redhat.com>
	<20120905022932.GA4087@srcf.ucam.org>
	<20120905134621.73afe48a@pyramind.ukuu.org.uk>
	<20120905132007.GB16399@srcf.ucam.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Sep 2012 14:20:07 +0100
Matthew Garrett <mjg@redhat.com> wrote:

> On Wed, Sep 05, 2012 at 01:46:21PM +0100, Alan Cox wrote:
> > On Wed, 5 Sep 2012 03:29:32 +0100
> > Matthew Garrett <mjg@redhat.com> wrote:
> > 
> > > On Tue, Sep 04, 2012 at 10:18:48PM -0400, Don Dutile wrote:
> > > > >  	/*
> > > > >+	 * Some devices may provide ROMs via a source other than the BAR
> > > > >+	 */
> > > > >+	if (pdev->rom&&  pdev->romlen) {
> > > > >+		*size = pdev->romlen;
> > > > >+		return phys_to_virt((phys_addr_t)pdev->rom);
> > > >                        ^^^^^
> > > >                          ioremap_nocache() ? ... or is caching rom ok?
> > > 
> > > If it's appearing through this pathway then it's not actually in ROM, 
> > > the platform has pulled it out of somewhere else.
> > 
> > If that somewhere else is on the PCI bus then it should be a bus not a
> > virt translation surely ?
> 
> We've no good way of knowing what the firmware's giving us - we copy it 
> to RAM in the EFI init process, so by the time we're here it certainly 
> shouldn't be on the PCI bus.

In which case how do you know that physical address you have been given
actually has a mapping in kernel virtual space. It seems like it ought to
be getting an ioremap in that case ?

phys_to_virt is not valid for arbitary addresses.

Alan


