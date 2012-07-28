Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab2G1VKZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 17:10:25 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:59104 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752900Ab2G1VKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 17:10:24 -0400
Date: Sat, 28 Jul 2012 14:10:23 -0700
From: Dmitry Torokhov <dtor@vmware.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Andrew Stiegmann <astiegmann@vmware.com>, pv-drivers@vmware.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, vm-crosstalk@vmware.com,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [Pv-drivers] [vmw_vmci 11/11] Apply the header code to make VMCI
 build
Message-ID: <20120728211023.GA1819@dtor-ws.eng.vmware.com>
References: <20120727103455.GA4639@merkur.ravnborg.org>
 <1693394101.5749000.1343409643934.JavaMail.root@vmware.com>
 <20120727181639.GA23564@kroah.com>
 <20120727202926.GC8262@dtor-ws.eng.vmware.com>
 <20120728195535.GC4762@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120728195535.GC4762@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 28, 2012 at 12:55:35PM -0700, Greg KH wrote:
> On Fri, Jul 27, 2012 at 01:29:27PM -0700, Dmitry Torokhov wrote:
> > On Fri, Jul 27, 2012 at 11:16:39AM -0700, Greg KH wrote:
> > > On Fri, Jul 27, 2012 at 10:20:43AM -0700, Andrew Stiegmann wrote:
> > > > > The kernel style is to use lower_case for everything.
> > > > > So this would become:
> > > > > 
> > > > >     vmci_device_get()
> > > > > 
> > > > > This is obviously a very general comment and applies everywhere.
> > > > 
> > > > I wish I could lower case these symbols but VMCI has already existed
> > > > outside the mainline Linux tree for some time now and changing these
> > > > exported symbols would mean that other drivers that depend on VMCI
> > > > (vSock, vmhgfs) would need to change as well.   One thought that did
> > > > come to mind was exporting both VMCI_Device_Get and vmci_device_get
> > > > but that would likely just confuse people.  So in short I have made
> > > > function names lower case where possible, but exported symbols could
> > > > not be changed.
> > > 
> > > Not true at all.  You want those drivers to be merged as well, right?
> > > So they will need to have their functions changed, and their code as
> > > well.
> > > 
> > > Just wait until we get to the "change your functionality around"
> > > requests, those will require those drivers to change.  Right now we are
> > > at the "silly and obvious things you did wrong" stage of the review
> > > process :)
> > > 
> > > So please fix these, and also, post these drivers as well, so we can see
> > > how they interact with the core code.
> > > 
> > > Actually, if you are going to need lots of refactoring for these
> > > drivers, and the core, I would recommend putting this all in the staging
> > > tree, to allow that to happen over time.  That would ensure that your
> > > users keep having working systems, and let you modify the interfaces
> > > better and easier, than having to keep it all out-of-tree.
> > > 
> > > What do you think?
> > 
> > Actually I think that we'd prefer to keep this in a patch-based form, at
> > least for now, because majority of our users get these drivers with
> > VMware Tools and will continue doing so until ditsributions start
> > enabling VMCI in their kernels. Which they probably won't until VMCI
> > moves form staging. We'd also have to constantly adjust drivers that we
> > are not working on getting upstream at this time to work with the
> > rapidly changing version of VMCI in staging, which will just add work
> > for us.
> 
> That wouldn't be an issue if you just include all of the drivers in the
> tree at the same time, right?

Maybe it wouldn't, however at this time we have not scheduled any
resources for upstreaming vmhgfs driver. We however do seek feedback on
vmci driver (and later vsock) for which we did schedule resources.

Thanks.

-- 
Dmitry
