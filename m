Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab0CQNfI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 09:35:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754863Ab0CQNfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 09:35:06 -0400
Date: Wed, 17 Mar 2010 09:34:07 -0400
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
Message-ID: <20100317133407.GA9198@redhat.com>
References: <1268609202-15581-1-git-send-email-arighi@develer.com> <20100315171209.GI21127@redhat.com> <20100315171921.GJ21127@redhat.com> <20100317115427.GR18054@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100317115427.GR18054@balbir.in.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 17, 2010 at 05:24:28PM +0530, Balbir Singh wrote:
> * Vivek Goyal <vgoyal@redhat.com> [2010-03-15 13:19:21]:
> 
> > On Mon, Mar 15, 2010 at 01:12:09PM -0400, Vivek Goyal wrote:
> > > On Mon, Mar 15, 2010 at 12:26:37AM +0100, Andrea Righi wrote:
> > > > Control the maximum amount of dirty pages a cgroup can have at any given time.
> > > > 
> > > > Per cgroup dirty limit is like fixing the max amount of dirty (hard to reclaim)
> > > > page cache used by any cgroup. So, in case of multiple cgroup writers, they
> > > > will not be able to consume more than their designated share of dirty pages and
> > > > will be forced to perform write-out if they cross that limit.
> > > > 
> > > 
> > > For me even with this version I see that group with 100M limit is getting
> > > much more BW.
> > > 
> > > root cgroup
> > > ==========
> > > #time dd if=/dev/zero of=/root/zerofile bs=4K count=1M
> > > 4294967296 bytes (4.3 GB) copied, 55.7979 s, 77.0 MB/s
> > > 
> > > real	0m56.209s
> > > 
> > > test1 cgroup with memory limit of 100M
> > > ======================================
> > > # time dd if=/dev/zero of=/root/zerofile1 bs=4K count=1M
> > > 4294967296 bytes (4.3 GB) copied, 20.9252 s, 205 MB/s
> > > 
> > > real	0m21.096s
> > > 
> > > Note, these two jobs are not running in parallel. These are running one
> > > after the other.
> > > 
> > 
> > Ok, here is the strange part. I am seeing similar behavior even without
> > your patches applied.
> > 
> > root cgroup
> > ==========
> > #time dd if=/dev/zero of=/root/zerofile bs=4K count=1M
> > 4294967296 bytes (4.3 GB) copied, 56.098 s, 76.6 MB/s
> > 
> > real	0m56.614s
> > 
> > test1 cgroup with memory limit 100M
> > ===================================
> > # time dd if=/dev/zero of=/root/zerofile1 bs=4K count=1M
> > 4294967296 bytes (4.3 GB) copied, 19.8097 s, 217 MB/s
> > 
> > real	0m19.992s
> > 
> 
> This is strange, did you flish the cache between the two runs?
> NOTE: Since the files are same, we reuse page cache from the
> other cgroup.

Files are different. Note suffix "1".

Vivek
