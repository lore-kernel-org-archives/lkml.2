Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab0DTUs7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 16:48:59 -0400
Received: from zakopane.cs.ubc.ca ([198.162.52.68]:41391 "EHLO
	mail.quuxuum.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666Ab0DTUs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 16:48:57 -0400
X-Greylist: delayed 423 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Apr 2010 16:48:57 EDT
Date: Tue, 20 Apr 2010 13:41:51 -0700
To: Tracy Reed <treed@ultraviolet.org>,
       Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>,
       xen-devel@lists.xensource.com, Aoetools-discuss@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] domU is causing misaligned disk writes
Message-ID: <20100420204151.GH1708@kremvax.cs.ubc.ca>
References: <20100420080958.GN5660@tracyreed.org>
	<20100420084955.GV1878@reaktio.net>
	<20100420200004.GQ5660@tracyreed.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100420200004.GQ5660@tracyreed.org>
X-Operating-System: Linux 2.6.31-20-generic x86_64
User-Agent: Mutt/1.5.20 (2010-03-22)
X-Delivery-Agent: TMDA/1.1.12 (Macallan)
From: Brendan Cully <brendan@cs.ubc.ca>
Mail-Followup-To: treed@ultraviolet.org, pasik@iki.fi,
	xen-devel@lists.xensource.com,
	Aoetools-discuss@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 20 April 2010 at 13:00, Tracy Reed wrote:
> On Tue, Apr 20, 2010 at 11:49:55AM +0300, Pasi Kärkkäinen spake thusly:
> > Are you using filesystems on normal partitions, or LVM in the domU? 
> > I'm pretty sure this is a domU partitioning problem.
> 
> Also: What changes in the view of the partitioning between domU and
> dom0? Wouldn't a partitioning error manifest itself in tests in the
> dom0 as well as in the domU?
> 
> BTW: The dd from the last time in my last email finally finished:
> 
> # dd if=/dev/zero of=/dev/xvdg1 bs=4096 count=3000000
> 3000000+0 records in
> 3000000+0 records out
> 12288000000 bytes (12 GB) copied, 734.714 seconds, 16.7 MB/s
> 
> If I run that very same dd as above (the last test in my previous
> email) with the same partition setup again but this time from the
> dom0:
> 
> # dd if=/dev/zero of=/dev/etherd/e6.1 bs=4096 count=3000000
> 3000000+0 records in
> 3000000+0 records out
> 12288000000 bytes (12 GB) copied, 107.352 seconds, 114 MB/s
> 
> # /sbin/sfdisk -d /dev/etherd/e6.1 
> # partition table of /dev/etherd/e6.1
> unit: sectors
> 
> /dev/etherd/e6.1p1 : start=       64, size=566226926, Id=83
> /dev/etherd/e6.1p2 : start=        0, size=        0, Id= 0
> /dev/etherd/e6.1p3 : start=        0, size=        0, Id= 0
> /dev/etherd/e6.1p4 : start=        0, size=        0, Id= 0
> 
> Device:         rrqm/s   wrqm/s   r/s   w/s    rkB/s    wkB/s avgrq-sz
> avgqu-sz   await  svctm  %util
> sda               0.00 17350.80  0.60 275.60    22.40 72540.00
> 525.43    97.94  344.01   3.62 100.02
> sdb               0.00 17374.80  1.20 256.00    28.00 74848.00
> 582.24   136.20  527.72   3.89 100.02

You could also be limited by the size of the block request ring (I
believe the ring is normally only one page) -- the ring needs to be
large enough to handle the bandwidth delay product, and AoE means the
delay is probably higher than normal. Do you get better performance
against a local partition?
