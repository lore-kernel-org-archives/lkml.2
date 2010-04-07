Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab0DGH7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 03:59:53 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:37564 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab0DGH7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 03:59:47 -0400
Date: Wed, 7 Apr 2010 10:00:14 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Larry Woodman <lwoodman@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: RFC [Patch] Remove "please try 'cgroup_disable=memory' option
 if you don't want memory cgroups" printk at boot time.
Message-ID: <20100407080014.GB2446@osiris.boeblingen.de.ibm.com>
References: <1270049283.3551.281.camel@dhcp-100-19-198.bos.redhat.com>
 <1270050899.3551.283.camel@dhcp-100-19-198.bos.redhat.com>
 <4BB38D1A.7050204@redhat.com>
 <20100401104859.e0deeca8.kamezawa.hiroyu@jp.fujitsu.com>
 <20100401045310.GB6337@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100401045310.GB6337@balbir.in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 10:23:10AM +0530, Balbir Singh wrote:
> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-04-01 10:48:59]:
> 
> > On Wed, 31 Mar 2010 13:57:46 -0400
> > Rik van Riel <riel@redhat.com> wrote:
> > 
> > > On 03/31/2010 11:54 AM, Larry Woodman wrote:
> > > > On Wed, 2010-03-31 at 11:28 -0400, Larry Woodman wrote:
> > > >> We are considering removing this printk at boot time from RHEL because
> > > >> it will confuse customers, encourage them to change the boot parameters
> > > >> and generate extraneous support calls.  Its documented in
> > > >> Documentation/kernel-parameters.txt anyway.  Any thoughts???
> > > 
> > > Yeah, that is a strange boot message...
> > > 
> > > Acked-by: Rik van Riel <riel@redhat.com>
> > > 
> > please CC linux-mm and maintainers.
> > 
> > Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > It have been there for a year and I think memory usage by page_cgroup
> > will not surprise linux kernel users, more.
> > 
> > Assume x86-32.
> > 
> > RHEL allows amount of memory up to 16G, right?
> > 
> > without memcg: memmap uses 32bytes * 16G/4k = 128M.
> > with memcg:    memmap+page_cgroup uses (32+20) bytes * 16G/4k = 208M.
> > 
> > I thought this may cause OOM in ZONE_NORMAL. Then, I added it when I wrote
> > original patch. This kind of memory eater can cause trouble when it pops
> > up suddenly. But I think 'one year' can be an excuse.
> >
> 
> I've seen this issue come up on multiple machines, I think the printk
> is useful. However, we might need to change the panic() to a big fat
> warning and disable the memcg controller if we fail to allocate memory
> in page_cgroup_init_flatmem(). 

Probably a stupid question: but isn't it possible to allocate the huge
amounts of memory only if somebody activates memcg during runtime?
And then allocate everything using vmalloc?
But that probably doesn't work, since you need to record everything
from the boot of the system, I would guess?
Just wondering because we do everything to not even waste a single bit
in struct page and all of a sudden on the enterprise distros we allocate
(by default!) 40 additional bytes per page.
