Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab2JIS6F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 14:58:05 -0400
Received: from wp118.webpack.hosteurope.de ([80.237.132.125]:56505 "EHLO
	wp118.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756646Ab2JIS6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 14:58:03 -0400
Date: Tue, 9 Oct 2012 20:57:58 +0200
From: Florian Dazinger <florian@dazinger.net>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Joerg.Roedel@amd.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] amd_iommu: Refactor IOMMU group and support
 virtual aliases
Message-ID: <20121009205758.45c9fcc0@brain.lan>
In-Reply-To: <1349807739.2759.292.camel@ul30vt.home>
References: <20121009044057.16302.44577.stgit@bling.home>
 <20121009202738.7e047e64@brain.lan>
 <1349807739.2759.292.camel@ul30vt.home>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;florian@dazinger.net;1349809083;7d1197b8;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Tue, 09 Oct 2012 12:35:39 -0600
schrieb Alex Williamson <alex.williamson@redhat.com>:

> On Tue, 2012-10-09 at 20:27 +0200, Florian Dazinger wrote:
> > Am Mon, 08 Oct 2012 22:49:28 -0600
> > schrieb Alex Williamson <alex.williamson@redhat.com>:
> > 
> > > This series is meant to refactor IOMMU group support in amd_iommu
> > > to properly support virtual aliases.  If multiple devices alias to
> > > the same virtual alias, they should be grouped together.  This code
> > > also verifies whether the alias should be the root of the group vs
> > > devices above the alias.
> > > 
> > > This seems to do the right thing on my system, but that's not saying
> > > a lot since it doesn't do anything interesting with aliases.  I'd
> > > appreciate if Joerg and Florian could test this on their systems.
> > > Thanks,
> > > 
> > > Alex
> > > 
> > > ---
> > > 
> > > Alex Williamson (5):
> > >       amd_iommu: Properly account for virtual aliases in IOMMU groups
> > >       amd_iommu: Split IOMMU group allocation and attach
> > >       amd_iommu: Split upstream bus device lookup
> > >       amd_iommu: Split IOMMU Group topology walk
> > >       amd_iommu: Split IOMMU group initialization
> > > 
> > > 
> > >  drivers/iommu/amd_iommu.c       |  184 ++++++++++++++++++++++++++++++---------
> > >  drivers/iommu/amd_iommu_types.h |    1 
> > >  2 files changed, 142 insertions(+), 43 deletions(-)
> > > 
> > 
> > patch #5 does not apply cleanly on top of 3.6, I had to edit
> > amd_iommu_types.h manually (easy enough), apart from that, it is
> > working fine!
> 
> Thanks Florian.  Would you mind also reporting
> 'find /sys/kernel/iommu_groups' for both stock 3.6 and with this series
> applied?  I think we want to find that devices 07:00.0 and 08:04.0 are
> grouped together and I'd like to verify whether that actually works.
> Thanks,
> 
> Alex

shure... there does not seem to be much difference?

