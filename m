Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab0G1D0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 23:26:20 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36721 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab0G1D0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 23:26:18 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 28 Jul 2010 12:21:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        gthelen@google.com, m-ikeda@ds.jp.nec.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 4/7][memcg] memcg use ID in page_cgroup
Message-Id: <20100728122128.411f2128.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100728121820.0475142a.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100727165155.8b458b7f.kamezawa.hiroyu@jp.fujitsu.com>
	<20100727165629.6f98145c.kamezawa.hiroyu@jp.fujitsu.com>
	<20100728023904.GE12642@redhat.com>
	<20100728114402.571b8ec6.kamezawa.hiroyu@jp.fujitsu.com>
	<20100728031358.GG12642@redhat.com>
	<20100728121820.0475142a.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jul 2010 12:18:20 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
 
> > > Hmm, but page-allocation-time doesn't sound very good for me.
> > > 
> > 
> > Why?
> > 
> 
> As you wrote, by attaching ID when a page cache is added, we'll have
> much chances of free-rider until it's paged out. So, adding some
> reseting-owner point may be good. 
> 
> But considering real world usage, I may be wrong.
> There will not be much free rider in real world, especially at write().
> Then, page-allocation time may be good.
> 
> (Because database doesn't use page-cache, there will be no big random write
>  application.)
> 

Sorry, one more reason. memory cgroup has much complex code for supporting
move_account, re-attaching memory cgroup per pages.
So, if you take care of task-move-between-groups, blkio-ID may have
some problems if you only support allocation-time accounting.

Thanks,
-Kame


