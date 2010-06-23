Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721Ab0FWQda (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 12:33:30 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:35774 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab0FWQd2 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 23 Jun 2010 12:33:28 -0400
Date: Wed, 23 Jun 2010 12:32:23 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Alex Williamson <alex.williamson@redhat.com>, ebiederm@xmission.com
Cc: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       iommu@lists.linux-foundation.org, albert_herranz@yahoo.es,
       x86@kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] Xen-SWIOTBL v0.8.3 used for Xen PCI pass through for PV
 guests.
Message-ID: <20100623163223.GA4255@phenom.dumpdata.com>
References: <1277235772-26757-1-git-send-email-konrad.wilk@oracle.com>
 <1277241805.4669.691.camel@x201>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277241805.4669.691.camel@x201>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090201.4C223748.0028:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The end user of this is the Xen PCI frontend and Xen PCI [1] which
> > require a DMA API "backend" that understands Xen's MMU. This allows the
> > PV domains to use PCI devices.
> 
> Hi Konrad,

Hey Alex,

Congratulations on your new job at Red Hat!
> 
> Sorry if I missed it, but I didn't see any mention or apparent
> requirement of a hardware iommu in xen for this code.  Is that true?  If

Ah, I completely missed to put that in the writeup (and as well some
other things that I thought off overnight). The answer is: both.

You can run this without an IOMMU in which case the security threat you
mentioned is feasible. Or you can run with an hardware IOMMU, if you
pass in the iommu=pv argument to the Xen hypervisor.

> so, is there anything to stop a PV guest with ownership of a DMA capable
> PCI device from reading all sorts of memory that the domain wouldn't
> otherwise have access to?  I was under the impression that the old PCI
> front/back for PV guests was mainly an interesting hack with limited
> applications due to security.  Thanks,

I thought as well but it looks as many folks are using it. The other
thing that I forgot to mention in the writeup are these two other use cases:

 1) One of them is the privileged PV (PPV?) domain drivers. This
    idea came about a year ago and was suggested on LKML by Eric
    Biederman. I can't find the link to it thought. Eric,
    would you by any chance remember it?

    The idea is to have multiple PPV domains which serve specific
    device drivers. An implementation using the hardware IOMMU is the
    Qubes OS (http://quebes-os.org), while this would be the same but
    using PV guests.

 2) Xen Dom0 support. Without the SWIOTLB-Xen patchset Dom0 is incapable
    of working with PCI devices.
