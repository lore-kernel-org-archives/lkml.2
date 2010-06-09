Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab0FIQLe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 12:11:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000Ab0FIQLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 12:11:32 -0400
Date: Wed, 9 Jun 2010 19:05:50 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Tom Lyon <pugs@cisco.com>
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       chrisw@sous-sol.org, joro@8bytes.org, hjk@linutronix.de, avi@redhat.com,
       gregkh@suse.de, aafabbri@cisco.com, scofeldm@cisco.com
Subject: Re: [PATCH V2] VFIO driver: Non-privileged user level PCI drivers
Message-ID: <20100609160550.GA22312@redhat.com>
References: <4c0eb470.1HMjondO00NIvFM6%pugs@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c0eb470.1HMjondO00NIvFM6%pugs@cisco.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 08, 2010 at 02:21:52PM -0700, Tom Lyon wrote:
> +	case VFIO_DOMAIN_UNSET:
> +		vfio_domain_unset(vdev);
> +		ret = 0;
> +		break;
> +

What if I do:
SET
mmap
UNSET

Now I have access to device which is not behind an iommu.
Simplest solution is to remove the UNSET ioctl:
it's not terribly useful anyway.

-- 
MST
