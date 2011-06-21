Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab1FUDPT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 23:15:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374Ab1FUDPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 23:15:17 -0400
Message-ID: <4E000CB5.3050201@redhat.com>
Date: Tue, 21 Jun 2011 11:15:01 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] mm: completely disable THP by transparent_hugepage=never
References: <1308587683-2555-1-git-send-email-amwang@redhat.com> <20110620165035.GE20843@redhat.com> <4DFF7CDD.308@redhat.com> <20110620194321.GI20843@redhat.com>
In-Reply-To: <20110620194321.GI20843@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年06月21日 03:43, Andrea Arcangeli 写道:
> On Tue, Jun 21, 2011 at 01:01:17AM +0800, Cong Wang wrote:
>> Without this patch, THP is still initialized (although khugepaged is not started),
>> that is what I don't want to see when I pass "transparent_hugepage=never",
>> because "never" for me means THP is totally unseen, even not initialized.
>
> The ram saving by not registering in sysfs is not worth the loss of
> generic functionality. You can try to make the hash and slab
> khugepaged allocations more dynamic if you want to microoptimize for
> RAM usage, that I wouldn't be against if you find a way to do it
> simply and without much complexity (and .text) added. But likely there
> are other places to optimize that may introduce less tricks and would
> give you a bigger saving than ~8kbytes, it's up to you.

But the THP functionality is not going to be used.

Yeah, sounds reasonable, I will try to check if I can make it.

Thanks for pointing this out!
