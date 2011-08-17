Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106Ab1HQMnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 08:43:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50934 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887Ab1HQMnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 08:43:49 -0400
Date: Wed, 17 Aug 2011 14:43:40 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Arend van Spriel <arend@broadcom.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <bsingharora@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ying Han <yinghan@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: [PATCH V2 1/1][cleanup] memcg: renaming of mem variable to memcg
Message-ID: <20110817124339.GA10245@tiehlicka.suse.cz>
References: <20110812070623.28939.4733.sendpatchset@oc5400248562.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110812070623.28939.4733.sendpatchset@oc5400248562.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for late reply

On Fri 12-08-11 12:36:23, Raghavendra K T wrote:
>  The memcg code sometimes uses "struct mem_cgroup *mem" and sometimes uses
>  "struct mem_cgroup *memcg". This patch renames all mem variables to memcg in
>  source file.
> 
> Testing : Compile tested with following configurations.
> 1) make defconfig ARCH=i386 + CONFIG_CGROUP_MEM_RES_CTLR=y 
> CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y CONFIG_CGROUP_MEM_RES_CTLR_SWAP_ENABLED=y
> 
> Binary size Before patch
> ========================
>    text	   data	    bss	    dec	    hex	filename
> 8911169	 520464	1884160	11315793	 acaa51	vmlinux
> 
> Binary Size After patch
> =======================
>    text	   data	    bss	    dec	    hex	filename
> 8911169	 520464	1884160	11315793	 acaa51	vmlinux

It would be much nicer to see unchanged md5sum. I am not sure how much
possible is this with current gcc or whether special command line
parameters have to be used (at least !CONFIG_DEBUG_INFO* is necessary)
but simple variable rename shouldn't be binary visible.
I guess that a similar approach was used during 32b and 64b x86
unification.

> 
> 2) make defconfig ARCH=i386 + CONFIG_CGROUP_MEM_RES_CTLR=y
> CONFIG_CGROUP_MEM_RES_CTLR_SWAP=n CONFIG_CGROUP_MEM_RES_CTLR_SWAP_ENABLED=n

I would assume the same testing results as above

> 
> 3) make defconfig ARCH=i386  CONFIG_CGROUP_MEM_RES_CTLR=n
> CONFIG_CGROUP_MEM_RES_CTLR_SWAP=n CONFIG_CGROUP_MEM_RES_CTLR_SWAP_ENABLED=n

ditto.

> 
> Other sanity check:
> Bootable configuration on x86 (T60p)  with  CONFIG_CGROUP_MEM_RES_CTLR=y 
> CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y CONFIG_CGROUP_MEM_RES_CTLR_SWAP_ENABLED=y
> is tesed with basic mounting of memcgroup, creation of child and parallel fault.
> mkdir -p /cgroup
> mount -t cgroup none /cgroup -o memory
> mkdir /cgroup/0
> echo $$ > /cgroup/0/tasks
> time ./parallel_fault 2 100000 32
> 
> real	0m0.025s
> user	0m0.001s
> sys	0m0.033s

This looks like a random test. I wouldn't add it to the changelog.
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
