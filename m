Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab2BVRlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 12:41:40 -0500
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:60429 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921Ab2BVRlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 12:41:37 -0500
Date: Wed, 22 Feb 2012 19:41:34 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Tejun Heo <tj@kernel.org>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, sparclinux@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: OF-related boot crash in 3.3.0-rc3-00188-g3ec1e88
In-Reply-To: <20120222172154.GA29641@merkur.ravnborg.org>
Message-ID: <alpine.SOC.1.00.1202221927300.17363@math.ut.ee>
References: <20120213080618.GA11077@ponder.secretlab.ca> <alpine.SOC.1.00.1202131119040.1488@math.ut.ee> <20120213214623.GJ11077@ponder.secretlab.ca> <alpine.SOC.1.00.1202162151030.16208@math.ut.ee> <alpine.SOC.1.00.1202201109260.467@math.ut.ee>
 <20120220170603.GC7836@mtj.dyndns.org> <alpine.SOC.1.00.1202210030530.11350@math.ut.ee> <20120221010537.GA15898@dhcp-172-17-108-109.mtv.corp.google.com> <20120222170330.GA29521@merkur.ravnborg.org> <alpine.SOC.1.00.1202221910420.17363@math.ut.ee>
 <20120222172154.GA29641@merkur.ravnborg.org>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Could you try to boot with a sensible mem=xxx value to see if limiting the memory
> > > helps.
> > 
> > Like mem=256M? Will try.
> Think just a little more - I do not think this will help.

Tried it on the 2G V210. It changes the picture. With 2G RAM, it 
just hangs.

With mem=256M it produces a crash in strlen and of_alias_scan like in 
V100 with 1G.

mem=512M results in the same strlen error.

mem=1G results in a stranger error:

[    0.000000] Kernel panic - not syncing: ERROR: Failed to allocate 0x90 bytes below 0x0.
[    0.000000] 
[    0.000000] Call Trace:
[    0.000000]  [00000000007a6a28] memblock_alloc_base+0x28/0x38
[    0.000000]  [000000000079ca50] prom_early_alloc+0xc/0x60
[    0.000000]  [00000000007ae090] of_pdt_create_node.part.0+0x4/0xe0
[    0.000000]  [00000000007ae250] of_pdt_build_devicetree+0x30/0xa0
[    0.000000]  [000000000079c4a8] prom_build_devicetree+0x18/0x38
[    0.000000]  [00000000007a03c0] paging_init+0x59c/0x6bc
[    0.000000]  [000000000079be50] setup_arch+0xf8/0x108
[    0.000000]  [000000000079a4e8] start_kernel+0x78/0x30c
[    0.000000]  [00000000006a3e80] tlb_fixup_done+0x98/0xa0
[    0.000000]  [0000000000000000]           (null)

The working machines have 512M RAM, 834M RAM and 2G RAM so it's not just 
the amount of RAM.

-- 
Meelis Roos (mroos@linux.ee)
