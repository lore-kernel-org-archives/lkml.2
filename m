Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab0LAHa1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 02:30:27 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36622 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab0LAHa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 02:30:26 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 1 Dec 2010 16:24:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: linux-mm@kvack.org, Christoph Lameter <cl@linux.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/3] Provide control over unmapped pages
Message-Id: <20101201162444.5c7b1616.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101201064043.GO2746@balbir.in.ibm.com>
References: <20101130101126.17475.18729.stgit@localhost6.localdomain6>
	<20101130101602.17475.32611.stgit@localhost6.localdomain6>
	<20101201103254.b823eae0.kamezawa.hiroyu@jp.fujitsu.com>
	<20101201051816.GI2746@balbir.in.ibm.com>
	<20101201052259.GN2746@balbir.in.ibm.com>
	<20101201143550.0b652916.kamezawa.hiroyu@jp.fujitsu.com>
	<20101201064043.GO2746@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Dec 2010 12:10:43 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> > That's a point. Then, why the guest has to do _extra_ work for host even when
> > the host says nothing ? I think trigger this by guests themselves is not very good.
> 
> I've mentioned it before, the guest keeping free memory without a
> large performance hit, helps, the balloon driver is able to quickly
> retrieve this memory if required or the guest can use this memory for
> some other application/task. 


> The cached data is mostly already present in the host page cache.

Why ? Are there parameters/stats which shows this is _true_ ? How we can
guarantee/show it to users ?
Please add an interface to show "shared rate between guest/host" If not,
any admin will not turn this on because "file cache status on host" is a
black box for guest admins. I think this patch skips something important steps.

2nd point is maybe for reducing total host memory usage and for increasing
the number of guests on a host. For that, this feature is useful only when all guests
on a host are friendly and devoted to the health of host memory management because
all setting must be done in the guest. This can be passed as even by qemu's command line
argument. And _no_ benefit for the guests who reduce it's resource to help
host management because there is no guarantee dropped caches are on host memory.


So, for both claim, I want to see an interface to show the number of shared pages
between hosts and guests rather than imagine it.

BTW, I don't like this kind of "please give us your victim, please please please"
logic. The host should be able to "steal" what it wants in force.
Then, I think there should be no On/Off visible interfaces. The vm firmware
should tell to turn on this if administrator of the host wants.

BTW2, please test with some other benchmarks (which read file caches.)
I don't think kernel make is good test for this.

Thanks,
-Kame

