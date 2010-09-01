Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab0IABzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 21:55:43 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49915 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab0IABzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 21:55:41 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [BUGFIX][PATCH] vmscan: don't use return value trick when oom_killer_disabled
Cc: kosaki.motohiro@jp.fujitsu.com, Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "M. Vefa Bicakci" <bicave@superonline.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <AANLkTikXfvEVXEyw_5_eJs2v-3J6Xhd=CT9X-0D+GMCA@mail.gmail.com>
References: <20100901092430.9741.A69D9226@jp.fujitsu.com> <AANLkTikXfvEVXEyw_5_eJs2v-3J6Xhd=CT9X-0D+GMCA@mail.gmail.com>
Message-Id: <20100901105232.974F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  1 Sep 2010 10:55:38 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Thank you for good commenting!


> I don't like use oom_killer_disabled directly.
> That's because we have wrapper inline functions to handle the
> variable(ex, oom_killer_[disable/enable]).
> It means we are reluctant to use the global variable directly.
> So should we make new function as is_oom_killer_disable?
> 
> I think NO.
> 
> As I read your description, this problem is related to only hibernation.
> Since hibernation freezes all processes(include kswapd), this problem
> happens. Of course, now oom_killer_disabled is used by only
> hibernation. But it can be used others in future(Off-topic : I don't
> want it). Others can use it without freezing processes. Then kswapd
> can set zone->all_unreclaimable and the problem can't happen.
> 
> So I want to use sc->hibernation_mode which is already used
> do_try_to_free_pages instead of oom_killer_disabled.

Unfortunatelly, It's impossible. shrink_all_memory() turn on
sc->hibernation_mode. but other hibernation caller merely call
alloc_pages(). so we don't have any hint.



