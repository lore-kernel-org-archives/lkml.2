Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab2D3Mia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 08:38:30 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:40035 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab2D3Mi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 08:38:28 -0400
Date: Mon, 30 Apr 2012 14:38:19 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Mark Gross <mark.gross@intel.com>,
        Jason Uhlenkott <juhlenko@akamai.com>,
        Tim Small <tim@buttersideup.com>,
        Ranganathan Desikan <ravi@jetztechnologies.com>,
        "Arvind R." <arvino55@gmail.com>, Olof Johansson <olof@lixom.net>,
        Egor Martovetsky <egor@pasemi.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Michal Marek <mmarek@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, Joe Perches <joe@perches.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hitoshi Mitake <h.mitake@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Niklas =?iso-8859-1?Q?S=F6derlund?= 
	<niklas.soderlund@ericsson.com>,
        Shaohui Xie <Shaohui.Xie@freescale.com>,
        Josh Boyer <jwboyer@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH EDACv16 1/2] edac: Change internal representation to work
 with layers
Message-ID: <20120430123819.GF9303@aftab.osrc.amd.com>
References: <1335289087-11337-1-git-send-email-mchehab@redhat.com>
 <1335291342-14922-1-git-send-email-mchehab@redhat.com>
 <20120427133304.GE9626@aftab.osrc.amd.com>
 <4F9ABCEC.9090807@redhat.com>
 <20120428090523.GD26065@aftab.osrc.amd.com>
 <4F9D46F8.1020104@redhat.com>
 <20120430081513.GD8182@aftab.osrc.amd.com>
 <4F9E7059.5070804@redhat.com>
 <20120430111126.GD9303@aftab.osrc.amd.com>
 <4F9E7B45.8010908@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9E7B45.8010908@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 08:45:09AM -0300, Mauro Carvalho Chehab wrote:
> Em 30-04-2012 08:11, Borislav Petkov escreveu:
> > On Mon, Apr 30, 2012 at 07:58:33AM -0300, Mauro Carvalho Chehab wrote:
> 
> >> For example, this is the mapping used by the second memory controller of the SB machine
> >> I'm using on my tests:
> >>
> >> [52803.640043] EDAC DEBUG: sbridge_probe: Registering MC#1 (2 of 2)
> >> ...
> >> [52803.640062] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc(): allocating 7196 bytes for mci data (12 dimms, 12 csrows/channels)
> >> [52803.640070] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: initializing 12 dimms
> >> [52803.640072] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 0: dimm0 (0:0:0): row 0, chan 0
> >> [52803.640074] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 1: dimm1 (0:1:0): row 0, chan 1
> >> [52803.640077] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 2: dimm2 (0:2:0): row 0, chan 2
> >> [52803.640080] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 3: dimm3 (1:0:0): row 0, chan 3
> >> [52803.640083] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 4: dimm4 (1:1:0): row 1, chan 0
> >> [52803.640086] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 5: dimm5 (1:2:0): row 1, chan 1
> >> [52803.640089] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 6: dimm6 (2:0:0): row 1, chan 2
> >> [52803.640092] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 7: dimm7 (2:1:0): row 1, chan 3
> >> [52803.640095] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 8: dimm8 (2:2:0): row 2, chan 0
> >> [52803.640098] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 9: dimm9 (3:0:0): row 2, chan 1
> >> [52803.640101] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 10: dimm10 (3:1:0): row 2, chan 2
> >> [52803.640104] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 11: dimm11 (3:2:0): row 2, chan 3
> >>
> >> With the above info, it is clear that the DIMM located at mc#1, channel#3 slot#2 is
> >> called "dimm11" at the new API, and corresponds to "csrow 2, channel 3" for a legacy
> >> EDAC API call.
> > 
> > Are all those DIMM slots above populated? What happens if they're not,
> > are you issuing the same dimm0-dimm11 lines for slots which aren't even
> > populated?
> > 
> > I have a much better idea: Generally, this debug info should come from
> > the specific driver that allocates the dimm descriptors, not from the
> > EDAC core. This way, you know in the driver which slots are populated
> > and those which are not should be omitted.
> 
> The drivers don't allocate the dimm descriptors. They're allocated by the
> core.

I know that. The drivers call into EDAC core using edac_mc_alloc, this
is what I meant above.

> > This way it says "initializing 12 dimms" and the user thinks there are
> > 12 DIMMs on his system where this might not be true.
> 
> 
> I'm OK to remove the "initializing 12 dimms" message. It doesn't add anything
> new.
> 
> With regards do the other messages, if the debug messages are not clear, 
> then let's fix them, instead of removing. What if we print, instead,
> on a message like:
> 
> 	"row 1, chan 1 will represent dimm5 (1:2:0) if not empty"

How about the following instead: the specific driver calls
edac_mc_alloc(), it gets the allocated dimm array in mci->dimms
_without_ dumping each dimm%d line. Then, each driver figures out which
subset of that dimms array actually has populated slots and prints only
the populated rank/slot/...

This information is much more valuable than saying how many _possible_
slots the edac core has allocated.

Then, each driver can decide whether it makes sense to dump that info or
not.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
