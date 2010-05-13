Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab0EMHBL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 03:01:11 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:21089
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752664Ab0EMHBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 03:01:07 -0400
X-SpamScore: -13
X-BigFish: VPS-13(zz1432P98dNzz1202hzz6d525hz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L2CJHE-02-AKU-02
X-M-MSG: 
Date: Thu, 13 May 2010 09:01:13 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Jiri Kosina <jkosina@suse.cz>
CC: "H. Peter Anvin" <hpa@zytor.com>, Greg KH <greg@kroah.com>,
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
Message-ID: <20100513070113.GA25184@aftab>
References: <alpine.LNX.2.00.1005051736080.9849@pobox.suse.cz>
 <20100505180228.GC15804@aftab>
 <alpine.LNX.2.00.1005052328000.9849@pobox.suse.cz>
 <20100506081721.GA20616@aftab>
 <alpine.LNX.2.00.1005061532390.9849@pobox.suse.cz>
 <20100506141358.GB20994@aftab>
 <20100512231906.GB3588@kroah.com>
 <4BEB3A77.1020907@zytor.com>
 <4BEB3CD5.9060803@zytor.com>
 <alpine.LNX.2.00.1005130723120.28092@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1005130723120.28092@pobox.suse.cz>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Einsteinring_24=2C_85609_Dornach_bei_M=FCnchen=2C_Gesc?=
	=?iso-8859-1?Q?h=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuliano_Meroni=2C?=
	=?iso-8859-1?Q?_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_Aschheim=2C_La?=
	=?iso-8859-1?Q?ndkreis_M=FCnchen=2C_Registergericht_M=FCnchen?=
	=?iso-8859-1?Q?=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>
Date: Thu, May 13, 2010 at 01:26:15AM -0400

> On Wed, 12 May 2010, H. Peter Anvin wrote:
> 
> > >>> So if K8_NB has failed initializing for some reason, we never go near
> > >>> the pci devs and the node_to_k8_nb_misc() calls since we effectively
> > >>> disable the L3 functionality.
> > >>>
> > >>> Thus the NULL pointer checks you remove in the patch below are
> > >>> superfluous, I agree, and I have already removed those in my tree along
> > >>> with the other improvements/fixes I'm working on right now.
> > >>
> > >> So, was there ever a patch applied that fixed the bug that Jiri found in
> > >> the stable kernels with this original patch that I could apply?
> > >>
> > > 
> > > Sounds like this patch in -tip should be promoted to mainline/stable...
> > > could the AMD people please confirm?
> > > 
> > 
> > Specifically, "waiting to hit mainline" is not an option since they are
> > currently queued for .35, but we need a minimal fix in .34 -- this is
> > the "stable backport".  If this "stable backport" is simply a subset of
> > the patch series then let me know which ones should be moved to urgent
> > and sent to Linus immediately.  I obviously don't have access to a setup
> > which can replicate this particular problem.
> 
> One is already there -- 0e152cd7c16832bd5cadee0c2e41d9959bc9b6f9. This 
> particular one solely was enough to fix the problem I have been hitting.
> 
> Plus there is f2b20e41407fccfcf ("x86, cacheinfo: Turn off L3 cache 
> index disable feature in virtualized environments") in -tip tree, which 
> fixes a crash of similar nature I have been seeing on bare metal, but for 
> virtualized environments.
> This one might be considered for .34/stable still.

Correct, so 0e152cd7c16832bd5cadee0c2e41d9959bc9b6f9 is in mainline and
makes sure we cache the k8 northbridges before using them in other code
and f2b20e41407fccfcf is an early-exit kludge in case we're running
as a guest and we get no northbirdge PCI devices exported from the
hypervisor.

And Peter you're right, "waiting for mainline" is not an excuse here,
the last one (f2b20e41407fccfcf) should've been sent to Linus right
away. However, he said -rc7 is gonna be the last one so I'm hoping
there's still time to get it in.

Thanks.

-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center

