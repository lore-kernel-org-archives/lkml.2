Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab1KUPhp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 10:37:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755440Ab1KUPho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 10:37:44 -0500
Message-ID: <4ECA702B.5050908@redhat.com>
Date: Mon, 21 Nov 2011 10:37:15 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        Minchan Kim <minchan.kim@gmail.com>, Jan Kara <jack@suse.cz>,
        Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8] Revert "vmscan: abort reclaim/compaction if compaction
 can proceed"
References: <1321635524-8586-1-git-send-email-mgorman@suse.de> <1321732460-14155-8-git-send-email-aarcange@redhat.com> <20111121130915.GF19415@suse.de>
In-Reply-To: <20111121130915.GF19415@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2011 08:09 AM, Mel Gorman wrote:
> On Sat, Nov 19, 2011 at 08:54:19PM +0100, Andrea Arcangeli wrote:
>> This reverts commit e0c23279c9f800c403f37511484d9014ac83adec.
>>
>> If reclaim runs with an high order allocation, it means compaction
>> failed. That means something went wrong with compaction so we can't
>> stop reclaim too. We can't assume it failed and was deferred because
>> of the too low watermarks in compaction_suitable only, it may have
>> failed for other reasons.
>>
>
> When Rik was testing with THP enabled, he found that there was way
> too much memory free on his machine.

Agreed, without these patches, I saw up to about 4GB
of my 12GB memory being freed by pageout activity,
despite the programs in my system only taking about
10GB anonymous memory.

Needless to say, this completely killed system
performance, by constantly pushing everything into
swap and keeping 10-30% of memory free constantly.

This revert makes no sense at all.
