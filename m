Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab0DONsr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 09:48:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:46174 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714Ab0DONsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 09:48:46 -0400
Subject: Re: [PATCH] ummunotify: Userspace support for MMU notifications
From: Peter Zijlstra <peterz@infradead.org>
To: Gleb Natapov <gleb@redhat.com>
Cc: Roland Dreier <rdreier@cisco.com>,
       =?ISO-8859-1?Q?H=E5kon?= Bugge <Haakon.Bugge@Sun.COM>,
       Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric B Munson <ebmunson@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-rdma@vger.kernel.org, rolandd@cisco.com, pavel@ucw.cz,
       mingo@elte.hu, jsquyres@cisco.com
In-Reply-To: <20100414085228.GL23554@redhat.com>
References: <1271053337-7121-1-git-send-email-ebmunson@us.ibm.com>
	 <20100412160359.1d9074dc.akpm@linux-foundation.org>
	 <20100412235937.GF15629@obsidianresearch.com>
	 <3251DDDA-D705-4B1E-9595-9C24709EF146@Sun.com>
	 <adahbnfme0j.fsf@roland-alpha.cisco.com> <1271181774.4807.1868.camel@twins>
	 <20100414085228.GL23554@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Apr 2010 15:48:42 +0200
Message-ID: <1271339322.1674.16.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-14 at 11:52 +0300, Gleb Natapov wrote:
> On Tue, Apr 13, 2010 at 08:02:54PM +0200, Peter Zijlstra wrote:
> > On Tue, 2010-04-13 at 10:57 -0700, Roland Dreier wrote:
> > > Are those system calls the only possible way that virtual to physical
> > > mappings can change?  Can't page migration or something like that
> > > potentially affect things?  And even if you did have hooks into every
> > > system call that mattered (keep in mind that relying on glibc is not
> > > enough, since an MPI application may not use glibc) would decoding them
> > > and figuring out what happened really be preferable to a single event
> > > type that tells you exactly what address range was affected? 
> > 
> > Yeah, virtual<->physical maps can change through swapping, page
> > migration, memory compaction, huge-page aggregation (the latter two not
> > yet being upstream).
> > 
> > Even mlock() doesn't pin virtual<->physical maps.
> Pages registered for RDMA are GUPed so no method above should touch
> them. Fork+cow or unmap/map on the other hand can change
> virtual<->physical maps. GUPed pages are still GUPed, but they are no
> longer mapped into process' virtual address space. MPI copes with
> Fork+cow by marking registered memory as MADV_DONTFORK.

Sure, holding a page-ref will pin the physical page, but that is not
something userspace usually has means to.

