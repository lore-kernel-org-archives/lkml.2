Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab2BVRDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 12:03:35 -0500
Received: from smtp.snhosting.dk ([87.238.248.203]:43621 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab2BVRDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 12:03:33 -0500
Date: Wed, 22 Feb 2012 18:03:30 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Tejun Heo <tj@kernel.org>
Cc: Meelis Roos <mroos@linux.ee>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, sparclinux@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: OF-related boot crash in 3.3.0-rc3-00188-g3ec1e88
Message-ID: <20120222170330.GA29521@merkur.ravnborg.org>
References: <alpine.SOC.1.00.1202130942030.1488@math.ut.ee> <20120213080618.GA11077@ponder.secretlab.ca> <alpine.SOC.1.00.1202131119040.1488@math.ut.ee> <20120213214623.GJ11077@ponder.secretlab.ca> <alpine.SOC.1.00.1202162151030.16208@math.ut.ee> <alpine.SOC.1.00.1202201109260.467@math.ut.ee> <20120220170603.GC7836@mtj.dyndns.org> <alpine.SOC.1.00.1202210030530.11350@math.ut.ee> <20120221010537.GA15898@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120221010537.GA15898@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 05:05:37PM -0800, Tejun Heo wrote:
> Hello,
> 
> Meelis, can you please apply the following patch before & after the
> offending commit, boot with "memblock=debug" added as kernel param and
> post the boot log?  The patch will generate some offset warnings after
> the commit but should work fine.
> 
> Sam, David, as I'm not familiar with the code base, is it possible to
> tell which address is corrupted (zeroed, it seems)?  ie. can we add
> "if (XXX == NULL) printk("%p is corrputed\n"...);" somewhere?

No idea - sorry. I spend most of the time with sparc32 - which I
do not even feel familiar with yet :-(

One thing I noticed while working with memblock for sparc32 (*) is that allocations
are done top-down. So we may end up allocatng memory with a considerably higher
address than we are used to.
This is obviously just a wild guess...

Meelis - do the affected boxes have any special memory configurations?
Could you try to boot with a sensible mem=xxx value to see if limiting the memory
helps.

(*) I have re-done the original patch-set and I have a quite good feeling about it.
HIGHMEM support is outstanding - I got a bit confused when I looked at x86.

But my ss5 crashes the first time I try to use the allocated memory - 
so I assume I have some silly issue somewhere. Nothing points at memblock
in this case.

	Sam
