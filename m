Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab0CQTRP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 15:17:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754518Ab0CQTRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 15:17:14 -0400
Date: Wed, 17 Mar 2010 15:15:14 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Andrea Righi <arighi@develer.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Peter Zijlstra <peterz@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Suleiman Souhlal <suleiman@google.com>,
       Greg Thelen <gthelen@google.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH -mmotm 0/5] memcg: per cgroup dirty limit (v7)
Message-ID: <20100317191514.GC9198@redhat.com>
References: <1268609202-15581-1-git-send-email-arighi@develer.com> <20100315171209.GI21127@redhat.com> <20100315171921.GJ21127@redhat.com> <20100317115427.GR18054@balbir.in.ibm.com> <20100317133407.GA9198@redhat.com> <20100317185327.GV18054@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100317185327.GV18054@balbir.in.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 12:23:27AM +0530, Balbir Singh wrote:
> * Vivek Goyal <vgoyal@redhat.com> [2010-03-17 09:34:07]:
> 
> > > > 
> > > > root cgroup
> > > > ==========
> > > > #time dd if=/dev/zero of=/root/zerofile bs=4K count=1M
> > > > 4294967296 bytes (4.3 GB) copied, 56.098 s, 76.6 MB/s
> > > > 
> > > > real	0m56.614s
> > > > 
> > > > test1 cgroup with memory limit 100M
> > > > ===================================
> > > > # time dd if=/dev/zero of=/root/zerofile1 bs=4K count=1M
> > > > 4294967296 bytes (4.3 GB) copied, 19.8097 s, 217 MB/s
> > > > 
> > > > real	0m19.992s
> > > > 
> > > 
> > > This is strange, did you flish the cache between the two runs?
> > > NOTE: Since the files are same, we reuse page cache from the
> > > other cgroup.
> > 
> > Files are different. Note suffix "1".
> >
> 
> Thanks, I'll get the perf output and see what I get. 

One more thing I noticed and that is, it happens only if we limit the
memory of cgroup to 100M. If same cgroup test1 is unlimited memory 
thing, then it did not happen.

I also did not notice this happening on other system where I have 4G of
memory. So it also seems to be related with only bigger configurations.

Thanks
Vivek

> 
> -- 
> 	Three Cheers,
> 	Balbir
