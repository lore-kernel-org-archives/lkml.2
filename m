Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab1FBXPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 19:15:42 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47128 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384Ab1FBXPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 19:15:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ESICTkLjp8+z/uAdDcEWpgRwqC14SYqtqDwi735A0fTDQnVptbom7Ly1AtsMMZSebz
         InIXcpxPpgdFjVbolcLJc1muVdjDpM73GRrdybazBl50dnQuRX3EAYIouVw9vtAHwBIH
         syMWIlsuh6yweZXjct1lZCazJFIRVjzDR6ORs=
MIME-Version: 1.0
In-Reply-To: <20110602221906.GA4554@cmpxchg.org>
References: <1306909519-7286-1-git-send-email-hannes@cmpxchg.org>
	<1306909519-7286-8-git-send-email-hannes@cmpxchg.org>
	<BANLkTi=cHVZP+fZwHNM3cXVyw53kJ2HQmw@mail.gmail.com>
	<BANLkTimvuwLYwzRT-6k_oVwKBzBEo500s-rXETerTskYHfontQ@mail.gmail.com>
	<BANLkTik1X72Re_QKM4iCaPbxCx2kcnfH_w@mail.gmail.com>
	<20110602221906.GA4554@cmpxchg.org>
Date: Fri, 3 Jun 2011 08:15:39 +0900
Message-ID: <BANLkTik41pnhodu0ptvNcYBqRv_mp64_GA@mail.gmail.com>
Subject: Re: [patch 7/8] vmscan: memcg-aware unevictable page rescue scanner
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ying Han <yinghan@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011年6月3日金曜日 Johannes Weiner hannes@cmpxchg.org:
> On Fri, Jun 03, 2011 at 07:01:34AM +0900, Hiroyuki Kamezawa wrote:
>> 2011/6/3 Ying Han <yinghan@google.com>:
>> > On Thu, Jun 2, 2011 at 6:27 AM, Hiroyuki Kamezawa
>> > <kamezawa.hiroyuki@gmail.com> wrote:
>> >> 2011/6/1 Johannes Weiner <hannes@cmpxchg.org>:
>> >>> Once the per-memcg lru lists are exclusive, the unevictable page
>> >>> rescue scanner can no longer work on the global zone lru lists.
>> >>>
>> >>> This converts it to go through all memcgs and scan their respective
>> >>> unevictable lists instead.
>> >>>
>> >>> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
>> >>
>> >> Hm, isn't it better to have only one GLOBAL LRU for unevictable pages ?
>> >> memcg only needs counter for unevictable pages and LRU is not necessary
>> >> to be per memcg because we don't reclaim it...
>> >
>> > Hmm. Are we suggesting to keep one un-evictable LRU list for all
>> > memcgs? So we will have
>> > exclusive lru only for file and anon. If so, we are not done to make
>> > all the lru list being exclusive
>> > which is critical later to improve the zone->lru_lock contention
>> > across the memcgs
>> >
>> considering lrulock, yes, maybe you're right.
>
> That's one of the complications.
>
>> > Sorry If i misinterpret the suggestion here
>> >
>>
>> My concern is I don't know for what purpose this function is used ..
>
> I am not sure how it's supposed to be used, either.  But it's
> documented to be a 'really big hammer' and it's kicked off from
> userspace.  So I suppose having the thing go through all memcgs bears
> a low risk of being a problem.  My suggestion is we go that way until
> someone complains.

Ok. Please go with memcg local unevictable lru.

-kame
