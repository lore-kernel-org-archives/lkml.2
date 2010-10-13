Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab0JMIpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 04:45:16 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59047 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab0JMIpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 04:45:14 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 13 Oct 2010 17:39:50 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "linux-mm\@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "minchan.kim\@gmail.com" <minchan.kim@gmail.com>,
        fujita.tomonori@lab.ntt.co.jp
Subject: Re: [RFC][PATCH 1/3] contigous big page allocator
Message-Id: <20101013173950.0521c849.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <87ocay1obe.fsf@basil.nowhere.org>
References: <20101013121527.8ec6a769.kamezawa.hiroyu@jp.fujitsu.com>
	<87sk0a1sq0.fsf@basil.nowhere.org>
	<20101013161206.c29df8ea.kamezawa.hiroyu@jp.fujitsu.com>
	<87ocay1obe.fsf@basil.nowhere.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Oct 2010 10:36:53 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:
> 
> >> >   My intention is not for allocating HUGEPAGE(> MAX_ORDER).
> >> 
> >> I still believe using this for 1GB pages would be one of the more
> >> interesting use cases.
> >> 
> >
> > I'm successfully allocating 1GB of continous pages at test. But I'm not sure
> > requirements and users. How quick this allocation should be ?
> 
> This will always be slow. Huge pages are always pre allocated
> even today through a sysctl. The use case would be have
> 
> echo XXX > /proc/sys/vm/nr_hugepages 
> 
> at runtime working for 1GB too, instead of requiring a reboot
> for this. 
> 
> I think it's ok if that is somewhat slow, as long as it is not
> incredible slow. Ideally it shouldn't cause a swap storm either 
> 
> (maybe we need some way to indicate how hard the freeing code should
> try?)
> 
yes. I think this patch should be update to do a precice control of memory
pressure. It will improve memory hotplug's memory allocation, too.


> I guess it would only really work well if you predefine
> movable zones at boot time.
> 

I think so, too. But maybe enough for embeded guys and very special systems
which need to use 1G page.

Thanks,
-Kame

