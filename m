Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429Ab0FBK0e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 06:26:34 -0400
Received: from 8bytes.org ([88.198.83.132]:58531 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932327Ab0FBK0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 06:26:32 -0400
Date: Wed, 2 Jun 2010 12:26:31 +0200
From: Joerg Roedel <joro@8bytes.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Tom Lyon <pugs@cisco.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chrisw@sous-sol.org,
       hjk@linutronix.de, gregkh@suse.de, aafabbri@cisco.com,
       scofeldm@cisco.com
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
Message-ID: <20100602102630.GH964@8bytes.org>
References: <20100530145309.GO27611@redhat.com> <4C03A285.7060902@redhat.com> <20100531171007.GA6516@redhat.com> <4C04C085.1030107@redhat.com> <20100601095532.GA9178@redhat.com> <4C04E0E0.3070006@redhat.com> <20100601104651.GA9415@redhat.com> <4C050013.2020701@redhat.com> <20100602094527.GD964@8bytes.org> <20100602101534.GC29023@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100602101534.GC29023@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 01:15:34PM +0300, Michael S. Tsirkin wrote:
> One of the issues I see with the current patch is that
> it uses the mlock rlimit to do this pinning. So this wastes the rlimit
> for an app that did mlockall already, and also consumes
> this resource transparently, so an app might call mlock
> on a small buffer and be surprised that it fails.
> 
> Using mmu notifiers might help?

MMU notifiers are problematic because they are designed for situations
where we can do demand paging. The invalidate_range_start and
invalidate_range_end functions are not only called on munmap, they also
run when mprotect is called (in which case we don't want to tear down
iommu mappings). So what may happen with mmu notifiers is that we
accidentially tear down iommu mappings. With demand-paging this is no
problem because the io-ptes could be re-faulted. But that does not work
here.

	Joerg

