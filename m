Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab0EMF0Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 01:26:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35700 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243Ab0EMF0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 01:26:22 -0400
Date: Thu, 13 May 2010 07:26:15 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg KH <greg@kroah.com>, Borislav Petkov <borislav.petkov@amd.com>,
       "Ostrovsky, Boris" <Boris.Ostrovsky@amd.com>,
       "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
       Greg KH <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>, Jiri Benc <jbenc@suse.cz>,
       Thomas Renninger <trenn@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "stable-review@kernel.org" <stable-review@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [stable] [113/197] x86, cacheinfo: Calculate L3 indices
In-Reply-To: <4BEB3CD5.9060803@zytor.com>
Message-ID: <alpine.LNX.2.00.1005130723120.28092@pobox.suse.cz>
References: <20100422190917.467545308@kvm.kroah.org> <alpine.LNX.2.00.1005051736080.9849@pobox.suse.cz> <20100505180228.GC15804@aftab> <alpine.LNX.2.00.1005052328000.9849@pobox.suse.cz> <20100506081721.GA20616@aftab> <alpine.LNX.2.00.1005061532390.9849@pobox.suse.cz>
 <20100506141358.GB20994@aftab> <20100512231906.GB3588@kroah.com> <4BEB3A77.1020907@zytor.com> <4BEB3CD5.9060803@zytor.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 May 2010, H. Peter Anvin wrote:

> >>> So if K8_NB has failed initializing for some reason, we never go near
> >>> the pci devs and the node_to_k8_nb_misc() calls since we effectively
> >>> disable the L3 functionality.
> >>>
> >>> Thus the NULL pointer checks you remove in the patch below are
> >>> superfluous, I agree, and I have already removed those in my tree along
> >>> with the other improvements/fixes I'm working on right now.
> >>
> >> So, was there ever a patch applied that fixed the bug that Jiri found in
> >> the stable kernels with this original patch that I could apply?
> >>
> > 
> > Sounds like this patch in -tip should be promoted to mainline/stable...
> > could the AMD people please confirm?
> > 
> 
> Specifically, "waiting to hit mainline" is not an option since they are
> currently queued for .35, but we need a minimal fix in .34 -- this is
> the "stable backport".  If this "stable backport" is simply a subset of
> the patch series then let me know which ones should be moved to urgent
> and sent to Linus immediately.  I obviously don't have access to a setup
> which can replicate this particular problem.

One is already there -- 0e152cd7c16832bd5cadee0c2e41d9959bc9b6f9. This 
particular one solely was enough to fix the problem I have been hitting.

Plus there is f2b20e41407fccfcf ("x86, cacheinfo: Turn off L3 cache 
index disable feature in virtualized environments") in -tip tree, which 
fixes a crash of similar nature I have been seeing on bare metal, but for 
virtualized environments.
This one might be considered for .34/stable still.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
