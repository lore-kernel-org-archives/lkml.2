Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618Ab2K0AqA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 19:46:00 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:50845 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754753Ab2K0Ap7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 19:45:59 -0500
From: Dmitry Torokhov <dtor@vmware.com>
To: pv-drivers@vmware.com
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [Pv-drivers] [PATCH 12/12] VMCI: Some header and config files.
Date: Mon, 26 Nov 2012 16:45:58 -0800
Message-ID: <1733473.DLmiAWnRYk@dtor-d630.eng.vmware.com>
Organization: VMware, Inc.
User-Agent: KMail/4.9.2 (Linux/3.7.0-rc6+; KDE/4.9.2; x86_64; ; )
In-Reply-To: <20121127003239.GA32298@kroah.com>
References: <20121107183624.9658.78903.stgit@promb-2n-dhcp175.eng.vmware.com> <20121127002357.GA27683@core.coreip.homeip.net> <20121127003239.GA32298@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 26, 2012 04:32:39 PM Greg KH wrote:
> On Mon, Nov 26, 2012 at 04:23:57PM -0800, Dmitry Torokhov wrote:
> > Hi Greg,
> > 
> > For some reason it still didn't go through to our corporate mail server
> > but I see it on LKML.
> 
> Good.
> 
> > On Mon, Nov 26, 2012 at 04:03:04PM -0800, Greg KH wrote:
> > > On Wed, Nov 07, 2012 at 10:43:03AM -0800, George Zhang wrote:
> > > > +static inline struct vmci_handle VMCI_MAKE_HANDLE(vmci_id cid,
> > > > vmci_id rid) +{
> > > > +	struct vmci_handle h;
> > > > +	h.context = cid;
> > > > +	h.resource = rid;
> > > > +	return h;
> > > > +}
> > > 
> > > You return a structure on the stack that just went away?  Yeah, I know
> > > it's an inline, but come on, that's not ok.
> > 
> > This is certainly OK even if it is not inline, we return the _value_,
> > not the pointer to the stacki memory. And yes, the structure is 64 bit
> > value so it is returned in registers.
> 
> Even on a 32bit processor? 

I thought it would, but it looks like it won't. Maybe we'll just switch it
to a macro with C99 style initializators to keep the same semantic but
avoid the question.

> Also, you already have another function that
> does this same thing, so having 2 functions in the same patch seems odd,
> right?

Yes, you can say that it is probably a bit excessive.

OK, now that we are on the same page we'll go and fix the issues.

Thanks,
Dmitry
