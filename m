Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773Ab1CGXZB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 18:25:01 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58810 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982Ab1CGXZA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 18:25:00 -0500
MIME-Version: 1.0
In-Reply-To: <20110307231448.GA2946@spritzera.linux.bs1.fc.nec.co.jp>
References: <1299503155-6210-1-git-send-email-pholasek@redhat.com>
	<1299527214.8493.13263.camel@nimitz>
	<20110307145149.97e6676e.akpm@linux-foundation.org>
	<20110307231448.GA2946@spritzera.linux.bs1.fc.nec.co.jp>
Date: Mon, 7 Mar 2011 18:24:58 -0500
Message-ID: <AANLkTi=NjkQoLQX2ZYxb-oDN7x5TYybe=pMkpOeZDc-Q@mail.gmail.com>
Subject: Re: [PATCH] hugetlb: /proc/meminfo shows data for all sizes of hugepages
From: Eric B Munson <emunson@mgebm.net>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Petr Holasek <pholasek@redhat.com>, linux-kernel@vger.kernel.org,
        anton@redhat.com, Andi Kleen <ak@linux.intel.com>,
        Mel Gorman <mel@csn.ul.ie>, Wu Fengguang <fengguang.wu@intel.com>,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/7 Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>:
>> >
>> > Could we do something where we keep the default hpage_size looking like
>> > it does now, but append the size explicitly for the new entries?
>> >
>> > HugePages_Total(1G):       2
>> > HugePages_Free(1G):        1
>> > HugePages_Rsvd(1G):        1
>> > HugePages_Surp(1G):        1
>> >
>>
>> Let's not change the existing interface, please.
>>
>> Adding new fields: OK.
>> Changing the way in whcih existing fields are calculated: OKish.
>> Renaming existing fields: not OK.
>
> How about lining up multiple values in each field like this?
>
>  HugePages_Total:       5 2
>  HugePages_Free:        2 1
>  HugePages_Rsvd:        3 1
>  HugePages_Surp:        1 1
>  Hugepagesize:       2048 1048576 kB
>  ...
>
> This doesn't change the field names and the impact for user space
> is still small?
>
> Thanks,
> Naoya
>

I don't like this either, Dave's suggestion impacts userspace the
least, as code that looks for default huge page size pool info will
still find it, but it won't match the sized entries.  Your suggestion
means that I need to change how libhugetlbfs, for instance, parses
meminfo.
