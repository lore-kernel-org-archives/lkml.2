Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab2JHUsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 16:48:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:63660 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163Ab2JHUsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 16:48:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,556,1344236400"; 
   d="scan'208";a="223619228"
Date: Mon, 8 Oct 2012 13:48:44 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Elric Fu <elricfu1@gmail.com>,
        Miroslav Sabljic <miroslav.sabljic@avl.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [ 29/52] xHCI: add aborting command ring function
Message-ID: <20121008204844.GH18378@xanatos>
References: <20121004210635.372689554@linuxfoundation.org>
 <20121004210638.997023603@linuxfoundation.org>
 <1349571728.16173.80.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349571728.16173.80.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 07, 2012 at 02:02:08AM +0100, Ben Hutchings wrote:
> On Thu, 2012-10-04 at 14:21 -0700, Greg Kroah-Hartman wrote:
> [...]
> > --- a/drivers/usb/host/xhci.c
> > +++ b/drivers/usb/host/xhci.c
> > @@ -52,7 +52,7 @@ MODULE_PARM_DESC(link_quirk, "Don't clea
> >   * handshake done).  There are two failure modes:  "usec" have passed (major
> >   * hardware flakeout), or the register reads as all-ones (hardware removed).
> >   */
> > -static int handshake(struct xhci_hcd *xhci, void __iomem *ptr,
> > +int handshake(struct xhci_hcd *xhci, void __iomem *ptr,
> >  		      u32 mask, u32 done, int usec)
> >  {
> >  	u32	result;
> [...]
> 
> I don't think it matters for stable, but since this function is now
> extern it should have an 'xhci_' prefix.

Is it a non-issue?  I know several other drivers have a handshake
function, including the EHCI driver.  If both xHCI and EHCI is built-in,
will the EHCI driver compile?  I'll have to double check this...

Thanks for catching this!

Sarah Sharp
