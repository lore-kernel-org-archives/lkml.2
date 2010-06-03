Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab0FCVpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 17:45:00 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:62729 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998Ab0FCVo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 17:44:59 -0400
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.53,357,1272844800"; 
   d="scan'208";a="206869295"
From: Tom Lyon <pugs@lyon-about.com>
To: Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
Date: Thu, 3 Jun 2010 14:41:38 -0700
User-Agent: KMail/1.9.9
Cc: Chris Wright <chrisw@sous-sol.org>, Joerg Roedel <joro@8bytes.org>,
       "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, hjk@linutronix.de, gregkh@suse.de,
       aafabbri@cisco.com, scofeldm@cisco.com
References: <20100601095532.GA9178@redhat.com> <20100602174615.GV8301@sequoia.sous-sol.org> <4C074A64.1000009@redhat.com>
In-Reply-To: <4C074A64.1000009@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201006031441.38799.pugs@lyon-about.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, in the interest of making progress, I am about to embark on the following:

1. Create a user-iommu-domain driver - opening it will give a new empty domain.
    Ultimately this can also populate sysfs with the state of its world, which would
    also be a good addition to the base iommu stuff.
    If someone closes the fd while in use, the domain stays valid anyway until users
    drop off.

2. Add DOMAIN_SET and DOMAIN_UNSET ioctls to the vfio driver.  Require that
   a domain be set before using the VFIO_DMA_MAP_IOVA ioctl (this is the one
   that KVM wants).  However, the VFIO_DMA_MAP_ANYWHERE ioctl is the one
   which uses the dma_sg interface which has no expicit control of domains. I
   intend to keep it the way it is, but expect only non-hypervisor programs would
   want to use it.

3. Clean up the docs and other nits that folks have found.

Comments? 
