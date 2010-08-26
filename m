Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab0HZASu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 20:18:50 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40125 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab0HZASr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 20:18:47 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 26 Aug 2010 09:13:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: linux-mm@kvack.org,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        gthelen@google.com, m-ikeda@ds.jp.nec.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "menage@google.com" <menage@google.com>,
        "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 1/5] cgroup: do ID allocation under css allocator.
Message-Id: <20100826091346.88eb3ecc.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100825141500.GA32680@balbir.in.ibm.com>
References: <20100825170435.15f8eb73.kamezawa.hiroyu@jp.fujitsu.com>
	<20100825170640.5f365629.kamezawa.hiroyu@jp.fujitsu.com>
	<20100825141500.GA32680@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Aug 2010 19:45:00 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-08-25 17:06:40]:
> 
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > Now, css'id is allocated after ->create() is called. But to make use of ID
> > in ->create(), it should be available before ->create().
> > 
> > In another thinking, considering the ID is tightly coupled with "css",
> > it should be allocated when "css" is allocated.
> > This patch moves alloc_css_id() to css allocation routine. Now, only 2 subsys,
> > memory and blkio are useing ID. (To support complicated hierarchy walk.)
>                        ^^^^ typo
> > 
> > ID will be used in mem cgroup's ->create(), later.
> > 
> > Note:
> > If someone changes rules of css allocation, ID allocation should be moved too.
> > 
> 
> What rules? could you please elaborate?
> 
See Paul Menage's mail. He said "allocating css object under kernel/cgroup.c
will make kernel/cgroup.c cleaner." But it seems too big for my purpose.

> Seems cleaner, may be we need to update cgroups.txt?

Hmm. will look into.

Thanks,
-Kame

> 
> -- 
> 	Three Cheers,
> 	Balbir
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 
> 

