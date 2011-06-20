Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab1FTRXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 13:23:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755310Ab1FTRXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 13:23:35 -0400
Message-ID: <4DFF8207.5080700@redhat.com>
Date: Tue, 21 Jun 2011 01:23:19 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] mm: make the threshold of enabling THP configurable
References: <1308587683-2555-1-git-send-email-amwang@redhat.com>	 <1308587683-2555-2-git-send-email-amwang@redhat.com> <1308589163.11430.245.camel@nimitz>
In-Reply-To: <1308589163.11430.245.camel@nimitz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年06月21日 00:59, Dave Hansen 写道:
> On Tue, 2011-06-21 at 00:34 +0800, Amerigo Wang wrote:
>> +config TRANSPARENT_HUGEPAGE_THRESHOLD
>> +       depends on TRANSPARENT_HUGEPAGE
>> +       int "The minimal threshold of enabling Transparent Hugepage"
>> +       range 512 8192
>> +       default "512"
>> +       help
>> +         The threshold of enabling Transparent Huagepage automatically,
>> +         in Mbytes, below this value, Transparent Hugepage will be disabled
>> +         by default during boot.
>
> It makes some sense to me that there would _be_ a threshold, simply
> because you need some space to defragment things.  But, I can't imagine
> any kind of user having *ANY* kind of idea what to set this to.  Could
> we add some text to this?  Maybe:
>
>          Transparent hugepages are created by moving other pages out of
>          the way to create large, contiguous swaths of free memory.
>          However, some memory on a system can not be easily moved.  It is
>          likely on small systems that this unmovable memory will occupy a
>          large portion of total memory, which makes even attempting to
>          create transparent hugepages very expensive.
>
>          If you are unsure, set this to the smallest possible value.
>
>          To override this at boot, use the $FOO boot command-line option.
>

Yeah, I totally agree to improve the help message as you said,
please forgive a non-English speaker. ;)

> I'm also not sure putting a ceiling on this makes a lot of sense.
> What's the logic behind that?  I know it would be a mess to expose it to
> users, but shouldn't this be a per-zone limit, logically?  Seems like a
> 8GB system would have similar issues to a two-numa-node 16GB system.
>

I am not sure about this, since I am new to THP, I just replaced
the hard-code 512 with a Kconfig var. But I am certainly open
to improve this as you said if Andrea agrees.

Thanks.
