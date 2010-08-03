Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab0HCEJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 00:09:20 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40934 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab0HCEJS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 00:09:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=M5p85mWYErNxfPSfEn3HZtP1z9AvxM12CEOuCRvHOLf5d0mhl2QNR09zB4T2+2wOqB
         b5c6fUs6D40AzOoXuCEosMg/v60XewEKzbF145aPoo9dH15VFRul5mH6yLsCPREkalhf
         AtxBVJuZy2wl+P/nLCHKt3f9UBd7vOcjOp7y0=
MIME-Version: 1.0
In-Reply-To: <20100803033108.GA23117@arachsys.com>
References: <20100802124734.GI2486@arachsys.com>
	<AANLkTinnWQA-K6r_+Y+giEC9zs-MbY6GFs8dWadSq0kh@mail.gmail.com>
	<20100803033108.GA23117@arachsys.com>
Date: Tue, 3 Aug 2010 13:09:18 +0900
Message-ID: <AANLkTinjmZOOaq7FgwJOZ=UNGS8x8KtQWZg6nv7fqJMe@mail.gmail.com>
Subject: Re: Over-eager swapping
From: Minchan Kim <minchan.kim@gmail.com>
To: Chris Webb <chris@arachsys.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Wu Fengguang <fengguang.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 3, 2010 at 12:31 PM, Chris Webb <chris@arachsys.com> wrote:
> Minchan Kim <minchan.kim@gmail.com> writes:
>
>> Another possibility is _zone_reclaim_ in NUMA.
>> Your working set has many anonymous page.
>>
>> The zone_reclaim set priority to ZONE_RECLAIM_PRIORITY.
>> It can make reclaim mode to lumpy so it can page out anon pages.
>>
>> Could you show me /proc/sys/vm/[zone_reclaim_mode/min_unmapped_ratio] ?
>
> Sure, no problem. On the machine with the /proc/meminfo I showed earlier,
> these are
>
>  # cat /proc/sys/vm/zone_reclaim_mode
>  0
>  # cat /proc/sys/vm/min_unmapped_ratio
>  1

if zone_reclaim_mode is zero, it doesn't swap out anon_pages.

1) How does VM reclaim anonymous pages even though vm_swappiness ==
zero and has big page cache?
2) I doubt file pages of your system is fulled by Buffers while Cached
is almost 10M.
Why is it remained although anon pages is swapped out and cached page
are reclaimed?

Hmm. I have no idea. :(

-- 
Kind regards,
Minchan Kim
