Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab0H2W0X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 18:26:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960Ab0H2W0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 18:26:22 -0400
Message-ID: <4C7ADE7A.2040909@redhat.com>
Date: Sun, 29 Aug 2010 18:26:02 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Ying Han <yinghan@google.com>
CC: Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Venkatesh Pallipadi <venki@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] vmscan: prevent background aging of anon page in no swap
 system
References: <1283096628-4450-1-git-send-email-minchan.kim@gmail.com>	<AANLkTinCKJw2oaNgAvfm0RawbW4zuJMtMb2pUROeY2ij@mail.gmail.com>	<4C7ABD14.9050207@redhat.com> <AANLkTimjVHp1=Fc35xLnyPb2aa+ew7w1P9DC_0GfhZgY@mail.gmail.com>
In-Reply-To: <AANLkTimjVHp1=Fc35xLnyPb2aa+ew7w1P9DC_0GfhZgY@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2010 05:23 PM, Ying Han wrote:
> On Sun, Aug 29, 2010 at 1:03 PM, Rik van Riel<riel@redhat.com>  wrote:
>> On 08/29/2010 01:45 PM, Ying Han wrote:
>>
>>> There are few other places in vmscan where we check nr_swap_pages and
>>> inactive_anon_is_low. Are we planning to change them to use
>>> total_swap_pages
>>> to be consistent ?
>>
>> If that makes sense, maybe the check can just be moved into
>> inactive_anon_is_low itself?
>
> That was the initial patch posted, instead we changed to use
> total_swap_pages instead. How this patch looks:

Looks good to me.  It could use a comment along the lines of:

	/*
	 * No sense scanning the anon lists if we have no swap space.
	 */

... and, of course, your signed-off-by :)

-- 
All rights reversed
