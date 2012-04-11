Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932867Ab2DKSPD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 14:15:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081Ab2DKSPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 14:15:01 -0400
Message-ID: <4F85BEB5.6080702@redhat.com>
Date: Wed, 11 Apr 2012 13:26:13 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Hugh Dickins <hughd@google.com>, Ying Han <yinghan@google.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] mm: vmscan: Do not stall on writeback during memory
 compaction
References: <1334162298-18942-1-git-send-email-mgorman@suse.de> <1334162298-18942-3-git-send-email-mgorman@suse.de>
In-Reply-To: <1334162298-18942-3-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2012 12:38 PM, Mel Gorman wrote:
> This patch stops reclaim/compaction entering sync reclaim as this was only
> intended for lumpy reclaim and an oversight. Page migration has its own
> logic for stalling on writeback pages if necessary and memory compaction
> is already using it.
>
> Waiting on page writeback is bad for a number of reasons but the primary
> one is that waiting on writeback to a slow device like USB can take a
> considerable length of time. Page reclaim instead uses wait_iff_congested()
> to throttle if too many dirty pages are being scanned.
>
> Signed-off-by: Mel Gorman<mgorman@suse.de>

Acked-by: Rik van Riel <riel@redhat.com>

