Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075Ab1DYCm2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 22:42:28 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33523 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758043Ab1DYCm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 22:42:27 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
Subject: Re: 2.6.39-rc4+: Kernel leaking memory during FS scanning, regression?
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20110424235928.71af51e0@neptune.home>
References: <20110424202158.45578f31@neptune.home> <20110424235928.71af51e0@neptune.home>
Message-Id: <20110425114429.266A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Mon, 25 Apr 2011 11:42:25 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, 24 April 2011 Bruno Prémont <bonbons@linux-vserver.org> wrote:
> > On an older system I've been running Gentoo's revdep-rebuild to check
> > for system linking/*.la consistency and after doing most of the work the
> > system starved more or less, just complaining about stuck tasks now and
> > then.
> > Memory usage graph as seen from userspace showed sudden quick increase of
> > memory usage though only a very few MB were swapped out (c.f. attached RRD
> > graph).
> 
> Seems I've hit it once again (though detected before system was fully
> stalled by trying to reclaim memory without success).
> 
> This time it was during simple compiling...
> Gathered info below:
> 
> /proc/meminfo:
> MemTotal:         480660 kB
> MemFree:           64948 kB
> Buffers:           10304 kB
> Cached:             6924 kB
> SwapCached:         4220 kB
> Active:            11100 kB
> Inactive:          15732 kB
> Active(anon):       4732 kB
> Inactive(anon):     4876 kB
> Active(file):       6368 kB
> Inactive(file):    10856 kB
> Unevictable:          32 kB
> Mlocked:              32 kB
> SwapTotal:        524284 kB
> SwapFree:         456432 kB
> Dirty:                80 kB
> Writeback:             0 kB
> AnonPages:          6268 kB
> Mapped:             2604 kB
> Shmem:                 4 kB
> Slab:             250632 kB
> SReclaimable:      51144 kB
> SUnreclaim:       199488 kB   <--- look big as well...
> KernelStack:      131032 kB   <--- what???

KernelStack is used 8K bytes per thread. then, your system should have
16000 threads. but your ps only showed about 80 processes.
Hmm... stack leak?


> PageTables:          920 kB
> NFS_Unstable:          0 kB
> Bounce:                0 kB
> WritebackTmp:          0 kB
> CommitLimit:      764612 kB
> Committed_AS:     132632 kB
> VmallocTotal:     548548 kB
> VmallocUsed:       18500 kB
> VmallocChunk:     525952 kB
> AnonHugePages:         0 kB
> DirectMap4k:       32704 kB
> DirectMap4M:      458752 kB
> 


