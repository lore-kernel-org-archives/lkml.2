Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab0JMIg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 04:36:56 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50252 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309Ab0JMIgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 04:36:55 -0400
From: Andi Kleen <andi@firstfloor.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm\@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "minchan.kim\@gmail.com" <minchan.kim@gmail.com>,
        fujita.tomonori@lab.ntt.co.jp
Subject: Re: [RFC][PATCH 1/3] contigous big page allocator
References: <20101013121527.8ec6a769.kamezawa.hiroyu@jp.fujitsu.com>
	<87sk0a1sq0.fsf@basil.nowhere.org>
	<20101013161206.c29df8ea.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 13 Oct 2010 10:36:53 +0200
In-Reply-To: <20101013161206.c29df8ea.kamezawa.hiroyu@jp.fujitsu.com>
	(KAMEZAWA Hiroyuki's message of "Wed, 13 Oct 2010 16:12:06 +0900")
Message-ID: <87ocay1obe.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:

>> >   My intention is not for allocating HUGEPAGE(> MAX_ORDER).
>> 
>> I still believe using this for 1GB pages would be one of the more
>> interesting use cases.
>> 
>
> I'm successfully allocating 1GB of continous pages at test. But I'm not sure
> requirements and users. How quick this allocation should be ?

This will always be slow. Huge pages are always pre allocated
even today through a sysctl. The use case would be have

echo XXX > /proc/sys/vm/nr_hugepages 

at runtime working for 1GB too, instead of requiring a reboot
for this. 

I think it's ok if that is somewhat slow, as long as it is not
incredible slow. Ideally it shouldn't cause a swap storm either 

(maybe we need some way to indicate how hard the freeing code should
try?)

I guess it would only really work well if you predefine
movable zones at boot time.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
