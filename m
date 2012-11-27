Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569Ab2K0Acm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 19:32:42 -0500
Received: from mail.kernel.org ([198.145.19.201]:41495 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754364Ab2K0Acl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 19:32:41 -0500
Date: Mon, 26 Nov 2012 16:32:39 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: George Zhang <georgezhang@vmware.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, pv-drivers@vmware.com,
        acking@vmware.com
Subject: Re: [PATCH 12/12] VMCI: Some header and config files.
Message-ID: <20121127003239.GA32298@kroah.com>
References: <20121107183624.9658.78903.stgit@promb-2n-dhcp175.eng.vmware.com>
 <20121107184258.9658.95698.stgit@promb-2n-dhcp175.eng.vmware.com>
 <20121127000304.GA18680@kroah.com>
 <20121127002357.GA27683@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121127002357.GA27683@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 04:23:57PM -0800, Dmitry Torokhov wrote:
> Hi Greg,
> 
> For some reason it still didn't go through to our corporate mail server
> but I see it on LKML.

Good.

> On Mon, Nov 26, 2012 at 04:03:04PM -0800, Greg KH wrote:
> > On Wed, Nov 07, 2012 at 10:43:03AM -0800, George Zhang wrote:
> > 
> > > +static inline struct vmci_handle VMCI_MAKE_HANDLE(vmci_id cid, vmci_id rid)
> > > +{
> > > +	struct vmci_handle h;
> > > +	h.context = cid;
> > > +	h.resource = rid;
> > > +	return h;
> > > +}
> > 
> > You return a structure on the stack that just went away?  Yeah, I know
> > it's an inline, but come on, that's not ok.
> 
> This is certainly OK even if it is not inline, we return the _value_,
> not the pointer to the stacki memory. And yes, the structure is 64 bit
> value so it is returned in registers.

Even on a 32bit processor?  Also, you already have another function that
does this same thing, so having 2 functions in the same patch seems odd,
right?

greg k-h
