Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab1FSSkC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 14:40:02 -0400
Received: from mx.treblig.org ([80.68.94.177]:43083 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754557Ab1FSSj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 14:39:58 -0400
Date: Sun, 19 Jun 2011 19:39:55 +0100
From: "Dr. David Alan Gilbert" <dave@treblig.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: 37573e8c (cgroup fix) causing implicit declaration of function
	'node_start_pfn'
Message-ID: <20110619183955.GH2031@gallifrey>
References: <20110619151214.GF2031@gallifrey> <20110619104744.9cd631c1.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110619104744.9cd631c1.rdunlap@xenotime.net>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.32.27-kvm-i386-20110114 (i686)
X-Uptime: 19:39:18 up 121 days, 20:12,  1 user,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Randy Dunlap (rdunlap@xenotime.net) wrote:
> On Sun, 19 Jun 2011 16:12:14 +0100 Dr. David Alan Gilbert wrote:
> 
> > Hi,
> >   The current git head is failing to build for me with:
> > 
> > mm/page_cgroup.c: In function 'page_cgroup_init':
> > mm/page_cgroup.c:308:3: error: implicit declaration of function 'node_start_pfn'
> > mm/page_cgroup.c:309:3: error: implicit declaration of function 'node_end_pfn'
> > 
> > this is for a very basic 32bit x86 build, and it looks like
> > include/asm/mmzone_32.h only defines node_start_pfn and node_end_pfn on
> > CONFIG_DISCONTIGMEM - which I have off.
> > 
> > The use of node_start_pfn seems to be from 
> > 
> >   commit 37573e8c718277103f61f03741bdc5606d31b07e
> >   Author: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> >   Date:   Wed Jun 15 15:08:42 2011 -0700
> > 
> >      memcg: fix init_page_cgroup nid with sparsemem
> 
> Please see if http://marc.info/?l=linux-kernel&m=130827204306775&w=2
> fixes it for you.

Yes it does (build tested only); thank you for the pointer.

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\ gro.gilbert @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
