Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715Ab0FBJp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 05:45:29 -0400
Received: from 8bytes.org ([88.198.83.132]:34390 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754496Ab0FBJp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 05:45:28 -0400
Date: Wed, 2 Jun 2010 11:45:27 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Avi Kivity <avi@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Tom Lyon <pugs@cisco.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chrisw@sous-sol.org,
       hjk@linutronix.de, gregkh@suse.de, aafabbri@cisco.com,
       scofeldm@cisco.com
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
Message-ID: <20100602094527.GD964@8bytes.org>
References: <20100530130332.GM27611@redhat.com> <4C026497.8070901@redhat.com> <20100530145309.GO27611@redhat.com> <4C03A285.7060902@redhat.com> <20100531171007.GA6516@redhat.com> <4C04C085.1030107@redhat.com> <20100601095532.GA9178@redhat.com> <4C04E0E0.3070006@redhat.com> <20100601104651.GA9415@redhat.com> <4C050013.2020701@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C050013.2020701@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 01, 2010 at 03:41:55PM +0300, Avi Kivity wrote:
> On 06/01/2010 01:46 PM, Michael S. Tsirkin wrote:

>> Main difference is that vhost works fine with unlocked
>> memory, paging it in on demand. iommu needs to unmap
>> memory when it is swapped out or relocated.
>>
> So you'd just take the memory map and not pin anything.  This way you  
> can reuse the memory map.
>
> But no, it doesn't handle the dirty bitmap, so no go.

IOMMU mapped memory can not be swapped out because we can't do demand
paging on io-page-faults with current devices. We have to pin _all_
userspace memory that is mapped into an IOMMU domain.

	Joerg

