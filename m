Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab2CQDZM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 23:25:12 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40804 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab2CQDZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 23:25:09 -0400
Date: Fri, 16 Mar 2012 20:25:04 -0700
From: Gerard Snitselaar <dev@snitselaar.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: xhci: fix section mismatch in linux-next
Message-ID: <20120317032503.GA32643@perelman.Home>
Reply-To: Gerard Snitselaar <dev@snitselaar.org>
References: <1331922851-28513-1-git-send-email-dev@snitselaar.org>
 <20120316210542.GG6077@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120316210542.GG6077@xanatos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 02:05:42PM -0700, Sarah Sharp wrote:
> This looks fine.  Does it need to be applied to stable as well, or is this
> just a "nice to have" that should be queued for 3.4?
> 
> Sarah Sharp
> 

Hi Sarah, it is only a problem in linux-next because that code path
was added to xhci_hcd_init() by 3429e91a which isn't in stable.

> On Fri, Mar 16, 2012 at 11:34:11AM -0700, Gerard Snitselaar wrote:
> > xhci_unregister_pci() is called in xhci_hcd_init().
> > 
> > Signed-off-by: Gerard Snitselaar <dev@snitselaar.org>
> > ---
> >  drivers/usb/host/xhci-pci.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
> > index ef98b38..0d7b851 100644
> > --- a/drivers/usb/host/xhci-pci.c
> > +++ b/drivers/usb/host/xhci-pci.c
> > @@ -326,7 +326,7 @@ int __init xhci_register_pci(void)
> >  	return pci_register_driver(&xhci_pci_driver);
> >  }
> >  
> > -void __exit xhci_unregister_pci(void)
> > +void xhci_unregister_pci(void)
> >  {
> >  	pci_unregister_driver(&xhci_pci_driver);
> >  }
> > -- 
> > 1.7.7.6
> > 

-- 
