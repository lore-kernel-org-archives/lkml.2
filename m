Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab0CQTtY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 15:49:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755844Ab0CQTtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 15:49:22 -0400
Date: Wed, 17 Mar 2010 15:48:30 -0400
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
Message-ID: <20100317194830.GD9198@redhat.com>
References: <1268609202-15581-1-git-send-email-arighi@develer.com> <20100315171209.GI21127@redhat.com> <20100315171921.GJ21127@redhat.com> <20100317115427.GR18054@balbir.in.ibm.com> <20100317133407.GA9198@redhat.com> <20100317191743.GY18054@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100317191743.GY18054@balbir.in.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 12:47:43AM +0530, Balbir Singh wrote:
> * Vivek Goyal <vgoyal@redhat.com> [2010-03-17 09:34:07]:
> 
> > On Wed, Mar 17, 2010 at 05:24:28PM +0530, Balbir Singh wrote:
> > > * Vivek Goyal <vgoyal@redhat.com> [2010-03-15 13:19:21]:
> > > 
> > > > On Mon, Mar 15, 2010 at 01:12:09PM -0400, Vivek Goyal wrote:
> > > > > On Mon, Mar 15, 2010 at 12:26:37AM +0100, Andrea Righi wrote:
> > > > > > Control the maximum amount of dirty pages a cgroup can have at any given time.
> > > > > > 
> > > > > > Per cgroup dirty limit is like fixing the max amount of dirty (hard to reclaim)
> > > > > > page cache used by any cgroup. So, in case of multiple cgroup writers, they
> > > > > > will not be able to consume more than their designated share of dirty pages and
> > > > > > will be forced to perform write-out if they cross that limit.
> > > > > > 
> > > > > 
> > > > > For me even with this version I see that group with 100M limit is getting
> > > > > much more BW.
> > > > > 
> > > > > root cgroup
> > > > > ==========
> > > > > #time dd if=/dev/zero of=/root/zerofile bs=4K count=1M
> > > > > 4294967296 bytes (4.3 GB) copied, 55.7979 s, 77.0 MB/s
> > > > > 
> > > > > real	0m56.209s
> > > > > 
> > > > > test1 cgroup with memory limit of 100M
> > > > > ======================================
> > > > > # time dd if=/dev/zero of=/root/zerofile1 bs=4K count=1M
> > > > > 4294967296 bytes (4.3 GB) copied, 20.9252 s, 205 MB/s
> > > > > 
> > > > > real	0m21.096s
> > > > > 
> > > > > Note, these two jobs are not running in parallel. These are running one
> > > > > after the other.
> > > > > 
> > > > 
> 
> The data is not always repeatable at my end. Are you able to modify
> the order and get repeatable results?
> 
> In fact, I saw
> 
> for cgroup != root
> ------------------
> 4294967296 bytes (4.3 GB) copied, 120.359 s, 35.7 MB/s
> 
> for cgroup = root
> -----------------
> 4294967296 bytes (4.3 GB) copied, 84.504 s, 50.8 MB/s
> 
> This is without the patches applied.

I lost the access to the big configuration machine but on that machine I
could reproduce it all the time. But on smaller machine (4core, 4G), I 
could not.

I will do some more tests later.

Vivek
