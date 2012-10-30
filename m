Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab2J3FUS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 01:20:18 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:39991 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752512Ab2J3FUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 01:20:17 -0400
Date: Mon, 29 Oct 2012 22:20:16 -0700
From: Dmitry Torokhov <dtor@vmware.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: George Zhang <georgezhang@vmware.com>, pv-drivers@vmware.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [Pv-drivers] [PATCH 08/12] VMCI: resource object implementation.
Message-ID: <20121030052016.GF32055@dtor-ws.eng.vmware.com>
References: <20121030005923.17788.21797.stgit@promb-2n-dhcp175.eng.vmware.com>
 <20121030010453.17788.90295.stgit@promb-2n-dhcp175.eng.vmware.com>
 <20121030022905.GH1920@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121030022905.GH1920@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 07:29:05PM -0700, Greg KH wrote:
> On Mon, Oct 29, 2012 at 06:04:58PM -0700, George Zhang wrote:
> > +static struct vmci_resource *vmci_resource_lookup(struct vmci_handle handle)
> > +{
> > +	struct vmci_resource *r, *resource = NULL;
> > +	struct hlist_node *node;
> > +	unsigned int idx = vmci_resource_hash(handle);
> > +
> > +	BUG_ON(VMCI_HANDLE_EQUAL(handle, VMCI_INVALID_HANDLE));
> 
> You just crashed a machine, with no chance for recovery.  Not a good
> idea.  Never a good idea.  Customers just lost data, and now they are
> mad.  Make sure you at least print out your email address so they know
> who to blame :)
> 
> Seriously, never BUG() in a driver, warn, sure, but this just looks like
> a debugging assert().  Please remove all of these, they are sprinkled
> all over the driver code here, I'm only responding to one of them here.
> 
> Even better yet, properly handle the error and keep on going, that's
> what the rest of the kernel does.  Or should :)

For public APIs it certainly makes sense to check and handle erroneous input;
internally it often makes sense to simply enforce invariants, because if
we managed to get into that state that we consider impossible we can't really
trust anything.

FWIW:
[dtor@dtor-ws kernel]$ grep -r BUG_ON . | wc -l
11269

Thanks,
Dmitry