with stock 3.6:
/sys/kernel/iommu_groups
/sys/kernel/iommu_groups/0
/sys/kernel/iommu_groups/0/devices
/sys/kernel/iommu_groups/0/devices/0000:00:00.0
/sys/kernel/iommu_groups/0/devices/0000:00:00.2
/sys/kernel/iommu_groups/1
/sys/kernel/iommu_groups/1/devices
/sys/kernel/iommu_groups/1/devices/0000:00:02.0
/sys/kernel/iommu_groups/2
/sys/kernel/iommu_groups/2/devices
/sys/kernel/iommu_groups/2/devices/0000:00:04.0
/sys/kernel/iommu_groups/3
/sys/kernel/iommu_groups/3/devices
/sys/kernel/iommu_groups/3/devices/0000:00:05.0
/sys/kernel/iommu_groups/4
/sys/kernel/iommu_groups/4/devices
/sys/kernel/iommu_groups/4/devices/0000:00:06.0
/sys/kernel/iommu_groups/5
/sys/kernel/iommu_groups/5/devices
/sys/kernel/iommu_groups/5/devices/0000:00:07.0
/sys/kernel/iommu_groups/6
/sys/kernel/iommu_groups/6/devices
/sys/kernel/iommu_groups/6/devices/0000:00:09.0
/sys/kernel/iommu_groups/7
/sys/kernel/iommu_groups/7/devices
/sys/kernel/iommu_groups/7/devices/0000:00:0d.0
/sys/kernel/iommu_groups/8
/sys/kernel/iommu_groups/8/devices
/sys/kernel/iommu_groups/8/devices/0000:00:11.0
/sys/kernel/iommu_groups/9
/sys/kernel/iommu_groups/9/devices
/sys/kernel/iommu_groups/9/devices/0000:00:12.0
/sys/kernel/iommu_groups/9/devices/0000:00:12.2
/sys/kernel/iommu_groups/10
/sys/kernel/iommu_groups/10/devices
/sys/kernel/iommu_groups/10/devices/0000:00:13.0
/sys/kernel/iommu_groups/10/devices/0000:00:13.2
/sys/kernel/iommu_groups/11                                                                                                                                                                                                                
/sys/kernel/iommu_groups/11/devices                                                                                                                                                                                                        
/sys/kernel/iommu_groups/11/devices/0000:00:14.0                                                                                                                                                                                           
/sys/kernel/iommu_groups/11/devices/0000:00:14.3                                                                                                                                                                                           
/sys/kernel/iommu_groups/11/devices/0000:00:14.4                                                                                                                                                                                           
/sys/kernel/iommu_groups/11/devices/0000:00:14.5                                                                                                                                                                                           
/sys/kernel/iommu_groups/12                                                                                                                                                                                                                
/sys/kernel/iommu_groups/12/devices                                                                                                                                                                                                        
/sys/kernel/iommu_groups/12/devices/0000:00:16.0                                                                                                                                                                                           
/sys/kernel/iommu_groups/12/devices/0000:00:16.2                                                                                                                                                                                           
/sys/kernel/iommu_groups/13                                                                                                                                                                                                                
/sys/kernel/iommu_groups/13/devices                                                                                                                                                                                                        
/sys/kernel/iommu_groups/13/devices/0000:01:00.0                                                                                                                                                                                           
/sys/kernel/iommu_groups/13/devices/0000:01:00.1                                                                                                                                                                                           
/sys/kernel/iommu_groups/14                                                                                                                                                                                                                
/sys/kernel/iommu_groups/14/devices                                                                                                                                                                                                        
/sys/kernel/iommu_groups/14/devices/0000:02:00.0                                                                                                                                                                                           
/sys/kernel/iommu_groups/15                                                                                                                                                                                                                
/sys/kernel/iommu_groups/15/devices                                                                                                                                                                                                        
/sys/kernel/iommu_groups/15/devices/0000:03:00.0                                                                                                                                                                                           
/sys/kernel/iommu_groups/16                                                                                                                                                                                                                
/sys/kernel/iommu_groups/16/devices                                                                                                                                                                                                        
/sys/kernel/iommu_groups/16/devices/0000:04:00.0                                                                                                                                                                                           
/sys/kernel/iommu_groups/17                                                                                                                                                                                                                
/sys/kernel/iommu_groups/17/devices                                                                                                                                                                                                        
/sys/kernel/iommu_groups/17/devices/0000:05:00.0                                                                                                                                                                                           
/sys/kernel/iommu_groups/18                                                                                                                                                                                                                
/sys/kernel/iommu_groups/18/devices                                                                                                                                                                                                        
/sys/kernel/iommu_groups/18/devices/0000:06:00.0                                                                                                                                                                                           
/sys/kernel/iommu_groups/19                                                                                                                                                                                                                
/sys/kernel/iommu_groups/19/devices                                                                                                                                                                                                        
/sys/kernel/iommu_groups/19/devices/0000:07:00.0                                                                                                                                                                                           
/sys/kernel/iommu_groups/20                                                                                                                                                                                                                
/sys/kernel/iommu_groups/20/devices                                                                                                                                                                                                        
/sys/kernel/iommu_groups/20/devices/0000:08:04.0 


