Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757788Ab1FVDH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 23:07:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757308Ab1FVDH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 23:07:28 -0400
Message-ID: <4E015C36.2050005@redhat.com>
Date: Wed, 22 Jun 2011 11:06:30 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        dave@linux.vnet.ibm.com, Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [PATCH v2 2/4] mm: make the threshold of enabling THP configurable
References: <1308643849-3325-1-git-send-email-amwang@redhat.com> <1308643849-3325-2-git-send-email-amwang@redhat.com> <alpine.DEB.2.00.1106211817340.5205@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1106211817340.5205@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年06月22日 09:23, David Rientjes 写道:
> On Tue, 21 Jun 2011, Amerigo Wang wrote:
>
>> Don't hard-code 512M as the threshold in kernel, make it configruable,
>> and set 512M by default.
>>
>> And print info when THP is disabled automatically on small systems.
>>
>> V2: Add more description in help messages, correct some typos,
>> print the mini threshold too.
>>
>
> I like the printk that notifies users why THP was disabled because it
> could potentially be a source of confusion (and fixing the existing typos
> in hugepage_init() would also be good).  However, I disagree that we need
> to have this as a config option: you either want the feature for your
> systems or you don't.  Perhaps add a "transparent_hugepage=force" option
> that will act as "always" but also force it to be enabled in all
> scenarios, even without X86_FEATURE_PSE, that will override all the logic
> that thinks it knows better?

I think that is overkill, because we can still enable THP via /sys
for small systems.

Thanks.
