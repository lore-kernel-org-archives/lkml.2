Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777Ab0DACjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 22:39:44 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56943 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab0DACjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 22:39:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=X4SNbfuJpAu0wCbCpsmp+GP7xoSTuSkM+oJMHrvWhn9eUUt41t5fvetqE7xmbhxdu9
         94PLzAuywG20Doo48erUbqkFkWUacLEBY3uu0mp/7kcPdAvPLZb9rCmv8pI4/rCEFac1
         x5kqCyjxUA0roWL4dbF8NOGEjx+Q7c+zO/Ri0=
MIME-Version: 1.0
In-Reply-To: <20100401085718.d091eda6.kamezawa.hiroyu@jp.fujitsu.com>
References: <1269940489-5776-1-git-send-email-mel@csn.ul.ie>
	 <1269940489-5776-15-git-send-email-mel@csn.ul.ie>
	 <20100331142623.62ac9175.kamezawa.hiroyu@jp.fujitsu.com>
	 <20100331112730.GB27389@csn.ul.ie>
	 <20100401085718.d091eda6.kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 1 Apr 2010 11:39:42 +0900
Message-ID: <q2r28c262361003311939zbfa8e980ifa9c58cb9d62dc83@mail.gmail.com>
Subject: Re: [PATCH 14/14] mm,migration: Allow the migration of PageSwapCache 
	pages
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 1, 2010 at 8:57 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com>
>
> rmap_walk_anon() is called against unmapped pages.
> Then, !page_mapped() is always true. So, the behavior will not be different from
> the last one.
>

rmap_walk_anon can be also called in case of failing try_to_unmap.
Then, In unmap_and_move, page_mapped is true and
remove_migration_ptes can be called.

But I am not sure this Mel's patch about this part is really needed.

> Thanks,
> -Kame
>
>



-- 
Kind regards,
Minchan Kim
