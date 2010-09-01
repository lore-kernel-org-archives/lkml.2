Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab0IANvf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 09:51:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754673Ab0IANvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 09:51:32 -0400
Message-ID: <4C7E5A52.7080806@redhat.com>
Date: Wed, 01 Sep 2010 09:51:14 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] vmscan,tmpfs: treat used once pages on tmpfs as used
 once
References: <20100901103653.974C.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100901103653.974C.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2010 09:37 PM, KOSAKI Motohiro wrote:
> When a page has PG_referenced, shrink_page_list() discard it only
> if it is no dirty. This rule works completely fine if the backend
> filesystem is regular one. PG_dirty is good signal that it was used
> recently because flusher thread clean pages periodically. In addition,
> page writeback is costly rather than simple page discard.
>
> However, When a page is on tmpfs, this heuristic don't works because
> flusher thread don't writeback tmpfs pages. then, tmpfs pages always
> rotate lru twice at least and it makes unnecessary lru churn. Merely
> tmpfs streaming io shouldn't cause large anonymous page swap-out.
>
> This patch remove this unncessary reclaim bonus of tmpfs pages.
>
> Cc: Hugh Dickins<hughd@google.com>
> Cc: Johannes Weiner<hannes@cmpxchg.org>
> Cc: Rik van Riel<riel@redhat.com>
> Signed-off-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
