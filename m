Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760340Ab1D0X7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 19:59:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55433 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355Ab1D0X7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 19:59:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=coDzWRruJg0A5o+jDpVURrXHdMSu7Htv+Nh0GBPXCKjkwZLjTVFR4YPpc2QIsvPYAg
         F9L0ia3P9+s8Aiyw4n/Dw/qgDUOlnWXz053/sPqlLlQI254koCAE6qsJd1C78xikZI9W
         VUy71HMAcJGCIC49giigp8O70EOx7deDbykDA=
MIME-Version: 1.0
In-Reply-To: <4DB8AAE3.20806@redhat.com>
References: <cover.1303833415.git.minchan.kim@gmail.com>
	<51e7412097fa62f86656c77c1934e3eb96d5eef6.1303833417.git.minchan.kim@gmail.com>
	<4DB8AAE3.20806@redhat.com>
Date: Thu, 28 Apr 2011 08:59:17 +0900
Message-ID: <BANLkTimPAU-uc=FCV9Z-LKmQm-GGusHfiw@mail.gmail.com>
Subject: Re: [RFC 6/8] In order putback lru core
From: Minchan Kim <minchan.kim@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rik,

On Thu, Apr 28, 2011 at 8:46 AM, Rik van Riel <riel@redhat.com> wrote:
> On 04/26/2011 12:25 PM, Minchan Kim wrote:
>
>> But this approach has a problem on contiguous pages.
>> In this case, my idea can not work since friend pages are isolated, too.
>> It means prev_page->next == next_page always is false and both pages are
>> not
>> LRU any more at that time. It's pointed out by Rik at LSF/MM summit.
>> So for solving the problem, I can change the idea.
>> I think we don't need both friend(prev, next) pages relation but
>> just consider either prev or next page that it is still same LRU.
>
>> Any comment?
>
> If the friend pages are isolated too, then your condition
> "either prev or next page that it is still same LRU" is
> likely to be false, no?

H - P1 - P2 - P3 - P4 - P5 - P6 - P7 - P8 - P9 - P10 - T

assume : we isolate pages P3~P7 and we consider only next pointer.

H - P1 - P2 - P8 - P9 - P10 - T

If we start to putback P7 as starting point, next P8 is valid so,

H - P1 - P2 - P7 - P8 - P9 - P10 - T
Then, if we consider P6, next P7 is valid, too. So,

H - P1 - P2 - P6 - P7 - P8 - P9 - P10 - T

continue until P3.


-- 
Kind regards,
Minchan Kim
