Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab0KBP1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 11:27:11 -0400
Received: from cantor.suse.de ([195.135.220.2]:47289 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447Ab0KBP1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 11:27:06 -0400
Date: Tue, 2 Nov 2010 08:27:38 -0700
From: Greg KH <gregkh@suse.de>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: sowani@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.36 1/1] xgifb: change obsolete pci_find_device()
	with pci_get_device().
Message-ID: <20101102152738.GA2398@suse.de>
References: <4CD02860.2020103@gmail.com> <874obz7nun.fsf@lechat.rtp-net.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874obz7nun.fsf@lechat.rtp-net.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 02, 2010 at 04:21:36PM +0100, Arnaud Patard wrote:
> Atul Sowani <sowani@gmail.com> writes:
> Hi,
> 
> > Replaced obsolete pci_find_device() calls with pci_get_device() calls. This is
> > recommended in pci.txt filei in PCI Documentation.
> >
> > Signed-off-by: Atul Sowani <sowani@gmail.com>
> > ---
> > diff -uprN a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
> > --- a/drivers/staging/xgifb/XGI_main_26.c	2010-10-21 02:00:22.000000000 +0530
> > +++ b/drivers/staging/xgifb/XGI_main_26.c	2010-11-01 14:25:21.032436943 +0530
> > @@ -483,7 +483,7 @@ XGIfb_query_VGA_config_space(struct xgi_
> >  			break;
> >  		}
> >
> > -		pdev = pci_find_device(PCI_VENDOR_ID_SI, nbridge_id, pdev);
> > +		pdev = pci_get_device(PCI_VENDOR_ID_SI, nbridge_id, pdev);
> >  		if (pdev)
> >  			valid_pdev = 1;
> 
> hmm... I guess that a pci_dev_put() call is lacking if it has been found.

Exactly, that is what is needed here.

thanks,

greg k-h
