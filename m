Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab1FBN1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 09:27:18 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65408 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587Ab1FBN1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 09:27:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=IATmT4PhttxEUjSg1JbKSQza0KLBFZ16aNX9tPsyHqknD5sLe8WNpyMoceHkJCj/H9
         xrTak5tfAeLmMnl27Y++HHNCPEL58eQw6RwO/xAfF+VyjFJszjTfWHAEdYt2m5CStKO3
         kSlkrU8N8F7MTLxpJf1h3a1Mkglr4Ntab5DFc=
MIME-Version: 1.0
In-Reply-To: <1306909519-7286-8-git-send-email-hannes@cmpxchg.org>
References: <1306909519-7286-1-git-send-email-hannes@cmpxchg.org>
	<1306909519-7286-8-git-send-email-hannes@cmpxchg.org>
Date: Thu, 2 Jun 2011 22:27:15 +0900
Message-ID: <BANLkTi=cHVZP+fZwHNM3cXVyw53kJ2HQmw@mail.gmail.com>
Subject: Re: [patch 7/8] vmscan: memcg-aware unevictable page rescue scanner
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Ying Han <yinghan@google.com>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/1 Johannes Weiner <hannes@cmpxchg.org>:
> Once the per-memcg lru lists are exclusive, the unevictable page
> rescue scanner can no longer work on the global zone lru lists.
>
> This converts it to go through all memcgs and scan their respective
> unevictable lists instead.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Hm, isn't it better to have only one GLOBAL LRU for unevictable pages ?
memcg only needs counter for unevictable pages and LRU is not necessary
to be per memcg because we don't reclaim it...

Thanks,
-Kame
