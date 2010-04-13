Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab0DMXkU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 19:40:20 -0400
Received: from mail-iw0-f197.google.com ([209.85.223.197]:55768 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678Ab0DMXkS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 19:40:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=P4E5njt7kT6I4/ZXww2u7puqKYou04JuBRsWz81wsxkyJyKxQa82k3OWnOz2nj10Bu
         PSEH4p8/vQd3u3nSyQiKVKIBHh6Tnr1bjym/E4tjcHlU0Ex7Hb0tOd1vyAt1+QL2z156
         nxq5leLm/0nN1v8DCild/+701bj34cFNX7Gt4=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1004131437140.8617@chino.kir.corp.google.com>
References: <9918f566ab0259356cded31fd1dd80da6cae0c2b.1271171877.git.minchan.kim@gmail.com>
	 <8b348d9cc1ea4960488b193b7e8378876918c0d4.1271171877.git.minchan.kim@gmail.com>
	 <alpine.DEB.2.00.1004131437140.8617@chino.kir.corp.google.com>
Date: Wed, 14 Apr 2010 08:40:16 +0900
Message-ID: <u2o28c262361004131640zd034a692s4b46ee77c08e1ccd@mail.gmail.com>
Subject: Re: [PATCH 3/6] change alloc function in alloc_slab_page
From: Minchan Kim <minchan.kim@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Bob Liu <lliubbo@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 6:37 AM, David Rientjes <rientjes@google.com> wrote:
> On Wed, 14 Apr 2010, Minchan Kim wrote:
>
>> alloc_slab_page never calls alloc_pages_node with -1.
>> It means node's validity check is unnecessary.
>> So we can use alloc_pages_exact_node instead of alloc_pages_node.
>> It could avoid comparison and branch as 6484eb3e2a81807722 tried.
>>
>> Cc: Christoph Lameter <cl@linux-foundation.org>
>> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>> ---
>>  mm/slub.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/mm/slub.c b/mm/slub.c
>> index b364844..9984165 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -1084,7 +1084,7 @@ static inline struct page *alloc_slab_page(gfp_t flags, int node,
>>       if (node == -1)
>>               return alloc_pages(flags, order);
>>       else
>> -             return alloc_pages_node(node, flags, order);
>> +             return alloc_pages_exact_node(node, flags, order);
>>  }
>>
>>  static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
>
> Slub changes need to go through its maintainer, Pekka Enberg
> <penberg@cs.helsinki.fi>.

Thanks, David. It was by mistake.

Pekka.

This changlog is bad.
I will change it with following as when I send v2.

"alloc_slab_page always checks nid == -1, so alloc_page_node can't be
called with -1.
 It means node's validity check in alloc_pages_node is unnecessary.
 So we can use alloc_pages_exact_node instead of alloc_pages_node.
 It could avoid comparison and branch as 6484eb3e2a81807722 tried."

Thanks.


-- 
Kind regards,
Minchan Kim
