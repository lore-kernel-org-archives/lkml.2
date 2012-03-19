Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964982Ab2CSPqm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 11:46:42 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62270 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970Ab2CSPqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 11:46:39 -0400
Date: Mon, 19 Mar 2012 08:46:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Matthew Garrett <mjg@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, romain@orebokech.com,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [ 05/38] PCI: ignore pre-1.1 ASPM quirking when ASPM is disabled
Message-ID: <20120319154633.GA8176@kroah.com>
References: <20120316233447.747702375@linuxfoundation.org>
 <4F670872.2090700@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F670872.2090700@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 11:20:34AM +0100, Jiri Slaby wrote:
> On 03/17/2012 12:34 AM, Greg KH wrote:
> > 3.0-stable review patch.  If anyone has any objections, please let me know.
> 
> The commit below is reported to crash the machine in the early init. See
> the first reply to this message (lkml.org seems to be down right now):
> lkml.org/lkml/2012/3/18/132

Yes, but this patch fixes machines that others have been reporting
problems with, so, what am I supposed to do?

I'll stick with this patch for now, and hope that Matthew fixes this up
in Linus's tree and I'll suck that fix in when it gets there.  Is that
ok?

Matthew, you are still working on this, right?  :)

thanks,

greg k-h

> 
> > From: Matthew Garrett <mjg@redhat.com>
> > 
> > commit 4949be16822e92a18ea0cc1616319926628092ee upstream.
> > 
> > Right now we won't touch ASPM state if ASPM is disabled, except in the case
> > where we find a device that appears to be too old to reliably support ASPM.
> > Right now we'll clear it in that case, which is almost certainly the wrong
> > thing to do. The easiest way around this is just to disable the blacklisting
> > when ASPM is disabled.
> > 
> > Signed-off-by: Matthew Garrett <mjg@redhat.com>
> > Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > ---
> >  drivers/pci/pcie/aspm.c |    3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > --- a/drivers/pci/pcie/aspm.c
> > +++ b/drivers/pci/pcie/aspm.c
> > @@ -500,6 +500,9 @@ static int pcie_aspm_sanity_check(struct
> >  	int pos;
> >  	u32 reg32;
> >  
> > +	if (aspm_disabled)
> > +		return 0;
> > +
> >  	/*
> >  	 * Some functions in a slot might not all be PCIe functions,
> >  	 * very strange. Disable ASPM for the whole slot
> > 
> > 
> 
> thanks,
> -- 
> js
> suse labs
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
