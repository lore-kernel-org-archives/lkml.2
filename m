Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab0JTCcp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 22:32:45 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39864 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab0JTCco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 22:32:44 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Figo.zhang" <zhangtianfei@leadcoretech.com>
Subject: Re: oom_killer crash linux system
Cc: kosaki.motohiro@jp.fujitsu.com, Wu Fengguang <fengguang.wu@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rientjes@google.com" <rientjes@google.com>,
        figo1802 <figo1802@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <1287540415.2069.1.camel@myhost>
References: <20101020013553.GA7428@localhost> <1287540415.2069.1.camel@myhost>
Message-Id: <20101020112828.1818.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 20 Oct 2010 11:32:38 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > > page_add_file_rmap() just counts an event where mapcount goes 0->1. 
> > > Even if thousands process shares  a page,  it's just counted into file_mapped as 1.
> > > 
> > > Then, there are 480MB of mapped file caches. Do I miss something ?
> > > 
> > > Anyway, sum-of-all-lru-of-highmem is 480MB smaller than present pages.
> > > and isolated(anon/file) is 0kB.
> > > (NORMAL has similar problem)
> > 
> > hugetlb files? But it's a desktop box. Figo, what's your meminfo?
> > 
> > The GEM objects may be files not in LRU, however they should be
> > accounted into shmem.
> > 
> > Figo, would you run "page-types -r" for some clues? It can be compiled
> > from the kernel tree:
> > 
> >         cd linux
> >         make Documentation/vm
> >         sudo Documentation/vm/page-types -r
> 
> hi fengguang,
> here is the "page-types -r" result:
> 
>              flags	page-count       MB  symbolic-flags
> long-symbolic-flags
> 0x0000000000005828	     74342      290 ___U_l_____Ma_b___________________ uptodate,lru,mmap,anonymous,swapbacked
> 0x0000000000005868	    373077     1457 ___U_lA____Ma_b___________________ uptodate,lru,active,mmap,anonymous,swapbacked

1457+290=1747MB. that's ok. and this is very different result with your
previous oom log.

can you please try 1) invoke oom 2) get page-types -r again. I'm curious
that oom makes page accounting lost again. I mean, please send us oom 
log and "page-types -r" result.

thanks.




