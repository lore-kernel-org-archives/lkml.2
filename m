Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374Ab0FBKUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 06:20:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932299Ab0FBKUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 06:20:00 -0400
Date: Wed, 2 Jun 2010 13:15:34 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Avi Kivity <avi@redhat.com>, Tom Lyon <pugs@cisco.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chrisw@sous-sol.org,
       hjk@linutronix.de, gregkh@suse.de, aafabbri@cisco.com,
       scofeldm@cisco.com
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
Message-ID: <20100602101534.GC29023@redhat.com>
References: <4C026497.8070901@redhat.com> <20100530145309.GO27611@redhat.com> <4C03A285.7060902@redhat.com> <20100531171007.GA6516@redhat.com> <4C04C085.1030107@redhat.com> <20100601095532.GA9178@redhat.com> <4C04E0E0.3070006@redhat.com> <20100601104651.GA9415@redhat.com> <4C050013.2020701@redhat.com> <20100602094527.GD964@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100602094527.GD964@8bytes.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 11:45:27AM +0200, Joerg Roedel wrote:
> On Tue, Jun 01, 2010 at 03:41:55PM +0300, Avi Kivity wrote:
> > On 06/01/2010 01:46 PM, Michael S. Tsirkin wrote:
> 
> >> Main difference is that vhost works fine with unlocked
> >> memory, paging it in on demand. iommu needs to unmap
> >> memory when it is swapped out or relocated.
> >>
> > So you'd just take the memory map and not pin anything.  This way you  
> > can reuse the memory map.
> >
> > But no, it doesn't handle the dirty bitmap, so no go.
> 
> IOMMU mapped memory can not be swapped out because we can't do demand
> paging on io-page-faults with current devices. We have to pin _all_
> userspace memory that is mapped into an IOMMU domain.
> 
> 	Joerg


One of the issues I see with the current patch is that
it uses the mlock rlimit to do this pinning. So this wastes the rlimit
for an app that did mlockall already, and also consumes
this resource transparently, so an app might call mlock
on a small buffer and be surprised that it fails.

Using mmu notifiers might help?


-- 
MST
