Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832Ab2G0SjZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 14:39:25 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:39901 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751030Ab2G0SjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 14:39:24 -0400
Date: Fri, 27 Jul 2012 11:39:23 -0700 (PDT)
From: Andrew Stiegmann <astiegmann@vmware.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, pv-drivers@vmware.com,
        vm-crosstalk@vmware.com, cschamp@vmware.com
Message-ID: <1258715407.5847225.1343414363506.JavaMail.root@vmware.com>
In-Reply-To: <20120727181639.GA23564@kroah.com>
Subject: Re: [vmw_vmci 11/11] Apply the header code to make VMCI build
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.60.13]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - GC20 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: "Greg KH" <gregkh@linuxfoundation.org>
> To: "Andrew Stiegmann" <astiegmann@vmware.com>
> Cc: "Sam Ravnborg" <sam@ravnborg.org>, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
> pv-drivers@vmware.com, vm-crosstalk@vmware.com, cschamp@vmware.com
> Sent: Friday, July 27, 2012 11:16:39 AM
> Subject: Re: [vmw_vmci 11/11] Apply the header code to make VMCI build
> 
> On Fri, Jul 27, 2012 at 10:20:43AM -0700, Andrew Stiegmann wrote:
> > > The kernel style is to use lower_case for everything.
> > > So this would become:
> > > 
> > >     vmci_device_get()
> > > 
> > > This is obviously a very general comment and applies everywhere.
> > 
> > I wish I could lower case these symbols but VMCI has already
> > existed
> > outside the mainline Linux tree for some time now and changing
> > these
> > exported symbols would mean that other drivers that depend on VMCI
> > (vSock, vmhgfs) would need to change as well.   One thought that
> > did
> > come to mind was exporting both VMCI_Device_Get and vmci_device_get
> > but that would likely just confuse people.  So in short I have made
> > function names lower case where possible, but exported symbols
> > could
> > not be changed.
> 
> Not true at all.  You want those drivers to be merged as well, right?
> So they will need to have their functions changed, and their code as
> well.

As previously mentioned VMware is working on upstreaming our vSock driver (one of a few drivers that uses vmw_vmci).  However there are no plans to upstream the other drivers that depend on vmw_vmci.  Because of this these symbols can not change.

> Just wait until we get to the "change your functionality around"
> requests, those will require those drivers to change.  Right now we
> are
> at the "silly and obvious things you did wrong" stage of the review
> process :)
>
> So please fix these, and also, post these drivers as well, so we can
> see
> how they interact with the core code.
> 
> Actually, if you are going to need lots of refactoring for these
> drivers, and the core, I would recommend putting this all in the
> staging
> tree, to allow that to happen over time.  That would ensure that your
> users keep having working systems, and let you modify the interfaces
> better and easier, than having to keep it all out-of-tree.
> 
> What do you think?

We will discuss this internally and let you know.
 
> greg k-h
> 
