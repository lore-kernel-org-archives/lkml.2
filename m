Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab0IBPRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 11:17:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649Ab0IBPRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 11:17:17 -0400
Message-ID: <4C7FBFE6.7060600@redhat.com>
Date: Thu, 02 Sep 2010 11:16:54 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ying Han <yinghan@google.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2] vmscan: prevent background aging of anon page in no
 swap system
References: <1283440333-14451-1-git-send-email-minchan.kim@gmail.com>
In-Reply-To: <1283440333-14451-1-git-send-email-minchan.kim@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2010 11:12 AM, Minchan Kim wrote:

> +	/*
> +	 * If we don't have enough swap space, anonymous page deactivation
> +	 * is pointless.
> +	 */
> +	if (!nr_swap_pages)
> +		return 0;

It may be better to test !total_swap_pages and change the
comment to:

	/*
	 * If we don't have swap space, anonymous page deactivation
	 * is pointless.
	 */

-- 
All rights reversed
