Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758852Ab0DAUOh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 16:14:37 -0400
Received: from 8bytes.org ([88.198.83.132]:53315 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316Ab0DAUOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 16:14:35 -0400
Date: Thu, 1 Apr 2010 22:14:34 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Neil Horman <nhorman@redhat.com>
Cc: Neil Horman <nhorman@tuxdriver.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, hbabu@us.ibm.com,
       iommu@lists.linux-foundation.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] amd iommu: force flush of iommu prior during shutdown
Message-ID: <20100401201433.GK24846@8bytes.org>
References: <20100331155430.GF14011@redhat.com> <20100331182824.GC13406@hmsreliant.think-freely.org> <m1wrwsuxn9.fsf@fess.ebiederm.org> <20100331191811.GD13406@hmsreliant.think-freely.org> <m1sk7guv5u.fsf@fess.ebiederm.org> <20100331202745.GE13406@hmsreliant.think-freely.org> <20100401142902.GF24846@8bytes.org> <20100401144736.GA14069@shamino.rdu.redhat.com> <20100401155643.GG24846@8bytes.org> <20100401171149.GH13603@shamino.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100401171149.GH13603@shamino.rdu.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 01:11:49PM -0400, Neil Horman wrote:
> On Thu, Apr 01, 2010 at 05:56:43PM +0200, Joerg Roedel wrote:

> > The possible fix will be to enable the hardware earlier in the
> > initialization path.
> > 
> That sounds like a reasonable theory, I'll try hack something together
> shortly.

Great. So the problem might be already fixed when I am back in the
office ;-)

> > This would only prevent possible data corruption. When the IOMMU is off
> > the devices will not get a target abort but will only write to different
> > physical memory locations. The window where a target abort can happen
> > starts when the kdump kernel re-enables the IOMMU and ends when the new
> > driver for that device attaches. This is a small window but there is not
> > a lot we can do to avoid this small time window.
> > 
> Can you explain this a bit further please?  From what I read, when the iommu is
> disabled, AIUI it does no translations.  That means that any dma addresses which
> the driver mapped via the iommu prior to a crash that are stored in devices will
> just get strobed on the bus without any translation.  If those dma address do
> not lay on top of any physical ram, won't that lead to bus errors, and
> transaction aborts?  Worse, if those dma addresses do lie on top of real
> physical addresses, won't we get corruption in various places?  Or am I missing
> part of how that works?

Hm, the device address may not be a valid host physical address, thats
true. But the problem with the small time-window when the IOMMU hardware
is re-programmed from the kdump kernel still exists.
I need to think about other possible side-effects of leaving the IOMMU
enabled on shutdown^Wboot into a kdump kernel.

	Joerg

