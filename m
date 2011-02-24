Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab1BXXp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 18:45:28 -0500
Received: from mga01.intel.com ([192.55.52.88]:38326 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756394Ab1BXXp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 18:45:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,221,1297065600"; 
   d="scan'208";a="661246807"
Date: Thu, 24 Feb 2011 15:45:25 -0800
From: jacob pan <jacob.jun.pan@linux.intel.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Arjan van de Ven <arjan@linux.intel.com>,
        container cgroup <containers@lists.linux-foundation.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
        akpm@linux-foundation.org, rdunlap@xenotime.net,
        Cedric Le Goater <clg@vnet.ibm.com>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH 1/1, v9] cgroup/freezer: add per freezer duty ratio
 control
Message-ID: <20110224154525.1b463723@jacob-laptop>
In-Reply-To: <20110216032321.GA14893@count0.beaverton.ibm.com>
References: <1297807750-28844-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<1297807750-28844-2-git-send-email-jacob.jun.pan@linux.intel.com>
	<201102160100.15487.rjw@sisk.pl>
	<20110215163812.7fa020b5@putvin>
	<20110216032321.GA14893@count0.beaverton.ibm.com>
Organization: OTC
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Feb 2011 19:23:21 -0800
Matt Helsley <matthltc@us.ibm.com> wrote:

> On Tue, Feb 15, 2011 at 04:38:12PM -0800, Jacob Pan wrote:
> > On Wed, 16 Feb 2011 01:00:15 +0100
> > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> <snip>
> 
> > > Well, quite frankly, I'm not going to take this patch unless it
> > > gets an ACK from the scheduler people (which I'm guessing is not
> > > going to happen before hell freezes over).
> > > 
> > > IOW, please find a better way to address the issue at hand.
> > > 
> > We do have a real need that there is no exist feature in the kernel
> > can provide solution for. You want ACK from scheduler people
> > because it has impact on disabling irq? or you think scheduler
> > should be the one that provide the solution. I did try cpu
> > subsystem, but it seems to be limited to RT and certain scheduling
> > policy e.g. RR and FIFO.
> 
> I agree with Rafael. I think the scheduler should provide the solution
> and it can be done via modifications to the cpu cgroup subsystem. 
> Yes, it only has the shares and rt-related files *right now*. However,
> Kame replied earlier with a link to some patches for extending it
> that introduce files with similar (granted: not the same) semantics:
> 
> http://linux.derkeiler.com/Mailing-Lists/Kernel/2010-10/msg04335.html
> 
> I think you could build on that and help push those patches towards
> mainline along with your enhancements for reducing wakeups rather
> than modify the freezer cgroup subsystem.
> 
I played with v3 and v4 of the CFS bandwidth patch. When the cpu
cgroup exceeds its cfs_quota, it does have the same effect as this
patch in terms of freeze/thaw at given period and allowed runtime. But
when the cgroup cpu usage is below cfs_quota, it is not throttled.
Therefore, it cannot reduce wakeups.
I will continue look into the possibility of enhancing CFS BW patch for
our needs, But again, the fundamental difference here is bandwidth vs
idle time control. What we need for power saving is idle time not
bandwidth.

Thanks,

Jacob
