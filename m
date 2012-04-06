Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109Ab2DFVHP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 17:07:15 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:17671 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592Ab2DFVHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 17:07:13 -0400
Date: Fri, 6 Apr 2012 17:02:30 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH 5/7] xen/setup: Transfer MFNs from non-RAM
 E820	entries and gaps to E820 RAM
Message-ID: <20120406210230.GC26309@phenom.dumpdata.com>
References: <1333139850-28456-1-git-send-email-konrad.wilk@oracle.com>
 <1333139850-28456-6-git-send-email-konrad.wilk@oracle.com>
 <4F7AB96B.5030900@citrix.com>
 <20120403131344.GB12464@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120403131344.GB12464@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4F7F5AFE.0029,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2012 at 09:13:44AM -0400, Konrad Rzeszutek Wilk wrote:
> On Tue, Apr 03, 2012 at 09:48:43AM +0100, David Vrabel wrote:
> > On 30/03/12 21:37, Konrad Rzeszutek Wilk wrote:
> > > We will now get:
> > > 
> > > -Released 283999 pages of unused memory
> > > +Exchanged 283999 pages
> > > .. snip..
> > > -Memory: 6487732k/9208688k available (5817k kernel code, 1136060k absent, 1584896k reserved, 2900k data, 692k init)
> > > +Memory: 6503888k/8072692k available (5817k kernel code, 1136060k absent, 432744k reserved, 2900k data, 692k init)
> > 
> > This isn't correct.  You've have lost ~1 GB of memory which are the
> > pages that were supposed to be moved.  The additional 1GB of reserved
> > memory in the old case is the balloon.
> 
> Whoops.
> > 
> > In xen_memory_setup() where it loops through the e820 to clip the RAM
> > regions you need to factor in the additional memory you've moved.  In
> > this loop you may need to count the pages in the RAM region instead of
> > the simple (addr < mem_end) test.  Take care with RAM regions with
> > partial pages and the like.
> 
> <nods> I did some more exhaustive testing and hit some issues

.. which is that moving the MFNs in the P2M is fine from the Linux kernel perspective
but the changes won't be reflected in the M2P. To make the M2P have the new
PFNs I have to use the populate_physmap hypercall.

A new-ish version will be posted soon.
