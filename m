Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab2A0DIG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 22:08:06 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:30715 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab2A0DIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 22:08:04 -0500
Date: Thu, 26 Jan 2012 22:05:33 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: socketpair@gmail.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] Fwd: BUG in
 linux+v3.2.1/drivers/xen/xen-pciback/pci_stub.c
Message-ID: <20120127030533.GA20352@phenom.dumpdata.com>
References: <CAEmTpZHkKB29FLWqs0R=uD1zXBOJkfSstGgMM=8bA1VVXGT+wQ@mail.gmail.com>
 <CAEmTpZH+OeQO=RNBFh_+j_QCmPa8sGhV_OOqqsiKUMmjhBwESw@mail.gmail.com>
 <20120125163910.GC23999@phenom.dumpdata.com>
 <20120125212214.GA29571@phenom.dumpdata.com>
 <4F212835020000780006F264@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F212835020000780006F264@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4F22150D.00DF,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 09:17:25AM +0000, Jan Beulich wrote:
> >>> On 25.01.12 at 22:22, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > --- a/drivers/xen/xen-pciback/xenbus.c
> > +++ b/drivers/xen/xen-pciback/xenbus.c
> > @@ -206,8 +206,9 @@ static int xen_pcibk_publish_pci_dev(struct 
> > xen_pcibk_device *pdev,
> >  		goto out;
> >  	}
> >  
> > +	/* TODO: implement feature-use-decimal-for-devfn */
> >  	err = xenbus_printf(XBT_NIL, pdev->xdev->nodename, str,
> > -			    "%04x:%02x:%02x.%02x", domain, bus,
> > +			    "%04x:%02x:%02x.%1x", domain, bus,
> >  			    PCI_SLOT(devfn), PCI_FUNC(devfn));
> >  
> >  out:
> 
> If you are concerned about compatibility (as the added comment
> suggests), then removing the leading zero is not an option either.
> 
> However, as long as all parsers of the string use plain %x or %d,
> there's no issue here and you could as well use %d here too (as
> PCI functions are always in the 0-7 range, which is identically
> represented in octal [important for the case of a leading zero],
> decimal, and hex).
> 
> Bottom line - just add the comment here, and leave the format
> unchanged, or change the format to %d right away.

Yeah, I was thinking of leaving it as is. I think I got a bit overzealous
on changing all the patch sites and ignored my own comment.

> 
> Jan
