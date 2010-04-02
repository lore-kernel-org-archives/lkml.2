Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759060Ab0DBBjh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 21:39:37 -0400
Received: from sous-sol.org ([216.99.217.87]:37994 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757780Ab0DBBjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 21:39:33 -0400
Date: Thu, 1 Apr 2010 18:38:27 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Neil Horman <nhorman@redhat.com>
Cc: Chris Wright <chrisw@sous-sol.org>, Joerg Roedel <joerg.roedel@amd.com>,
       Neil Horman <nhorman@tuxdriver.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, hbabu@us.ibm.com,
       iommu@lists.linux-foundation.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 1/2] x86/amd-iommu: enable iommu before attaching
	devices
Message-ID: <20100402013827.GA29241@sequoia.sous-sol.org>
References: <20100331202745.GE13406@hmsreliant.think-freely.org> <20100401142902.GF24846@8bytes.org> <20100401144736.GA14069@shamino.rdu.redhat.com> <20100401155643.GG24846@8bytes.org> <20100401171149.GH13603@shamino.rdu.redhat.com> <20100401201433.GK24846@8bytes.org> <20100402000012.GA8930@hmsreliant.think-freely.org> <20100402003034.GX29241@sequoia.sous-sol.org> <20100402012353.GY29241@sequoia.sous-sol.org> <20100402013513.GA2435@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100402013513.GA2435@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Neil Horman (nhorman@redhat.com) wrote:
> On Thu, Apr 01, 2010 at 06:23:53PM -0700, Chris Wright wrote:
> > Hit another kdump problem as reported by Neil Horman.  When initializaing
> > the IOMMU, we attach devices to their domains before the IOMMU is
> > fully (re)initialized.  Attaching a device will issue some important
> > invalidations.  In the context of the newly kexec'd kdump kernel, the
> > IOMMU may have stale cached data from the original kernel.  Because we
> > do the attach too early, the invalidation commands are placed in the new
> > command buffer before the IOMMU is updated w/ that buffer.  This leaves
> > the stale entries in the kdump context and can renders device unusable.
> > Simply enable the IOMMU before we do the attach.
> > 
> > Cc: Neil Horman <nhorman@tuxdriver.com>
> > Cc: Vivek Goyal <vgoyal@redhat.com>
> > Signed-off-by: Chris Wright <chrisw@sous-sol.org>
> 
> I'll test this out this weekend, thanks Chris!

Great, thanks!  I tested w/ both default and iommu=pt.  Both worked,
didn't spot any regressions.  But additional testing is very welcome.

thanks,
-chris
