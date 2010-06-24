Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab0FXPIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 11:08:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755876Ab0FXPIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 11:08:49 -0400
Date: Thu, 24 Jun 2010 18:03:35 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Tom Lyon <pugs@lyon-about.com>, randy.dunlap@oracle.com,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chrisw@sous-sol.org,
       hjk@linutronix.de, avi@redhat.com, gregkh@suse.de, aafabbri@cisco.com,
       scofeldm@cisco.com
Subject: Re: [PATCH V2] VFIO driver: Non-privileged user level PCI drivers
Message-ID: <20100624150335.GA10501@redhat.com>
References: <4c0eb470.1HMjondO00NIvFM6%pugs@cisco.com> <201006111515.53562.pugs@lyon-about.com> <20100613102339.GB4191@redhat.com> <201006171414.00878.pugs@lyon-about.com> <20100624122219.GD20761@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100624122219.GD20761@8bytes.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 02:22:19PM +0200, Joerg Roedel wrote:
> On Thu, Jun 17, 2010 at 02:14:00PM -0700, Tom Lyon wrote:
> > On Sunday 13 June 2010 03:23:39 am Michael S. Tsirkin wrote:
> 
> > OK, after more investigation, I realize you are right.
> > We definitely need the IOMMU protection for interrupts, and
> > if we have it, a lot of the code for config space protection is pointless.
> > It does seem that the Intel  intr_remapping code does what we want
> > (accidentally) but that the AMD iommu code does not yet do any
> > interrupt remapping.  Joerg - can you comment? On the roadmap?
> 
> Work on this is planned, but not at a high priority by now. I can
> re-prioritize this item if needed.
> 
> 	Joerg

As a stop-gap measure, we could get by with a
portable API that let us figure out whether a given iommu supports
interrupt remapping.

-- 
MST
