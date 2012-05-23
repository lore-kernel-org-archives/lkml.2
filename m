Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933412Ab2EWKkP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 06:40:15 -0400
Received: from 8bytes.org ([85.214.48.195]:38807 "EHLO
	h2027444.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167Ab2EWKkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 06:40:13 -0400
Date: Wed, 23 May 2012 12:40:09 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH 1/2] resources: set type of new resource returned by
 __request_region()
Message-ID: <20120523104009.GD12795@8bytes.org>
References: <20120518231238.31187.44571.stgit@bhelgaas.mtv.corp.google.com>
 <20120518231832.31187.10630.stgit@bhelgaas.mtv.corp.google.com>
 <20120521130451.GK2313@8bytes.org>
 <CAErSpo582Ok9arr+3krKTQdue4i3wQOixVkBbheDX6a3v8xMHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAErSpo582Ok9arr+3krKTQdue4i3wQOixVkBbheDX6a3v8xMHw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed May 23 12:40:10 2012
X-DSPAM-Confidence: 0.9991
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4fbcbe8a28387024012214
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 07:52:24AM -0600, Bjorn Helgaas wrote:
> On Mon, May 21, 2012 at 7:04 AM, Joerg Roedel <joro@8bytes.org> wrote:
> > On Fri, May 18, 2012 at 05:18:32PM -0600, Bjorn Helgaas wrote:
> >> Previously we returned a new struct resource with only IORESOURCE_BUSY
> >> set (and possibly IORESOURCE_MUXED or IORESOURCE_EXCLUSIVE), but no
> >> MEM/IO/etc. bits set.  The new resource should inherit the type of
> >> its parent.
> >
> > Should it? What about IORESOURCE_WINDOW for example? Any particular
> > reason for this change to the interface of the __request_region()
> > function?
> 
> Yes, I should have explained the connection :)  The next patch prints
> the resource returned from request_mem_region().  Without this
> __request_region() patch, that resource has no type, so %pR can't
> print it correctly.
> 
> Good question about IORESOURCE_WINDOW.  Maybe it should inherit only
> the IORESOURCE_TYPE_BITS part (IO/MEM/IRQ/DMA/BUS).  But it seemed
> like it should also inherit PREFETCH, READONLY, CACHEABLE, etc.  Maybe
> we should inherit everything but clear IORESOURCE_WINDOW?  I'm open to
> suggestions here.

I am still not sure whether the inheritance is a good idea. How about
changing the define of request_mem_region to:

#define request_mem_region(start,n,name) __request_region(&iomem_resource, (start), (n), (name), IORESOURCE_MEM)

?

	Joerg



