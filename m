Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab0GNRTN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 13:19:13 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:32420 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751786Ab0GNRTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 13:19:11 -0400
Date: Wed, 14 Jul 2010 10:19:10 -0700 (PDT)
From: Shreyas Bhatewara <sbhatewara@vmware.com>
X-X-Sender: sbhatewara@localhost.localdomain
To: Greg KH <greg@kroah.com>
cc: Christoph Hellwig <hch@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Pankaj Thakkar <pthakkar@vmware.com>,
        "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [Pv-drivers] RFC: Network Plugin Architecture (NPA) for
 vmxnet3
In-Reply-To: <20100714094952.GA16209@kroah.com>
Message-ID: <alpine.LRH.2.00.1007141015330.1613@localhost.localdomain>
References: <20100504230225.GP8323@vmware.com> <201005051029.42052.dtor@vmware.com> <20100505173120.GA1752@infradead.org> <201005051035.29831.dtor@vmware.com> <20100505173951.GA8388@infradead.org> <20100505105253.0a8bc465@nehalam> <20100506202113.GC17922@infradead.org>
 <1278990388.32650.22.camel@eng-rhel5-64> <20100714094952.GA16209@kroah.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 Jul 2010, Greg KH wrote:

> On Mon, Jul 12, 2010 at 08:06:28PM -0700, Shreyas Bhatewara wrote:
> >  drivers/net/vmxnet3/vmxnet3_drv.c     | 1845
> > +++++++++++++++++++--------------
> 
> Your patch is line-wrapped and can not be applied :(
> 
> Care to fix your email client?
> 
> One thing just jumped out at me when glancing at this:
> 
> > +static INLINE void
> > +MoveMemory(void *dst,
> > +		void *src,
> > +		size_t length)
> > +{
> > +	size_t i;
> > +	for (i = 0; i < length; ++i)
> > +		((u8 *)dst)[i] = ((u8 *)src)[i];
> > +}
> > +
> > +static INLINE void
> > +ZeroMemory(void *memory,
> > +		size_t length)
> > +{
> > +	size_t i;
> > +	for (i = 0; i < length; ++i)
> > +		((u8 *)memory)[i] = 0;
> > +}
> 
> Is there some reason that our in-kernel functions that do this type of
> logic are not working for you to require you to reimplement this?
> 
> thanks,
> 
> greg k-h
> 

Greg,

Thanks for pointing out. I will fix both these issues and repost the patch.

->Shreyas
