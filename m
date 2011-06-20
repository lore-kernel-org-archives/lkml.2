Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab1FTRKp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 13:10:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927Ab1FTRKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 13:10:42 -0400
Message-ID: <4DFF7F0A.8090604@redhat.com>
Date: Mon, 20 Jun 2011 13:10:34 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Cong Wang <amwang@redhat.com>
CC: Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] mm: completely disable THP by transparent_hugepage=never
References: <1308587683-2555-1-git-send-email-amwang@redhat.com> <20110620165844.GA9396@suse.de> <4DFF7E3B.1040404@redhat.com>
In-Reply-To: <4DFF7E3B.1040404@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2011 01:07 PM, Cong Wang wrote:
> 于 2011年06月21日 00:58, Mel Gorman 写道:
>> On Tue, Jun 21, 2011 at 12:34:28AM +0800, Amerigo Wang wrote:
>>> transparent_hugepage=never should mean to disable THP completely,
>>> otherwise we don't have a way to disable THP completely.
>>> The design is broken.
>>>
>>
>> I don't get why it's broken. Why would the user be prevented from
>> enabling it at runtime?
>>
>
> We need to a way to totally disable it, right? Otherwise, when I configure
> THP in .config, I always have THP initialized even when I pass "=never".
>
> For me, if you don't provide such way to disable it, it is not flexible.
>
> I meet this problem when I try to disable THP in kdump kernel, there is
> no user of THP in kdump kernel, THP is a waste for kdump kernel. This is
> why I need to find a way to totally disable it.

What you have not explained yet is why having THP
halfway initialized (but not used, and without a
khugepaged thread) is a problem at all.

Why is it a problem for you?
