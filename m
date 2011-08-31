Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750Ab1HaS2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 14:28:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794Ab1HaS2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 14:28:13 -0400
Message-ID: <4E5E7D16.4070805@redhat.com>
Date: Wed, 31 Aug 2011 14:27:34 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Johannes Weiner <jweiner@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <bsingharora@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] memcg: skip scanning active lists based on individual
 size
References: <20110831090850.GA27345@redhat.com>
In-Reply-To: <20110831090850.GA27345@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2011 05:08 AM, Johannes Weiner wrote:
> Reclaim decides to skip scanning an active list when the corresponding
> inactive list is above a certain size in comparison to leave the
> assumed working set alone while there are still enough reclaim
> candidates around.
>
> The memcg implementation of comparing those lists instead reports
> whether the whole memcg is low on the requested type of inactive
> pages, considering all nodes and zones.
>
> This can lead to an oversized active list not being scanned because of
> the state of the other lists in the memcg, as well as an active list
> being scanned while its corresponding inactive list has enough pages.
>
> Not only is this wrong, it's also a scalability hazard, because the
> global memory state over all nodes and zones has to be gathered for
> each memcg and zone scanned.
>
> Make these calculations purely based on the size of the two LRU lists
> that are actually affected by the outcome of the decision.
>
> Signed-off-by: Johannes Weiner<jweiner@redhat.com>
> Cc: Rik van Riel<riel@redhat.com>
> Cc: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> Cc: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Daisuke Nishimura<nishimura@mxp.nes.nec.co.jp>
> Cc: Balbir Singh<bsingharora@gmail.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

