Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab0JNB7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 21:59:13 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36774 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab0JNB7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 21:59:12 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC][PATCH 1/3] contigous big page allocator
Cc: kosaki.motohiro@jp.fujitsu.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-mm\@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "minchan.kim\@gmail.com" <minchan.kim@gmail.com>,
        fujita.tomonori@lab.ntt.co.jp
In-Reply-To: <87ocay1obe.fsf@basil.nowhere.org>
References: <20101013161206.c29df8ea.kamezawa.hiroyu@jp.fujitsu.com> <87ocay1obe.fsf@basil.nowhere.org>
Message-Id: <20101014105521.8B80.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 14 Oct 2010 10:59:06 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

offtopic: When I tried to increase nr_hugepages on ia64
which has 256MB hugepage architecture, sometimes I needed to wait
>10 miniture if the system is under memory pressure. So, slow allocation
is NOT only this contigous allocator issue. we already accept it and
we should. (I doubt it can be avoidable)



> 
> (maybe we need some way to indicate how hard the freeing code should
> try?)
> 
> I guess it would only really work well if you predefine
> movable zones at boot time.
> 
> -Andi


