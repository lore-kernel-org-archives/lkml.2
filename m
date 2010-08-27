Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab0H0NtM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 09:49:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753533Ab0H0NtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 09:49:10 -0400
Message-ID: <4C77C20F.1050405@redhat.com>
Date: Fri, 27 Aug 2010 09:47:59 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Neil Brown <neilb@suse.de>, Con Kolivas <kernel@kolivas.org>,
        Jan Kara <jack@suse.cz>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "david@fromorbit.com" <david@fromorbit.com>, "hch@lst.de" <hch@lst.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Subject: Re: [PATCH] writeback: remove the internal 5% low bound on dirty_ratio
References: <20100827103603.GB6237@localhost>
In-Reply-To: <20100827103603.GB6237@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2010 06:36 AM, Wu Fengguang wrote:
> The dirty_ratio was siliently limited in global_dirty_limits() to>= 5%.
> This is not a user expected behavior. And it's inconsistent with
> calc_period_shift(), which uses the plain vm_dirty_ratio value.
>
> Let's rip the internal bound.
>
> At the same time, fix balance_dirty_pages() to work with the
> dirty_thresh=0 case. This allows applications to proceed when
> dirty+writeback pages are all cleaned.
>
> And ">" fits with the name "exceeded" better than">=" does. Neil
> think it is an aesthetic improvement as well as a functional one :)
>
> CC: Jan Kara<jack@suse.cz>
> CC: Rik van Riel<riel@redhat.com>
> CC: Peter Zijlstra<a.p.zijlstra@chello.nl>
> Proposed-by: Con Kolivas<kernel@kolivas.org>
> Reviewed-by: Neil Brown<neilb@suse.de>
> Reviewed-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: Wu Fengguang<fengguang.wu@intel.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
