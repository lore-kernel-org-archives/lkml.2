Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab2BYFeK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 00:34:10 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62397 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab2BYFeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 00:34:08 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of koct9i@gmail.com designates 10.205.117.4 as permitted sender) smtp.mail=koct9i@gmail.com; dkim=pass header.i=koct9i@gmail.com
Message-ID: <4F4872CC.1000702@openvz.org>
Date: Sat, 25 Feb 2012 09:34:04 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20120201 Iceape/2.0.14
MIME-Version: 1.0
To: Tim Chen <tim.c.chen@linux.intel.com>
CC: Hugh Dickins <hughd@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v3 00/21] mm: lru_lock splitting
References: <20120223133728.12988.5432.stgit@zurg> <1330128354.13358.43.camel@schen9-DESK>
In-Reply-To: <1330128354.13358.43.camel@schen9-DESK>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Chen wrote:
> On Thu, 2012-02-23 at 17:51 +0400, Konstantin Khlebnikov wrote:
>> v3 changes:
>> * inactive-ratio reworked again, now it always calculated from from scratch
>> * hierarchical pte reference bits filter in memory-cgroup reclaimer
>> * fixed two bugs in locking, found by Hugh Dickins
>> * locking functions slightly simplified
>> * new patch for isolated pages accounting
>> * new patch with lru interleaving
>>
>> This patchset is based on next-20120210
>>
>> git: https://github.com/koct9i/linux/commits/lruvec-v3
>>
>> ---
>
> I am seeing an improvement of about 7% in throughput in a workload where
> I am doing parallel reading of files that are mmaped. The contention on
> lru_lock used to be 13% in the cpu profile on the __pagevec_lru_add code
> path. Now lock contention on this path drops to about 0.6%.  I have 40
> hyper-threaded enabled cpu cores running 80 mmaped file reading
> processes.
>
> So initial testing of this patch set looks encouraging.

That's great!

>
> Tim
>

