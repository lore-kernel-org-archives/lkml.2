Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759430Ab1CaW1G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 18:27:06 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:56405 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664Ab1CaW1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 18:27:03 -0400
Subject: Re: [PATCH 04/12] mm: alloc_contig_freed_pages() added
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mm@kvack.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ankita Garg <ankita@in.ibm.com>,
        Daniel Walker <dwalker@codeaurora.org>,
        Johan MOSSBERG <johan.xx.mossberg@stericsson.com>,
        Mel Gorman <mel@csn.ul.ie>, Pawel Osciak <pawel@osciak.com>
In-Reply-To: <op.vs8awkrx3l0zgt@mnazarewicz-glaptop>
References: <1301577368-16095-1-git-send-email-m.szyprowski@samsung.com>
	 <1301577368-16095-5-git-send-email-m.szyprowski@samsung.com>
	 <1301587083.31087.1032.camel@nimitz>
	 <op.vs77qfx03l0zgt@mnazarewicz-glaptop>
	 <1301606078.31087.1275.camel@nimitz>
	 <op.vs8awkrx3l0zgt@mnazarewicz-glaptop>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 31 Mar 2011 15:26:51 -0700
Message-ID: <1301610411.30870.29.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-01 at 00:18 +0200, Michal Nazarewicz wrote:
> On Thu, 31 Mar 2011 23:14:38 +0200, Dave Hansen wrote:
> > We BUG_ON() in bootmem.  Basically if we try to allocate an early-boot
> > structure and fail, we're screwed.  We can't keep running without an
> > inode hash, or a mem_map[].
> >
> > This looks like it's going to at least get partially used in drivers, at
> > least from the examples.  Are these kinds of things that, if the driver
> > fails to load, that the system is useless and hosed?  Or, is it
> > something where we might limp along to figure out what went wrong before
> > we reboot?
> 
> Bug in the above place does not mean that we could not allocate memory.  It
> means caller is broken.

Could you explain that a bit?

Is this a case where a device is mapped to a very *specific* range of
physical memory and no where else?  What are the reasons for not marking
it off limits at boot?  I also saw some bits of isolation and migration
in those patches.  Can't the migration fail?  

-- Dave