3.6 + your patch-series:
3.6 with your patch-series:
/sys/kernel/iommu_groups
/sys/kernel/iommu_groups/0
/sys/kernel/iommu_groups/0/devices
/sys/kernel/iommu_groups/0/devices/0000:00:00.0
/sys/kernel/iommu_groups/0/devices/0000:00:00.2
/sys/kernel/iommu_groups/1
/sys/kernel/iommu_groups/1/devices
/sys/kernel/iommu_groups/1/devices/0000:00:02.0
/sys/kernel/iommu_groups/2
/sys/kernel/iommu_groups/2/devices
/sys/kernel/iommu_groups/2/devices/0000:00:04.0
/sys/kernel/iommu_groups/3
/sys/kernel/iommu_groups/3/devices
/sys/kernel/iommu_groups/3/devices/0000:00:05.0
/sys/kernel/iommu_groups/4
/sys/kernel/iommu_groups/4/devices
/sys/kernel/iommu_groups/4/devices/0000:00:06.0
/sys/kernel/iommu_groups/5
/sys/kernel/iommu_groups/5/devices
/sys/kernel/iommu_groups/5/devices/0000:00:07.0
/sys/kernel/iommu_groups/6
/sys/kernel/iommu_groups/6/devices
/sys/kernel/iommu_groups/6/devices/0000:00:09.0
/sys/kernel/iommu_groups/7
/sys/kernel/iommu_groups/7/devices
/sys/kernel/iommu_groups/7/devices/0000:00:0d.0
/sys/kernel/iommu_groups/8
/sys/kernel/iommu_groups/8/devices
/sys/kernel/iommu_groups/8/devices/0000:00:11.0
/sys/kernel/iommu_groups/9
/sys/kernel/iommu_groups/9/devices
/sys/kernel/iommu_groups/9/devices/0000:00:12.0
/sys/kernel/iommu_groups/9/devices/0000:00:12.2
/sys/kernel/iommu_groups/10
/sys/kernel/iommu_groups/10/devices
/sys/kernel/iommu_groups/10/devices/0000:00:13.0
/sys/kernel/iommu_groups/10/devices/0000:00:13.2
/sys/kernel/iommu_groups/11
/sys/kernel/iommu_groups/11/devices
/sys/kernel/iommu_groups/11/devices/0000:00:14.0
/sys/kernel/iommu_groups/11/devices/0000:00:14.3
/sys/kernel/iommu_groups/11/devices/0000:00:14.4
/sys/kernel/iommu_groups/11/devices/0000:00:14.5
/sys/kernel/iommu_groups/12
/sys/kernel/iommu_groups/12/devices
/sys/kernel/iommu_groups/12/devices/0000:00:16.0
/sys/kernel/iommu_groups/12/devices/0000:00:16.2
/sys/kernel/iommu_groups/13
/sys/kernel/iommu_groups/13/devices
/sys/kernel/iommu_groups/13/devices/0000:01:00.0
/sys/kernel/iommu_groups/13/devices/0000:01:00.1
/sys/kernel/iommu_groups/14
/sys/kernel/iommu_groups/14/devices
/sys/kernel/iommu_groups/14/devices/0000:02:00.0
/sys/kernel/iommu_groups/15
/sys/kernel/iommu_groups/15/devices
/sys/kernel/iommu_groups/15/devices/0000:03:00.0
/sys/kernel/iommu_groups/16
/sys/kernel/iommu_groups/16/devices
/sys/kernel/iommu_groups/16/devices/0000:04:00.0
/sys/kernel/iommu_groups/17
/sys/kernel/iommu_groups/17/devices
/sys/kernel/iommu_groups/17/devices/0000:05:00.0
/sys/kernel/iommu_groups/18
/sys/kernel/iommu_groups/18/devices
/sys/kernel/iommu_groups/18/devices/0000:06:00.0
/sys/kernel/iommu_groups/19
/sys/kernel/iommu_groups/19/devices
/sys/kernel/iommu_groups/19/devices/0000:07:00.0
/sys/kernel/iommu_groups/20
/sys/kernel/iommu_groups/20/devices
/sys/kernel/iommu_groups/20/devices/0000:08:04.0
