Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab1HHWau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 18:30:50 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:55543 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab1HHWat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 18:30:49 -0400
MIME-Version: 1.0
In-Reply-To: <20110808122255.GC14803@tiehlicka.suse.cz>
References: <20110727111002.9985.94938.stgit@localhost6>
	<20110808110207.30777.30800.stgit@localhost6>
	<20110808122255.GC14803@tiehlicka.suse.cz>
Date: Tue, 9 Aug 2011 07:30:48 +0900
Message-ID: <CAEwNFnD4GH0nr+7ngPBj2uG4jnKb20g3_wLO6HyvHj+vzt+Jzg@mail.gmail.com>
Subject: Re: [PATCH v2] vmscan: reverse lru scanning order
From: Minchan Kim <minchan.kim@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 8, 2011 at 9:22 PM, Michal Hocko <mhocko@suse.cz> wrote:
> On Mon 08-08-11 15:02:07, Konstantin Khlebnikov wrote:
>> LRU scanning order was accidentially changed in commit v2.6.27-5584-gb69408e:
>> "vmscan: Use an indexed array for LRU variables".
>> Before that commit reclaimer always scan active lists first.
>>
>> This patch just reverse it back.
>
> I am still not sure I see why the ordering matters that much.
> One thing that might matter is that shrink_list moves some pages from
> active to inactive list if inactive is low so it makes sense to try to
> shrink active before inactive. It would be a problem if inactive was
> almost empty. Then we would just waste time by shrinking inactive first.
> I am not sure how real problem is that, though.
>
> Whatever is the reason, I think it should be documented in the
> changelog.
> The change makes sense to me.
>

Absolutely agree with Michal.
I think the patch itself doesn't have a problem and even it is does make sense.
But we need changelog why we need it.
I don't want to overwrite recent git log without any issue.
It annoys us when we find a bug by git-blame. ;-)
-- 
Kind regards,
Minchan Kim
