Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab0DNAdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 20:33:25 -0400
Received: from mail-yw0-f194.google.com ([209.85.211.194]:54261 "EHLO
	mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab0DNAdX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 20:33:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WSc8p3BBYFW8ObWxEnPP37CzxNuSHIFrOocvJMWldWL8BMbUoVzflgLllyAkU8UcbX
         PJeMHzk5jO1Ymo6bqOOnRWptgekdj0bRwlo8rkGyW8RNSK65qd84zEp7VgF7mS0coUxc
         ZFsj2/oWjFxGVY6V7kJyXBq8k3XdtQjUAsQxI=
MIME-Version: 1.0
In-Reply-To: <20100414092209.4327e545.kamezawa.hiroyu@jp.fujitsu.com>
References: <9918f566ab0259356cded31fd1dd80da6cae0c2b.1271171877.git.minchan.kim@gmail.com>
	 <2cb77846a9523201588c5dbf94b23d6ea737ce65.1271171877.git.minchan.kim@gmail.com>
	 <20100414092209.4327e545.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 14 Apr 2010 09:33:22 +0900
Message-ID: <j2p28c262361004131733m98351a5xf994ead1f21289ef@mail.gmail.com>
Subject: Re: [PATCH 5/6] change alloc function in __vmalloc_area_node
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Bob Liu <lliubbo@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Nick Piggin <npiggin@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 9:22 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Wed, 14 Apr 2010 00:25:02 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
>
>> __vmalloc_area_node never pass -1 to alloc_pages_node.
>> It means node's validity check is unnecessary.
>> So we can use alloc_pages_exact_node instead of alloc_pages_node.
>> It could avoid comparison and branch as 6484eb3e2a81807722 tried.
>>
>> Cc: Nick Piggin <npiggin@suse.de>
>> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> But, in another thinking,
>
> -       if (node < 0)
> -               page = alloc_page(gfp_mask);
>
> may be better ;)

I thought it.
but alloc_page is different function with alloc_pages_node in NUMA.
It calls alloc_pages_current.


-- 
Kind regards,
Minchan Kim
