Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199Ab0FVRkP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 13:40:15 -0400
Received: from reaktio.net ([194.89.68.22]:33154 "EHLO ydin.reaktio.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333Ab0FVRkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 13:40:13 -0400
Date: Tue, 22 Jun 2010 20:40:14 +0300
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: Jiahua <jiahua@gmail.com>
Cc: linux-kernel@vger.kernel.org, open-iscsi@googlegroups.com
Subject: Re: Linux IO scalability and pushing over million IOPS over
	software iSCSI?
Message-ID: <20100622174014.GU17817@reaktio.net>
References: <20100622134410.GT17817@reaktio.net> <AANLkTikDJN6oy7o7eTUH1F4KsRgRBZoOYQI_al3Y8HXk@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikDJN6oy7o7eTUH1F4KsRgRBZoOYQI_al3Y8HXk@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 09:24:21AM -0700, Jiahua wrote:
> Maybe a native question, but why need 50 targets? Each target can only
> serve about 25K IOPS? A single ramdisk should be able to handle this.
> Where is the bottleneck?
> 

That's a good question.. dunno. Maybe StarWind iSCSI target didn't scale very well? :)

Or maybe it's related to the multi-queue support on the initiator NIC,
to scale the load to multiple queues and thus to multiple IRQs and to multiple CPU cores..

so maybe they needed multiple IP addresses to do that and it was easiest to just use 
multiple target systems? 


> We had a similar experiment but with Infiniband and Lustre. It turn
> out Lustre has a rate limit in the RPC handling layer. Is it the same
> problem here?
> 

Note that we're trying to benchmark the *initiator* here, not the targets..

-- Pasi

> Jiahua
> 
> 
> 
> On Tue, Jun 22, 2010 at 6:44 AM, Pasi Kärkkäinen <pasik@iki.fi> wrote:
> > Hello,
> >
> > Recently Intel and Microsoft demonstrated pushing over 1.25 million IOPS using software iSCSI and a single 10 Gbit NIC:
> > http://communities.intel.com/community/wired/blog/2010/04/22/1-million-iops-how-about-125-million
> >
> > Earlier they achieved one (1.0) million IOPS:
> > http://blog.fosketts.net/2010/01/14/microsoft-intel-push-million-iscsi-iops/
> > http://communities.intel.com/community/openportit/server/blog/2010/01/19/1000000-iops-with-iscsi--thats-not-a-typo
> >
> > The benchmark setup explained:
> > http://communities.intel.com/community/wired/blog/2010/04/20/1-million-iop-article-explained
> > http://dlbmodigital.microsoft.com/ppt/TN-100114-JSchwartz_SMorgan_JPlawner-1032432956-FINAL.pdf
> >
> >
> > So the question is.. does someone have enough new hardware to try this with Linux?
> > Can Linux scale to over 1 million IO operations per second?
> >
> >
> > Intel and Microsoft used the following for the benchmark:
> >
> >        - Single Windows 2008 R2 system with Intel Xeon 5600 series CPU,
> >          single-port Intel 82599 10 Gbit NIC and MS software-iSCSI initiator
> >          connecting to 50x iSCSI LUNs.
> >        - IOmeter to benchmark all the 50x iSCSI LUNs concurrently.
> >
> >        - 10 servers as iSCSI targets, each having 5x ramdisk LUNs, total of 50x ramdisk LUNs.
> >        - iSCSI target server also used 10 Gbit NICs, and StarWind iSCSI target software.
> >        - Cisco 10 Gbit switch (Nexus) connecting the servers.
> >
> >        - For the 1.25 million IOPS result they used 512 bytes/IO benchmark, outstanding IOs=20.
> >        - No jumbo frames, just the standard MTU=1500.
> >
> > They used many LUNs so they can scale the iSCSI connections to multiple CPU cores
> > using RSS (Receive Side Scaling) and MSI-X interrupts.
> >
> > So.. Who wants to try this? :) I don't unfortunately have 11x extra computers with 10 Gbit NICs atm to try it myself..
> >
> > This test covers networking, block layer, and software iSCSI initiator..
> > so it would be a nice to see if we find any bottlenecks from current Linux kernel.
> >
> > Comments please!
> >
> > -- Pasi
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
