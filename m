Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757693Ab1BPDXe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 22:23:34 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:49271 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616Ab1BPDXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 22:23:31 -0500
Date: Tue, 15 Feb 2011 19:23:21 -0800
From: Matt Helsley <matthltc@us.ibm.com>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Matt Helsley <matthltc@us.ibm.com>,
        container cgroup <containers@lists.linux-foundation.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
        akpm@linux-foundation.org, rdunlap@xenotime.net,
        Cedric Le Goater <clg@vnet.ibm.com>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH 1/1, v9] cgroup/freezer: add per freezer duty ratio
 control
Message-ID: <20110216032321.GA14893@count0.beaverton.ibm.com>
References: <1297807750-28844-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1297807750-28844-2-git-send-email-jacob.jun.pan@linux.intel.com>
 <201102160100.15487.rjw@sisk.pl>
 <20110215163812.7fa020b5@putvin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110215163812.7fa020b5@putvin>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 04:38:12PM -0800, Jacob Pan wrote:
> On Wed, 16 Feb 2011 01:00:15 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

<snip>

> > Well, quite frankly, I'm not going to take this patch unless it gets
> > an ACK from the scheduler people (which I'm guessing is not going to
> > happen before hell freezes over).
> > 
> > IOW, please find a better way to address the issue at hand.
> > 
> We do have a real need that there is no exist feature in the kernel can
> provide solution for. You want ACK from scheduler people because it has
> impact on disabling irq? or you think scheduler should be the one that
> provide the solution. I did try cpu subsystem, but it seems to be
> limited to RT and certain scheduling policy e.g. RR and FIFO.

I agree with Rafael. I think the scheduler should provide the solution
and it can be done via modifications to the cpu cgroup subsystem. 
Yes, it only has the shares and rt-related files *right now*. However,
Kame replied earlier with a link to some patches for extending it
that introduce files with similar (granted: not the same) semantics:

http://linux.derkeiler.com/Mailing-Lists/Kernel/2010-10/msg04335.html

I think you could build on that and help push those patches towards
mainline along with your enhancements for reducing wakeups rather
than modify the freezer cgroup subsystem.

Cheers,
	-Matt Helsley
