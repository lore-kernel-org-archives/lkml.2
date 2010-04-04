Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab0DDIon (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 04:44:43 -0400
Received: from 8bytes.org ([88.198.83.132]:33294 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542Ab0DDIoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 04:44:37 -0400
Date: Sun, 4 Apr 2010 10:44:36 +0200
From: Joerg Roedel <joro@8bytes.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Chris Wright <chrisw@sous-sol.org>, Joerg Roedel <joerg.roedel@amd.com>,
       nhorman@redhat.com, nhorman@tuxdriver.com, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, hbabu@us.ibm.com,
       iommu@lists.linux-foundation.org, vgoyal@redhat.com
Subject: Re: [PATCH 3/4] Revert "x86: disable IOMMUs on kernel crash"
Message-ID: <20100404084435.GT24846@8bytes.org>
References: <20100403012751.834020949@sous-sol.org> <20100403012820.229410717@sous-sol.org> <20100403172224.GO24846@8bytes.org> <m18w94l9c9.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m18w94l9c9.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 03, 2010 at 10:44:22AM -0700, Eric W. Biederman wrote:
> Joerg Roedel <joro@8bytes.org> writes:

> > Hmm, I think for this we need to change the gart code too and disable
> > the gart before its initialization runs to not re-introduce issues fixed
> > in commit bc2cea6a34fdb30f118ec75db39a46a191870607, no?
> 
> That is a different code path with a different set of assumptions and
> restrictions.  On a normal kexec of course we want to do an orderly shutdown.

Thats another problem with this patch. It introduces a difference
between the panic-shutdown kexec and the ordinary kexec.

> For the gart with a little luck we can just ignore it on kexec on
> panic.

The commit I mentioned above already proves this assumption wrong.

> Unlike a virtualization capable iommu it doesn't prevent access
> to devices, when it is enabled.   Worst case is that we have to start
> including iommu=off for gart systems.

No no no. This is a maintenance nightmare for almost everybody. Where do
you want to Document this special cases that 'if kernel uses gart then
and only then boot the kexec kernel with iommu=off'.
Always passing iommu=off to the kexec kernel doesn't work too for
obvious reasons.

> The best case is that we can figure out how to have the gart code
> reinitialize itself sanely, starting from some arbitrary point.

Yes, that is missing in this patch. But to keep changes small and don't
bother with the gart code at all I suggest to remove the shutdown
routine from the amd-iommu code only and not the whole shutdown call in
the machine_crash_shutdown path.

	Joerg

