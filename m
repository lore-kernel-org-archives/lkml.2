Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603Ab1ACWdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 17:33:16 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59890 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab1ACWdP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 17:33:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rWFgsS5ipE2ONUgycvdVKXrb7hs/oWa/wOSufGltWw1/NppmMACckq+nXabYsEeMmj
         XkPUCxB74+rHMyZvEQYD6pa4/ytGsGySmVZk6wPmkAymx1/TKwMYgQDCtymJJBxPEP/c
         Adrpc7tzclx2jF8U2F5p0H9YGdvfFTsuBBpLQ=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1101031400550.10636@chino.kir.corp.google.com>
References: <1294072249-2916-1-git-send-email-minchan.kim@gmail.com>
	<alpine.DEB.2.00.1101031400550.10636@chino.kir.corp.google.com>
Date: Tue, 4 Jan 2011 07:33:15 +0900
Message-ID: <AANLkTinb+W-hByy18tko8NFtYYzQonABps0gi7+7kQ5R@mail.gmail.com>
Subject: Re: [PATCH] writeback: avoid unnecessary determine_dirtyable_memory call
From: Minchan Kim <minchan.kim@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 4, 2011 at 7:03 AM, David Rientjes <rientjes@google.com> wrote:
> On Tue, 4 Jan 2011, Minchan Kim wrote:
>
>> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
>> index fc93802..c340536 100644
>> --- a/mm/page-writeback.c
>> +++ b/mm/page-writeback.c
>> @@ -390,9 +390,12 @@ void global_dirty_limits(unsigned long *pbackground, unsigned long *pdirty)
>>  {
>>       unsigned long background;
>>       unsigned long dirty;
>> -     unsigned long available_memory = determine_dirtyable_memory();
>> +     unsigned long available_memory;
>
> You need unsigned long uninitialized_var(available_memory) to avoid the
> warning.

Yes. It's my fault. Andrew already fixed it.
Thanks, David.


-- 
Kind regards,
Minchan Kim
