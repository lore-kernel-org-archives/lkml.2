Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab0G1DXN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 23:23:13 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36550 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab0G1DXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 23:23:11 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 28 Jul 2010 12:18:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        gthelen@google.com, m-ikeda@ds.jp.nec.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 4/7][memcg] memcg use ID in page_cgroup
Message-Id: <20100728121820.0475142a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100728031358.GG12642@redhat.com>
References: <20100727165155.8b458b7f.kamezawa.hiroyu@jp.fujitsu.com>
	<20100727165629.6f98145c.kamezawa.hiroyu@jp.fujitsu.com>
	<20100728023904.GE12642@redhat.com>
	<20100728114402.571b8ec6.kamezawa.hiroyu@jp.fujitsu.com>
	<20100728031358.GG12642@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jul 2010 23:13:58 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:
 
> > > So the idea is that when a page is allocated, also store the blk_group
> > > id and once that page is submitted for writeback, we should be able
> > > to associate it to right blkio group?
> > > 
> > blk_cgroup id can be attached whenever you wants. please overwrite 
> > page_cgroup->blk_cgroup when it's necessary.
> 
> > Did you read Ikeda's patch ? I myself doesn't have patches at this point. 
> > This is just for make a room for recording blkio-ID, which was requested
> > for a year.
> 
> I have not read his patches yet. IIRC, previously there were issues
> regarding which group should be charged for the page. The person who
> allocated it or the thread which did last write to it etc... I guess
> we can sort that out later.
> 
> > 
> > Hmm, but page-allocation-time doesn't sound very good for me.
> > 
> 
> Why?
> 

As you wrote, by attaching ID when a page cache is added, we'll have
much chances of free-rider until it's paged out. So, adding some
reseting-owner point may be good. 

But considering real world usage, I may be wrong.
There will not be much free rider in real world, especially at write().
Then, page-allocation time may be good.

(Because database doesn't use page-cache, there will be no big random write
 application.)

Thanks,
-Kame

