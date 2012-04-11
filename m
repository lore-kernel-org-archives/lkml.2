Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932927Ab2DKSvl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 14:51:41 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45488 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab2DKSvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 14:51:40 -0400
MIME-Version: 1.0
In-Reply-To: <4F85BEB5.6080702@redhat.com>
References: <1334162298-18942-1-git-send-email-mgorman@suse.de>
 <1334162298-18942-3-git-send-email-mgorman@suse.de> <4F85BEB5.6080702@redhat.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Wed, 11 Apr 2012 14:51:19 -0400
Message-ID: <CAHGf_=pUvc33SNHeBMsOrhacRVnoxJgYwZvnAG9TqxOLEU3J5w@mail.gmail.com>
Subject: Re: [PATCH 2/3] mm: vmscan: Do not stall on writeback during memory compaction
To: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Hugh Dickins <hughd@google.com>, Ying Han <yinghan@google.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 1:26 PM, Rik van Riel <riel@redhat.com> wrote:
> On 04/11/2012 12:38 PM, Mel Gorman wrote:
>>
>> This patch stops reclaim/compaction entering sync reclaim as this was only
>> intended for lumpy reclaim and an oversight. Page migration has its own
>> logic for stalling on writeback pages if necessary and memory compaction
>> is already using it.
>>
>> Waiting on page writeback is bad for a number of reasons but the primary
>> one is that waiting on writeback to a slow device like USB can take a
>> considerable length of time. Page reclaim instead uses
>> wait_iff_congested()
>> to throttle if too many dirty pages are being scanned.
>>
>> Signed-off-by: Mel Gorman<mgorman@suse.de>
>
>
> Acked-by: Rik van Riel <riel@redhat.com>

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
