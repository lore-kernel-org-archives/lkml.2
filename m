Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab2IUOit (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 10:38:49 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:49183 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910Ab2IUOir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 10:38:47 -0400
Date: Fri, 21 Sep 2012 10:27:33 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Jan Beulich <JBeulich@suse.com>, Oliver Chick <oliver.chick@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [Xen-devel] [PATCH] Persistent grant maps for xen blk drivers
Message-ID: <20120921142733.GB3389@phenom.dumpdata.com>
References: <1348051887-21885-1-git-send-email-oliver.chick@citrix.com>
 <505AF126.2050806@citrix.com>
 <1348140637.24539.32.camel@oliverchick-Precision-WorkStation-T3400>
 <505B1EB9020000780009CA6E@nat28.tlf.novell.com>
 <505C5C54.4060100@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505C5C54.4060100@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 01:23:48PM +0100, David Vrabel wrote:
> On 20/09/12 12:48, Jan Beulich wrote:
> >>>> On 20.09.12 at 13:30, Oliver Chick <oliver.chick@citrix.com> wrote:
> >> The memory overhead, and fallback mode points are related:
> >> -Firstly, it turns out that the overhead is actually 2.75MB, not 11MB
> >> per device. I made a mistake (pointed out by Jan) as the maximum number
> >> of requests that can fit into a single-page ring is 64, not 256.
> >> -Clearly, this still scales linearly. So the problem of memory footprint
> >> will occur with more VMs, or block devices.
> >> -Whilst 2.75MB per device is probably acceptable (?), if we start using
> >> multipage rings, then we might not want to have
> >> BLKIF_MAX_PERS_REQUESTS_PER_DEVICE==__RING_SIZE, as this will cause the
> >> memory overhead to increase. This is why I have implemented the
> >> 'fallback' mode. With a multipage ring, it seems reasonable to want the
> >> first $x$ grefs seen by blkback to be treated as persistent, and any
> >> later ones to be non-persistent. Does that seem sensible?
> > 
> >>From a resource usage pov, perhaps. But this will get the guest
> > entirely unpredictable performance. Plus I don't think 11Mb of
> > _virtual_ space is unacceptable overhead in a 64-bit kernel. If
> > you really want/need this in a 32-bit one, then perhaps some
> > other alternatives would be needed (and persistent grants may
> > not be the right approach there in the first place).
> 
> It's not just virtual space.  blkback in pvops kernels allocates its
> pages from the balloon and if there aren't enough ballooned out pages it
> has to allocate real pages (releasing the MFN back to Xen).
> 
> Classic kernels didn't need to do this as there was an API for allocate
> new "empty" struct page's that get mapped into kernel space.

Can we ressurect/implement that in the new pvops? We could use the memory
hotplug mechanism to allocate "non-existent" memory. 
> 
> David
