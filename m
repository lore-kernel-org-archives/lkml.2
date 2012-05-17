Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761353Ab2EQIv2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 04:51:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:62349 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756359Ab2EQIvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 04:51:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="141596750"
Message-ID: <4FB4BBAC.1050106@intel.com>
Date: Thu, 17 May 2012 16:49:48 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        rostedt@goodmis.org, fweisbec@gmail.com, jeremy@goop.org,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        dhowells@redhat.com, fenghua.yu@intel.com, borislav.petkov@amd.com,
        yinghai@kernel.org, ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, a.p.zijlstra@chello.nl,
        hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        yongjie.ren@intel.com
Subject: Re: [PATCH v6 0/7] tlb flush optimization on x86
References: <1337233375-840-1-git-send-email-alex.shi@intel.com> <4FB4B964.6050501@intel.com>
In-Reply-To: <4FB4B964.6050501@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a little more info.
the machine is 2P * 4core* HT NHM EP with 12GB memory, and THP set 'always'.

>

> Here is the macro benchmark to measure munmap change:
> 
> tlb_flushall_shift = -1
> [alexs@lkp-ne04 tlb]$ 
> [alexs@lkp-ne04 tlb]$ for t in `echo 4 8 16  `; do echo "=============== t = $t ===================="; for i in `echo  8 16 32  `; do sudo  ./munmap -t $t -n $i; done done
> =============== t = 4 ====================
> munmap use 164ms 5032ns/time, memory access uses 81605 times/thread/ms, cost 12ns/time
> munmap use 86ms 5251ns/time, memory access uses 83378 times/thread/ms, cost 11ns/time
> munmap use 46ms 5642ns/time, memory access uses 87212 times/thread/ms, cost 11ns/time
> =============== t = 8 ====================
> munmap use 197ms 6036ns/time, memory access uses 69295 times/thread/ms, cost 14ns/time
> munmap use 96ms 5896ns/time, memory access uses 71895 times/thread/ms, cost 13ns/time
> munmap use 62ms 7608ns/time, memory access uses 83895 times/thread/ms, cost 11ns/time
> =============== t = 16 ====================
> munmap use 274ms 8367ns/time, memory access uses 37860 times/thread/ms, cost 26ns/time
> munmap use 139ms 8543ns/time, memory access uses 38137 times/thread/ms, cost 26ns/time
> munmap use 74ms 9033ns/time, memory access uses 38349 times/thread/ms, cost 26ns/time
> [alexs@lkp-ne04 tlb]$ 
> [alexs@lkp-ne04 tlb]$ 
> tlb_flushall_shift = 5
> [alexs@lkp-ne04 tlb]$ for t in `echo 4 8 16  `; do echo "=============== t = $t ===================="; for i in `echo  8 16 32  `; do sudo  ./munmap -t $t -n $i; done done
> =============== t = 4 ====================
> munmap use 212ms 6485ns/time, memory access uses 114003 times/thread/ms, cost 8ns/time
> munmap use 130ms 7972ns/time, memory access uses 110725 times/thread/ms, cost 9ns/time
> munmap use 45ms 5581ns/time, memory access uses 87866 times/thread/ms, cost 11ns/time
> =============== t = 8 ====================
> munmap use 253ms 7734ns/time, memory access uses 94578 times/thread/ms, cost 10ns/time
> munmap use 147ms 9012ns/time, memory access uses 83851 times/thread/ms, cost 11ns/time
> munmap use 63ms 7713ns/time, memory access uses 87473 times/thread/ms, cost 11ns/time
> =============== t = 16 ====================
> munmap use 369ms 11284ns/time, memory access uses 38854 times/thread/ms, cost 25ns/time
> munmap use 264ms 16131ns/time, memory access uses 37870 times/thread/ms, cost 26ns/time
> munmap use 73ms 8981ns/time, memory access uses 38309 times/thread/ms, cost 26ns/time


