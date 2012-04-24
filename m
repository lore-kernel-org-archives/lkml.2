Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab2DXQ1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 12:27:51 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:44924 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072Ab2DXQ1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 12:27:49 -0400
Date: Tue, 24 Apr 2012 18:27:43 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Tony Luck <tony.luck@intel.com>
Cc: Borislav Petkov <bp@amd64.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>
Subject: Re: [EDAC PATCH v13 6/7] edac.h: Prepare to handle with generic
 layers
Message-ID: <20120424162743.GU11559@aftab.osrc.amd.com>
References: <1334607133-30039-1-git-send-email-mchehab@redhat.com>
 <1334607133-30039-7-git-send-email-mchehab@redhat.com>
 <20120423174955.GH6147@aftab.osrc.amd.com>
 <4F959FDE.2070304@redhat.com>
 <20120424104059.GA11559@aftab.osrc.amd.com>
 <4F9692AD.8090000@redhat.com>
 <20120424125538.GC11559@aftab.osrc.amd.com>
 <4F96A696.40308@redhat.com>
 <20120424133242.GI11559@aftab.osrc.amd.com>
 <4F96B783.6060101@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F96B783.6060101@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 11:24:03AM -0300, Mauro Carvalho Chehab wrote:
> Yes (well, except that Nehalem has also a concept of "virtual channel", so
> calling it "virtual" can mislead into a different view).

No, it cannot. It is a very simple question: Am I looking at virtual
slots/channels or not, when I'm looking at edac-ctl output?

[..]

> > I hope you can understand my confusion now:
> > 
> > On the one hand, there are the physical slots where the DIMMs are
> > sticked into.
> > 
> > OTOH, there are the slots==ranks which the memory controllers use to
> > talk to the DIMMs.
> 
> This only applies to amd64 and other csrows-based memory controllers.
> 
> A memory controller like the one at Nehalem abstracts csrows (I suspect
> that they have internally something functionally similar to a FB-DIMM
> AMB internally). They do memory interleaving between the memory channels
> in order to produce a cachesize bigger than 64 bits, but they don't

You mean cacheline here.

> actually care about how many ranks are there on each DIMM.

This cannot be right - you need the chip select to talk to a rank.
This is basic DDR functionality.

I can imagine that they're doing some tricks like channel/chip
select/memory controller interleaving.

In the end of the day, it is smallest row that gives you 64 bits of
data.

@Tony: hey Tony, can you point us to an Intel document explaining how
Sandy Bridge or NH or one of the new ones does the memory addressing wrt
ranks, channels etc? Thanks.

[..]

> No. As far as I can tell, they can have 9 quad-ranked DIMMs (the machines
> I've looked so far are all equipped with single rank memories, so I don't 
> have a real scenario with 2R or 4R for Nehalem yet).
> 
> At Sandy Bridge-EP (E. g. Intel E5 CPUs), we have one machine fully equipped
> with dual rank memories. The number of ranks there is just a DIMM property.
> 
> # ./edac-ctl --layout
>        +-----------------------------------------------------------------------------------------------+
>        |                      mc0                      |                      mc1                      |
>        | channel0  | channel1  | channel2  | channel3  | channel0  | channel1  | channel2  | channel3  |
> -------+-----------------------------------------------------------------------------------------------+
> slot2: |     0 MB  |     0 MB  |     0 MB  |     0 MB  |     0 MB  |     0 MB  |     0 MB  |     0 MB  |
> slot1: |  4096 MB  |  4096 MB  |  4096 MB  |  4096 MB  |  4096 MB  |  4096 MB  |  4096 MB  |  4096 MB  |
> slot0: |  4096 MB  |  4096 MB  |  4096 MB  |  4096 MB  |  4096 MB  |  4096 MB  |  4096 MB  |  4096 MB  |
> -------+-----------------------------------------------------------------------------------------------+
> 
> (this machine doesn't have physical DIMM sockets for slot#2)

Ok, I can count 8 2R DIMMs here and each rank or slot in your
nomenclature is 4G. slot#2 has to be something virtual since each rank
occupies one slot, i.e. slot0 and slot1 on a channel.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
