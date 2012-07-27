Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab2G0SQp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 14:16:45 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54124 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab2G0SQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 14:16:44 -0400
Date: Fri, 27 Jul 2012 11:16:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Andrew Stiegmann <astiegmann@vmware.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, pv-drivers@vmware.com,
        vm-crosstalk@vmware.com, cschamp@vmware.com
Subject: Re: [vmw_vmci 11/11] Apply the header code to make VMCI build
Message-ID: <20120727181639.GA23564@kroah.com>
References: <20120727103455.GA4639@merkur.ravnborg.org>
 <1693394101.5749000.1343409643934.JavaMail.root@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1693394101.5749000.1343409643934.JavaMail.root@vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 10:20:43AM -0700, Andrew Stiegmann wrote:
> > The kernel style is to use lower_case for everything.
> > So this would become:
> > 
> >     vmci_device_get()
> > 
> > This is obviously a very general comment and applies everywhere.
> 
> I wish I could lower case these symbols but VMCI has already existed
> outside the mainline Linux tree for some time now and changing these
> exported symbols would mean that other drivers that depend on VMCI
> (vSock, vmhgfs) would need to change as well.   One thought that did
> come to mind was exporting both VMCI_Device_Get and vmci_device_get
> but that would likely just confuse people.  So in short I have made
> function names lower case where possible, but exported symbols could
> not be changed.

Not true at all.  You want those drivers to be merged as well, right?
So they will need to have their functions changed, and their code as
well.

Just wait until we get to the "change your functionality around"
requests, those will require those drivers to change.  Right now we are
at the "silly and obvious things you did wrong" stage of the review
process :)

So please fix these, and also, post these drivers as well, so we can see
how they interact with the core code.

Actually, if you are going to need lots of refactoring for these
drivers, and the core, I would recommend putting this all in the staging
tree, to allow that to happen over time.  That would ensure that your
users keep having working systems, and let you modify the interfaces
better and easier, than having to keep it all out-of-tree.

What do you think?

greg k-h
