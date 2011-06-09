Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424Ab1FIBQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 21:16:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283Ab1FIBQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 21:16:08 -0400
Message-ID: <4DF01EC2.8010105@redhat.com>
Date: Wed, 08 Jun 2011 21:15:46 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
CC: Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Ying Han <yinghan@google.com>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 0/8] mm: memcg naturalization -rc2
References: <1306909519-7286-1-git-send-email-hannes@cmpxchg.org>	<BANLkTikgqSsg5+49295h7kdZ=sQpZLs4kw@mail.gmail.com>	<20110602073335.GA20630@cmpxchg.org>	<BANLkTikztP6RoyBgMqUHgrzJFLZrHMCs=Q@mail.gmail.com>	<20110602100007.GB20725@cmpxchg.org> <BANLkTi=xvunhqpXFJ=wJFkCuu+7Czh4nZw@mail.gmail.com>
In-Reply-To: <BANLkTi=xvunhqpXFJ=wJFkCuu+7Czh4nZw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2011 08:59 AM, Hiroyuki Kamezawa wrote:

> It seems your current series is a mixture of 2 works as
> "re-desgin of softlimit" and "removal of global LRU".
> I don't understand why you need 2 works at once.

That seems pretty obvious.

With the global LRU gone, the only way to reclaim
pages in a global fashion (because the zone is low
on memory), is to reclaim from all the memcgs in
the zone.

Doing that requires that the softlimit stuff is
changed, and not only the biggest offender is
attacked.

-- 
All rights reversed
