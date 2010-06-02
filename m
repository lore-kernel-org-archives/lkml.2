Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753Ab0FBKEI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 06:04:08 -0400
Received: from 8bytes.org ([88.198.83.132]:49988 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131Ab0FBKEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 06:04:07 -0400
Date: Wed, 2 Jun 2010 12:04:04 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Avi Kivity <avi@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Tom Lyon <pugs@cisco.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chrisw@sous-sol.org,
       hjk@linutronix.de, gregkh@suse.de, aafabbri@cisco.com,
       scofeldm@cisco.com
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
Message-ID: <20100602100404.GF964@8bytes.org>
References: <20100530145309.GO27611@redhat.com> <4C03A285.7060902@redhat.com> <20100531171007.GA6516@redhat.com> <4C04C085.1030107@redhat.com> <20100601095532.GA9178@redhat.com> <4C04E0E0.3070006@redhat.com> <20100601104651.GA9415@redhat.com> <4C050013.2020701@redhat.com> <20100602094527.GD964@8bytes.org> <4C062928.8040003@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C062928.8040003@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 12:49:28PM +0300, Avi Kivity wrote:
> On 06/02/2010 12:45 PM, Joerg Roedel wrote:
>> IOMMU mapped memory can not be swapped out because we can't do demand
>> paging on io-page-faults with current devices. We have to pin _all_
>> userspace memory that is mapped into an IOMMU domain.
>
> vhost doesn't pin memory.
>
> What I proposed is to describe the memory map using an object (fd), and  
> pass it around to clients that use it: kvm, vhost, vfio.  That way you  
> maintain the memory map in a central location and broadcast changes to  
> clients.  Only a vfio client would result in memory being pinned.

Ah ok, so its only about the database which keeps the mapping
information.

> It can still work, but the interface needs to be extended to include  
> dirty bitmap logging.

Thats hard to do. I am not sure about VT-d but the AMD IOMMU has no
dirty-bits in the page-table. And without demand-paging we can't really
tell what pages a device has written to. The only choice is to mark all
IOMMU-mapped pages dirty as long as they are mapped.

	Joerg

