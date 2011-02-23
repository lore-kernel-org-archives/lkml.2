Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab1BWV5O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 16:57:14 -0500
Received: from kroah.org ([198.145.64.141]:53254 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754807Ab1BWV5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 16:57:13 -0500
Date: Wed, 23 Feb 2011 13:56:58 -0800
From: Greg KH <greg@kroah.com>
To: Hank Janssen <hjanssen@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        KY Srinivasan <kys@microsoft.com>
Subject: Re: [PATCH 2/6] Staging: hv: hv.c Removed all DPRINT and debug -
 using pr_err now
Message-ID: <20110223215658.GB16908@kroah.com>
References: <1298417565-12356-1-git-send-email-hjanssen@microsoft.com>
 <1298417565-12356-2-git-send-email-hjanssen@microsoft.com>
 <20110223191533.GB1030@kroah.com>
 <8AFC7968D54FB448A30D8F38F259C56233FADA94@TK5EX14MBXC118.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8AFC7968D54FB448A30D8F38F259C56233FADA94@TK5EX14MBXC118.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 07:41:28PM +0000, Hank Janssen wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:greg@kroah.com]
> > Sent: Wednesday, February 23, 2011 11:16 AM
> > 
> > On Tue, Feb 22, 2011 at 03:32:41PM -0800, Hank Janssen wrote:
> > > This group of patches removes all DPRINT from hv_vmbus.ko.
> > > It is divided in several patches due to size.
> > >
> > > All DPRINT calls have been removed, and where needed have been
> > > replaced with pr_XX native calls. Many debug DPRINT calls have
> > > been removed outright.
> > >
> > > The amount of clutter this driver prints has been
> > > significantly reduced.
> > >
> > > Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> > > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > >
> > > ---
> > >  drivers/staging/hv/hv.c |   88 +++++++++++--------------------------
> > ---------
> > >  1 files changed, 21 insertions(+), 67 deletions(-)
> 
> > > -		DPRINT_INFO(VMBUS, "OS Build:%d-%d.%d-%d-%d.%d",\
> > > -			    eax,
> > > -			    ebx >> 16,
> > > -			    ebx & 0xFFFF,
> > > -			    ecx,
> > > -			    edx >> 24,
> > > -			    edx & 0xFFFFFF);
> > > +
> > > +		pr_info("%s: Hyper-V Host OS Build:%d-%d.%d-%d-%d.%d",
> > > +			VMBUS_MOD,
> > > +			eax,
> > > +			ebx >> 16,
> > > +			ebx & 0xFFFF,
> > > +			ecx,
> > > +			edx >> 24,
> > > +			edx & 0xFFFFFF);
> > 
> > Why did you keep this one?  Why is it needed?
> 
> This tells me what version the host is running. I frequently ask customers if 
> they are running on Host version X or Y. This tells me that with certainty 
> what they are running. The number of times I got from a customer that
> they are running X while I knew that would not be possible has been pretty
> high.

Ok, fair enough.

> > >  	if (!query_hypervisor_presence()) {
> > > -		DPRINT_ERR(VMBUS, "No Windows hypervisor detected!!");
> > > +		pr_err("%s: %s No Hyper-V detected", VMBUS_MOD, __func__);
> > 
> > Why the __func__?  That should never be needed as it is trivial to see
> > what is happening, the user doesn't need to know the function name,
> > right?
> > 
> > Please remove them from all of these calls.
> 
> The new patch will have these removed. When I checked other drivers 
> in the drivers subdirectory the __func__ is used 15455 times most
> of these are in print, debug or error lines. The __func__ in this
> case only shows up if an error occurs. 
> 
> But as requested, I will remove them.

Thanks.

> > Oh, and you obviously didn't test these patches as your syslog would be
> > a mess if you did.  Which is NOT ok, and makes me grumpy:
> > 	http://www.kroah.com/log/linux/maintainer-05.html
> > 
> > bah, I should just make a numbered list and just start saying: "This
> > patch fails point #4" or something like that, it would save me in
> > typing...
> > 
> 
> They where compile and run tested. And syslog was not a mess. What did
> I mess up here? The amount of printouts now are a fraction of what they
> where before.

You forgot to put '\n' at the end of all of your pr_XXX lines, so they
will be merged with the next one, messing up your syslog.  Joe also
pointed this problem out.

Take a look at your syslog to see what I am talking about...

thanks,

greg k-h
