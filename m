Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab0LAAt7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 19:49:59 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60501 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab0LAAt6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 19:49:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XJLpTxv+vPPOE94xbJcj0Pl44b0XCwK/uurrsWxj+f1P8OlPyMXA+QW4+OzBFaDFI4
         p1neaq8zl3tkFQ/sPCoOR9UahrZCwGH7mjlwPRUSViTzFOQ/g7D6gwVNRfljNxsFs7Uy
         JnVW6EaWg+ttXDjnnLvhraslvErLyn4tr2na8=
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1011301025010.7450@tigran.mtv.corp.google.com>
References: <cover.1291043273.git.minchan.kim@gmail.com>
	<a0f2905bb64ce33909d7dd74146bfea826fec21a.1291043274.git.minchan.kim@gmail.com>
	<alpine.LSU.2.00.1011301025010.7450@tigran.mtv.corp.google.com>
Date: Wed, 1 Dec 2010 09:49:17 +0900
Message-ID: <AANLkTin-BoUQNw+NfQeku0=K8mK0trt5=J9tMXNvrs9i@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] Prevent activation of page in madvise_dontneed
From: Minchan Kim <minchan.kim@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gamari <bgamari.foss@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>,
        Mel Gorman <mel@csn.ul.ie>, Wu Fengguang <fengguang.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh,

On Wed, Dec 1, 2010 at 3:34 AM, Hugh Dickins <hughd@google.com> wrote:
> On Tue, 30 Nov 2010, Minchan Kim wrote:
>
>> Now zap_pte_range alwayas activates pages which are pte_young &&
>> !VM_SequentialReadHint(vma). But in case of calling MADV_DONTNEED,
>> it's unnecessary since the page wouldn't use any more.
>>
>> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>> Acked-by: Rik van Riel <riel@redhat.com>
>> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>> Cc: Nick Piggin <npiggin@kernel.dk>
>> Cc: Mel Gorman <mel@csn.ul.ie>
>> Cc: Wu Fengguang <fengguang.wu@intel.com>
>>
>> Changelog since v2:
>>  - remove unnecessary description
>> Changelog since v1:
>>  - change word from promote to activate
>>  - add activate argument to zap_pte_range and family function
>>
>> ---
>>  include/linux/mm.h |    4 ++--
>>  mm/madvise.c       |    4 ++--
>>  mm/memory.c        |   38 +++++++++++++++++++++++---------------
>>  mm/mmap.c          |    4 ++--
>>  4 files changed, 29 insertions(+), 21 deletions(-)
>
> Everyone else seems pretty happy with this, and I've not checked
> at all whether it achieves your purpose; but personally I'd much
> prefer a smaller patch which adds your "activate" or "ignore_references"
> flag to struct zap_details, instead of passing this exceptional arg
> down lots of levels.  That's precisely the purpose of zap_details,
> to gather together a few things that aren't needed in the common case
> (though I admit the NULL details defaulting may be ugly).

Before I sent RFC, I tried it and suffered from NULL detail as you said.
But it's valuable to look on it, again.
Since other guys don't opposed this patch's goal, I will have a time
for unifying it into zap_details.

Thanks, Hugh.


> Hugh
>



-- 
Kind regards,
Minchan Kim
