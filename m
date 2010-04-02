Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977Ab0DBAbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 20:31:48 -0400
Received: from sous-sol.org ([216.99.217.87]:36998 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751565Ab0DBAbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 20:31:45 -0400
Date: Thu, 1 Apr 2010 17:30:34 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Joerg Roedel <joro@8bytes.org>, Neil Horman <nhorman@redhat.com>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       hbabu@us.ibm.com, iommu@lists.linux-foundation.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] amd iommu: force flush of iommu prior during shutdown
Message-ID: <20100402003034.GX29241@sequoia.sous-sol.org>
References: <m1wrwsuxn9.fsf@fess.ebiederm.org> <20100331191811.GD13406@hmsreliant.think-freely.org> <m1sk7guv5u.fsf@fess.ebiederm.org> <20100331202745.GE13406@hmsreliant.think-freely.org> <20100401142902.GF24846@8bytes.org> <20100401144736.GA14069@shamino.rdu.redhat.com> <20100401155643.GG24846@8bytes.org> <20100401171149.GH13603@shamino.rdu.redhat.com> <20100401201433.GK24846@8bytes.org> <20100402000012.GA8930@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100402000012.GA8930@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Neil Horman (nhorman@tuxdriver.com) wrote:
> On Thu, Apr 01, 2010 at 10:14:34PM +0200, Joerg Roedel wrote:
> > On Thu, Apr 01, 2010 at 01:11:49PM -0400, Neil Horman wrote:
> > > On Thu, Apr 01, 2010 at 05:56:43PM +0200, Joerg Roedel wrote:
> > 
> > > > The possible fix will be to enable the hardware earlier in the
> > > > initialization path.
> > > > 
> > > That sounds like a reasonable theory, I'll try hack something together
> > > shortly.
> > 
> > Great. So the problem might be already fixed when I am back in the
> > office ;-)
> > 
> Don't hold your breath, but I'll try my best :)

The problem we had before was a combo of not clearing PDE and not having
the command buffer set up properly.  Now we have basically the same
problem.  The attach is running too early, so the invalidate commands
are falling on deaf ears.

thanks,
-chris
