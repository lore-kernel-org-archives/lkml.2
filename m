Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab0LHWZV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 17:25:21 -0500
Received: from mail-iw0-f172.google.com ([209.85.214.172]:47483 "EHLO
	mail-iw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab0LHWZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 17:25:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=VNxyED5qEIFnNYb205WSOxx/0AuZYby2iOU1dNzoiJEsRvKU4aaqP0/KmFXUgeiBfO
         5wftXE0WTlJ6k+vwPIN6X2u9cjLwHamNJqyyVei9GqXF3vdVnx8jdrUE+cNR8qAdAf5q
         k0UGrGpa67XEW5ioJrbCJsw9DmNGkESajy1xs=
MIME-Version: 1.0
In-Reply-To: <20101208164327.GL2356@cmpxchg.org>
References: <1291734086-1405-1-git-send-email-minchan.kim@gmail.com>
	<20101208164327.GL2356@cmpxchg.org>
Date: Thu, 9 Dec 2010 07:25:18 +0900
Message-ID: <AANLkTi=93QLYaO9gktVPxu_4gD9sV1tUPL9duj7RqL0X@mail.gmail.com>
Subject: Re: [PATCH] compaction: Remove mem_cgroup_del_lru
From: Minchan Kim <minchan.kim@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 9, 2010 at 1:43 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> On Wed, Dec 08, 2010 at 12:01:26AM +0900, Minchan Kim wrote:
>> del_page_from_lru_list alreay called mem_cgroup_del_lru.
>> So we need to call it again. It makes wrong stat of memcg and
>> even happen VM_BUG_ON hit.
>>
>> Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
>> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> Cc: Mel Gorman <mel@csn.ul.ie>
>> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>
> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
>
> But regarding the severity of this: shouldn't the second deletion
> attempt be caught by the TestClearPageCgroupAcctLRU() early in
> mem_cgroup_del_lru_list()?
>

Right, I missed that.
Andrew, I will resend modified description.

Thanks for careful review again, Hannes.

-- 
Kind regards,
Minchan Kim
