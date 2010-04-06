Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537Ab0DFUp6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 16:45:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59872 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755649Ab0DFUpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 16:45:52 -0400
Date: Tue, 6 Apr 2010 16:39:56 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Chris Wright <chrisw@sous-sol.org>, Joerg Roedel <joro@8bytes.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bernhard Walle <bernhard@bwalle.de>, nhorman@redhat.com,
       nhorman@tuxdriver.com, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, hbabu@us.ibm.com,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH 3/4] Revert "x86: disable IOMMUs on kernel crash"
Message-ID: <20100406203956.GI3029@redhat.com>
References: <20100403012751.834020949@sous-sol.org> <20100403012820.229410717@sous-sol.org> <20100403174128.GQ24846@8bytes.org> <m1vdc8juju.fsf@fess.ebiederm.org> <4BB83EAE.5090609@bwalle.de> <20100404085338.GU24846@8bytes.org> <m17hond01n.fsf@fess.ebiederm.org> <20100404100101.GW24846@8bytes.org> <20100406174257.GG29241@sequoia.sous-sol.org> <20100406175106.GH28166@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100406175106.GH28166@amd.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 07:51:06PM +0200, Joerg Roedel wrote:
> On Tue, Apr 06, 2010 at 10:42:57AM -0700, Chris Wright wrote:
> > * Joerg Roedel (joro@8bytes.org) wrote:
> > > On Sun, Apr 04, 2010 at 02:44:36AM -0700, Eric W. Biederman wrote:
> > > > Joerg Roedel <joro@8bytes.org> writes:
> > > > 
> > > > > On Sun, Apr 04, 2010 at 09:24:30AM +0200, Bernhard Walle wrote:
> > > > >> Am 03.04.10 19:49, schrieb Eric W. Biederman:
> > > > >> > Not a problem.  We require a lot of things of the kdump kernel,
> > > > >> > and it is immediately apparent in a basic sanity test.
> > > > >> 
> > > > >> Also, in most cases (for example: distribution kernels), the kdump
> > > > >> kernel nowadays is identical to the running kernel. So, if the running
> > > > >> kernel has IOMMU support, the kdump kernel also has.
> > > > >
> > > > > Yes, I know. But is that a requirement for kexec?
> > > > 
> > > > For normal kexec no.  That path is expected to do a clean hardware
> > > > shutdown.
> > > > 
> > > > For kexec on panic aka kdump the requirement is that your your crash
> > > > kernel be able to initialize your hardware from any state it can be
> > > > put in.
> > > 
> > > Ok, if you show me where this is documented for everybody then I am
> > > probably convinced :-)
> > > We should fixup the gart initialization anyway.
> > 
> > So, you planning to pull in all 4 patches then?
> 
> Yes, I will apply them tomorrow and write a fix for the GART issue this
> may introduce.
> 

Hi Joerg,

Going through the old mail thread, I think the commit you pointed to was
primarily introduced to solve kexec + GART issue and not necessarily kdump
issue.

In fact disabling IOMMU patch was introduced by you.

Author: Joerg Roedel <joerg.roedel@amd.com>
Date:   Tue Jun 9 17:56:09 2009 +0200

    x86: disable IOMMUs on kernel crash
    
    If the IOMMUs are still enabled when the kexec kernel boots access to
    the disk is not possible. This is bad for tools like kdump or anything
    else which wants to use PCI devices.
    
    Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

I am assuming you introduced this patch because you faced issues with
amd-iommu and not GART.

So basically GART should have been working with kdump even before you
introduced disabling iommu patch in kdump path.

Thanks
Vivek
