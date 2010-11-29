Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab0K2Eaa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 23:30:30 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57312 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763Ab0K2Ea3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 23:30:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=mecIAbvmeqeyi7T7yeSYDTI7Uh8DmucOC/BiVviCIWjCQa3w7NB+lN+Hd7TMdhyUYW
         vBpUr5d/YyHBvkzgCtNQ9UtFL8NxkIRq0hm3iNXC88YcfvDq4sobumrLg3Mi2Gan8LmH
         iDYCMcBD1fY1h49+59lGVbeqoT5EQM9/qiYnI=
MIME-Version: 1.0
In-Reply-To: <4CF32BD5.8050006@redhat.com>
References: <7b50614882592047dfd96f6ca2bb2d0baa8f5367.1290956059.git.minchan.kim@gmail.com>
	<48315b5fe54efa08982aa7df77e8abe793889e3a.1290956059.git.minchan.kim@gmail.com>
	<4CF32BD5.8050006@redhat.com>
Date: Mon, 29 Nov 2010 13:30:28 +0900
Message-ID: <AANLkTinr0UtYzptXzZXB4hu_XvF8BzY86GiQE=b+zsj1@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] Prevent promotion of page in madvise_dontneed
From: Minchan Kim <minchan.kim@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gamari <bgamari.foss@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>,
        Mel Gorman <mel@csn.ul.ie>, Wu Fengguang <fengguang.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 1:28 PM, Rik van Riel <riel@redhat.com> wrote:
> On 11/28/2010 10:02 AM, Minchan Kim wrote:
>>
>> Now zap_pte_range alwayas promotes pages which are pte_young&&
>> !VM_SequentialReadHint(vma). But in case of calling MADV_DONTNEED,
>> it's unnecessary since the page wouldn't use any more.
>>
>> If the page is sharred by other processes and it's real working set
>
> This line seems to be superfluous, I don't see any special
> treatment for this case in the code.

I should remove the lines.
It's my fault.

>
>> Signed-off-by: Minchan Kim<minchan.kim@gmail.com>
>> Cc: Rik van Riel<riel@redhat.com>
>> Cc: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
>> Cc: Johannes Weiner<hannes@cmpxchg.org>
>> Cc: Nick Piggin<npiggin@kernel.dk>
>> Cc: Mel Gorman<mel@csn.ul.ie>
>> Cc: Wu Fengguang<fengguang.wu@intel.com>
>
> The patch itself looks good to me.
>
> Acked-by: Rik van Riel <riel@redhat.com>

Thanks, Rik.
-- 
Kind regards,
Minchan Kim
