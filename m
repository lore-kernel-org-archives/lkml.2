Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab1FTRBy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 13:01:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128Ab1FTRBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 13:01:53 -0400
Message-ID: <4DFF7CDD.308@redhat.com>
Date: Tue, 21 Jun 2011 01:01:17 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] mm: completely disable THP by transparent_hugepage=never
References: <1308587683-2555-1-git-send-email-amwang@redhat.com> <20110620165035.GE20843@redhat.com>
In-Reply-To: <20110620165035.GE20843@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年06月21日 00:50, Andrea Arcangeli 写道:
> On Tue, Jun 21, 2011 at 12:34:28AM +0800, Amerigo Wang wrote:
>> transparent_hugepage=never should mean to disable THP completely,
>> otherwise we don't have a way to disable THP completely.
>> The design is broken.
>
> We want to allow people to boot with transparent_hugepage=never but to
> still allow people to enable it later at runtime. Not sure why you
> find it broken... Your patch is just crippling down the feature with
> no gain. There is absolutely no gain to disallow root to enable THP
> later at runtime with sysfs, root can enable it anyway by writing into
> /dev/mem.


What can I do if I don't want to see THP at all? I mean the same
behavior as when my CPU doesn't have PSE.

With this patch, there is no even /sys/kernel/vm/transparent_hugepage/
exists.

>
> Unless you're root and you enable it, it's completely disabled, so I
> don't see what you mean it's not completely disabled. Not even
> khugepaged is started, try to grep of khugepaged... (that wouldn't be
> the same with ksm where ksm daemon runs even when it's off for no
> gain, but I explicitly solved the locking so khugepaged will go away
> when enabled=never and return when enabled=always).

Without this patch, THP is still initialized (although khugepaged is not started),
that is what I don't want to see when I pass "transparent_hugepage=never",
because "never" for me means THP is totally unseen, even not initialized.

Thanks.
