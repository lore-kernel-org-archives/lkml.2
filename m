Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757681Ab0FBJmF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 05:42:05 -0400
Received: from 8bytes.org ([88.198.83.132]:54220 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509Ab0FBJmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 05:42:04 -0400
Date: Wed, 2 Jun 2010 11:42:01 +0200
From: Joerg Roedel <joro@8bytes.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Tom Lyon <pugs@cisco.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chrisw@sous-sol.org,
       hjk@linutronix.de, gregkh@suse.de, aafabbri@cisco.com,
       scofeldm@cisco.com
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
Message-ID: <20100602094201.GC964@8bytes.org>
References: <4C025999.7080706@redhat.com> <20100530124949.GI27611@redhat.com> <4C0261C1.9090204@redhat.com> <20100530130332.GM27611@redhat.com> <4C026497.8070901@redhat.com> <20100530145309.GO27611@redhat.com> <4C03A285.7060902@redhat.com> <20100531171007.GA6516@redhat.com> <4C04C085.1030107@redhat.com> <20100601095532.GA9178@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100601095532.GA9178@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 01, 2010 at 12:55:32PM +0300, Michael S. Tsirkin wrote:

> There seems to be some misunderstanding.  The userspace interface
> proposed forces a separate domain per device and forces userspace to
> repeat iommu programming for each device.  We are better off sharing a
> domain between devices and programming the iommu once.
> 
> The natural way to do this is to have an iommu driver for programming
> iommu.

IMO a seperate iommu-userspace driver is a nightmare for a userspace
interface. It is just too complicated to use. We can solve the problem
of multiple devices-per-domain with an ioctl which allows binding one
uio-device to the address-space on another. Thats much simpler.

	Joerg

