Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760846Ab2DKSKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 14:10:16 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:65140 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab2DKSKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 14:10:14 -0400
Message-ID: <4F85C909.8040905@gmail.com>
Date: Wed, 11 Apr 2012 14:10:17 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kosaki.motohiro@gmail.com
Subject: Re: [PATCH -mm] remove swap token code
References: <20120409113201.6dff571a@annuminas.surriel.com> <20120411014855.GA1929@cmpxchg.org>
In-Reply-To: <20120411014855.GA1929@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(4/10/12 9:48 PM), Johannes Weiner wrote:
> On Mon, Apr 09, 2012 at 11:32:01AM -0400, Rik van Riel wrote:
>> The swap token code no longer fits in with the current VM model.
>> It does not play well with cgroups or the better NUMA placement
>> code in development, since we have only one swap token globally.
>>
>> It also has the potential to mess with scalability of the system,
>> by increasing the number of non-reclaimable pages on the active
>> and inactive anon LRU lists.
>>
>> Last but not least, the swap token code has been broken for a
>> year without complaints.  This suggests we no longer have much
>> use for it.
>>
>> The days of sub-1G memory systems with heavy use of swap are
>> over. If we ever need thrashing reducing code in the future,
>> we will have to implement something that does scale.
>>
>> Signed-off-by: Rik van Riel<riel@redhat.com>
>
> Acked-by: Johannes Weiner<hannes@cmpxchg.org>

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

I really think swap token is sane. but now (after merging Johannes's memcg naturalization)
it don't work and we don't have a reason to maintain _current_ implementaion.



