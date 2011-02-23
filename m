Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab1BWTlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 14:41:31 -0500
Received: from mail3.microsoft.com ([131.107.115.214]:25814 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab1BWTla convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 14:41:30 -0500
From: Hank Janssen <hjanssen@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: Haiyang Zhang <haiyangz@microsoft.com>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "KY Srinivasan" <kys@microsoft.com>
Subject: RE: [PATCH 2/6] Staging: hv: hv.c Removed all DPRINT and debug -
 using pr_err now
Thread-Topic: [PATCH 2/6] Staging: hv: hv.c Removed all DPRINT and debug -
 using pr_err now
Thread-Index: AQHL0ueeEyAMD95LDk2oP6NgPzLQI5QP/GKA//99kOA=
Date: Wed, 23 Feb 2011 19:41:28 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C56233FADA94@TK5EX14MBXC118.redmond.corp.microsoft.com>
References: <1298417565-12356-1-git-send-email-hjanssen@microsoft.com>
 <1298417565-12356-2-git-send-email-hjanssen@microsoft.com>
 <20110223191533.GB1030@kroah.com>
In-Reply-To: <20110223191533.GB1030@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.79]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Wednesday, February 23, 2011 11:16 AM
> 
> On Tue, Feb 22, 2011 at 03:32:41PM -0800, Hank Janssen wrote:
> > This group of patches removes all DPRINT from hv_vmbus.ko.
> > It is divided in several patches due to size.
> >
> > All DPRINT calls have been removed, and where needed have been
> > replaced with pr_XX native calls. Many debug DPRINT calls have
> > been removed outright.
> >
> > The amount of clutter this driver prints has been
> > significantly reduced.
> >
> > Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> >
> > ---
> >  drivers/staging/hv/hv.c |   88 +++++++++++--------------------------
> ---------
> >  1 files changed, 21 insertions(+), 67 deletions(-)

> > -		DPRINT_INFO(VMBUS, "OS Build:%d-%d.%d-%d-%d.%d",\
> > -			    eax,
> > -			    ebx >> 16,
> > -			    ebx & 0xFFFF,
> > -			    ecx,
> > -			    edx >> 24,
> > -			    edx & 0xFFFFFF);
> > +
> > +		pr_info("%s: Hyper-V Host OS Build:%d-%d.%d-%d-%d.%d",
> > +			VMBUS_MOD,
> > +			eax,
> > +			ebx >> 16,
> > +			ebx & 0xFFFF,
> > +			ecx,
> > +			edx >> 24,
> > +			edx & 0xFFFFFF);
> 
> Why did you keep this one?  Why is it needed?

This tells me what version the host is running. I frequently ask customers if 
they are running on Host version X or Y. This tells me that with certainty 
what they are running. The number of times I got from a customer that
they are running X while I knew that would not be possible has been pretty
high.

> 
> >  	if (!query_hypervisor_presence()) {
> > -		DPRINT_ERR(VMBUS, "No Windows hypervisor detected!!");
> > +		pr_err("%s: %s No Hyper-V detected", VMBUS_MOD, __func__);
> 
> Why the __func__?  That should never be needed as it is trivial to see
> what is happening, the user doesn't need to know the function name,
> right?
> 
> Please remove them from all of these calls.

The new patch will have these removed. When I checked other drivers 
in the drivers subdirectory the __func__ is used 15455 times most
of these are in print, debug or error lines. The __func__ in this
case only shows up if an error occurs. 

But as requested, I will remove them.

> 
> Oh, and you obviously didn't test these patches as your syslog would be
> a mess if you did.  Which is NOT ok, and makes me grumpy:
> 	http://www.kroah.com/log/linux/maintainer-05.html
> 
> bah, I should just make a numbered list and just start saying: "This
> patch fails point #4" or something like that, it would save me in
> typing...
> 

They where compile and run tested. And syslog was not a mess. What did
I mess up here? The amount of printouts now are a fraction of what they
where before.

Hank.




