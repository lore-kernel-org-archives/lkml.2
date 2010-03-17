Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab0CQTCv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 15:02:51 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:38001 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab0CQTCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 15:02:49 -0400
Date: Thu, 18 Mar 2010 00:32:41 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Greg Thelen <gthelen@google.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Andrea Righi <arighi@develer.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Vivek Goyal <vgoyal@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Suleiman Souhlal <suleiman@google.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH -mmotm 2/5] memcg: dirty memory documentation
Message-ID: <20100317190241.GW18054@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1268609202-15581-1-git-send-email-arighi@develer.com>
 <1268609202-15581-3-git-send-email-arighi@develer.com>
 <20100316164121.024e35d8.nishimura@mxp.nes.nec.co.jp>
 <49b004811003171048h5f27405oe6ea39a103bc4ee3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49b004811003171048h5f27405oe6ea39a103bc4ee3@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg Thelen <gthelen@google.com> [2010-03-17 09:48:18]:

> On Mon, Mar 15, 2010 at 11:41 PM, Daisuke Nishimura
> <nishimura@mxp.nes.nec.co.jp> wrote:
> > On Mon, 15 Mar 2010 00:26:39 +0100, Andrea Righi <arighi@develer.com> wrote:
> >> Document cgroup dirty memory interfaces and statistics.
> >>
> >> Signed-off-by: Andrea Righi <arighi@develer.com>
> >> ---
> >>  Documentation/cgroups/memory.txt |   36 ++++++++++++++++++++++++++++++++++++
> >>  1 files changed, 36 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
> >> index 49f86f3..38ca499 100644
> >> --- a/Documentation/cgroups/memory.txt
> >> +++ b/Documentation/cgroups/memory.txt
> >> @@ -310,6 +310,11 @@ cache            - # of bytes of page cache memory.
> >>  rss          - # of bytes of anonymous and swap cache memory.
> >>  pgpgin               - # of pages paged in (equivalent to # of charging events).
> >>  pgpgout              - # of pages paged out (equivalent to # of uncharging events).
> >> +filedirty    - # of pages that are waiting to get written back to the disk.
> >> +writeback    - # of pages that are actively being written back to the disk.
> >> +writeback_tmp        - # of pages used by FUSE for temporary writeback buffers.
> >> +nfs          - # of NFS pages sent to the server, but not yet committed to
> >> +               the actual storage.
> 
> Should these new memory.stat counters (filedirty, etc) report byte
> counts rather than page counts?  I am thinking that byte counters
> would make reporting more obvious depending on how heterogeneous page
> sizes are used. Byte counters would also agree with /proc/meminfo.
> Within the kernel we could still maintain page counts.  The only
> change would be to the reporting routine, mem_cgroup_get_local_stat(),
> which would scale the page counts by PAGE_SIZE as it does for for
> cache,rss,etc.
>

I agree, byte counts would be better than page counts. pgpin and
pgpout are special cases where the pages matter, the size does not due
to the nature of the operation. 

-- 
	Three Cheers,
	Balbir
