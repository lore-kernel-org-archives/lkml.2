Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746Ab3AIAuc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 19:50:32 -0500
Received: from mail-da0-f41.google.com ([209.85.210.41]:35918 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845Ab3AIAua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 19:50:30 -0500
Date: Tue, 8 Jan 2013 16:50:25 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Dmitry Torokhov <dtor@vmware.com>
Cc: pv-drivers@vmware.com, George Zhang <georgezhang@vmware.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [Pv-drivers] [PATCH 07/12] VMCI: queue pairs implementation.
Message-ID: <20130109005025.GA2121@kroah.com>
References: <20130108234751.2698.66606.stgit@promb-2n-dhcp175.eng.vmware.com>
 <20130108235444.2698.24076.stgit@promb-2n-dhcp175.eng.vmware.com>
 <20130109001539.GA24989@kroah.com>
 <2526541.2xuuOB7vZK@dtor-d630.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2526541.2xuuOB7vZK@dtor-d630.eng.vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2013 at 04:28:51PM -0800, Dmitry Torokhov wrote:
> Hi Greg,
> 
> On Tuesday, January 08, 2013 04:15:39 PM Greg KH wrote:
> > On Tue, Jan 08, 2013 at 03:54:54PM -0800, George Zhang wrote:
> > 
> > > +/* Guest device port I/O. */
> > > +struct PPNSet {
> > > +	u64 num_produce_pages;
> > > +	u64 num_consume_pages;
> > > +	u32 *produce_ppns;
> > > +	u32 *consume_ppns;
> > > +	bool initialized;
> > > +};
> > 
> > I know this is a private structure to the driver, so it's not that big
> > of a deal at all, but the naming for this is a bit odd (mixed case.)
> > 
> > Not a show stopper at all, but if you had run checkpatch.pl on it, it
> > would have warned you about this.
> 
> Surprisingly it does not:
> 
> [dtor@dtor-ws vmci]$ ./scripts/checkpatch.pl -f  
> drivers/misc/vmw_vmci/vmci_queue_pair.h 
> total: 0 errors, 0 warnings, 191 lines checked
> 
> drivers/misc/vmw_vmci/vmci_queue_pair.h has no obvious style problems and is 
> ready for submission.
> 
> Also silent on the patch itself...

You might want to upgrade your version of checkpatch.  As of 3.8-rc2,
this is what I get:

$ ./scripts/checkpatch.pl -f drivers/misc/vmw_vmci/vmci_queue_pair.h
WARNING: Avoid CamelCase: <PPNSet>
#28: FILE: misc/vmw_vmci/vmci_queue_pair.h:28:
+struct PPNSet {

total: 0 errors, 1 warnings, 191 lines checked

drivers/misc/vmw_vmci/vmci_queue_pair.h has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

> We'll send a followup patch anyway.

Great.

greg k-h
