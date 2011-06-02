Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab1FBVCi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 17:02:38 -0400
Received: from smtp-out.google.com ([74.125.121.67]:42792 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960Ab1FBVCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 17:02:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=evVUXajWdSl90Vfshd/+hqx2IL9ymVdwVUtFXHyeGa7KeRZ9Hkf2M1Ig6o+z69RozN
         AJUPjilqfnre4Wm7GBjw==
MIME-Version: 1.0
In-Reply-To: <BANLkTi=cHVZP+fZwHNM3cXVyw53kJ2HQmw@mail.gmail.com>
References: <1306909519-7286-1-git-send-email-hannes@cmpxchg.org>
	<1306909519-7286-8-git-send-email-hannes@cmpxchg.org>
	<BANLkTi=cHVZP+fZwHNM3cXVyw53kJ2HQmw@mail.gmail.com>
Date: Thu, 2 Jun 2011 14:02:31 -0700
Message-ID: <BANLkTimvuwLYwzRT-6k_oVwKBzBEo500s-rXETerTskYHfontQ@mail.gmail.com>
Subject: Re: [patch 7/8] vmscan: memcg-aware unevictable page rescue scanner
From: Ying Han <yinghan@google.com>
To: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
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
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 2, 2011 at 6:27 AM, Hiroyuki Kamezawa
<kamezawa.hiroyuki@gmail.com> wrote:
> 2011/6/1 Johannes Weiner <hannes@cmpxchg.org>:
>> Once the per-memcg lru lists are exclusive, the unevictable page
>> rescue scanner can no longer work on the global zone lru lists.
>>
>> This converts it to go through all memcgs and scan their respective
>> unevictable lists instead.
>>
>> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
>
> Hm, isn't it better to have only one GLOBAL LRU for unevictable pages ?
> memcg only needs counter for unevictable pages and LRU is not necessary
> to be per memcg because we don't reclaim it...

Hmm. Are we suggesting to keep one un-evictable LRU list for all
memcgs? So we will have
exclusive lru only for file and anon. If so, we are not done to make
all the lru list being exclusive
which is critical later to improve the zone->lru_lock contention
across the memcgs

Sorry If i misinterpret the suggestion here

--Ying


> Thanks,
> -Kame
>
