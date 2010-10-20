Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757882Ab0JTDYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 23:24:39 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41803 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757092Ab0JTDYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 23:24:38 -0400
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
In-Reply-To: <1287543520.2074.1.camel@myhost>
References: <20101020112828.1818.A69D9226@jp.fujitsu.com> <1287543520.2074.1.camel@myhost>
Message-Id: <20101020122137.1824.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 20 Oct 2010 12:24:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > 
> > can you please try 1) invoke oom 2) get page-types -r again. I'm curious
> > that oom makes page accounting lost again. I mean, please send us oom 
> > log and "page-types -r" result.
> > 
> > thanks
> 
> ok, i do the experiment and catch the log:

thanks.


> active_anon:398375 inactive_anon:82967 isolated_anon:0 
>  active_file:81 inactive_file:429 isolated_file:32
>  unevictable:13 dirty:2 writeback:14 unstable:0
>  free:11942 slab_reclaimable:2391 slab_unreclaimable:3303
>  mapped:5617 shmem:33909 pagetables:2280 bounce:0

active_anon + inactive_anon + isolated_anon = 481342 pages ~= 1.8GB
Um, this oom doesn't makes accounting lost.

> here is the page-types log:
>              flags	page-count       MB  symbolic-flags long-symbolic-flags
> 
> 0x0000000000005828	     83024      324 ___U_l_____Ma_b___________________ uptodate,lru,mmap,anonymous,swapbacked
> 0x0000000000005868	    358737     1401 ___U_lA____Ma_b___________________ uptodate,lru,active,mmap,anonymous,swapbacked
>              total	    515071     2011

page-types show similar result.


The big difference is, previous and current are showing some different processes.
only previous has VirtualBox, only current has vmware-usbarbit, etc..

Can you use same test environment?



