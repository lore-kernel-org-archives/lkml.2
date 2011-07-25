Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab1GYBZz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 21:25:55 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55788 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab1GYBZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 21:25:54 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 25 Jul 2011 10:18:40 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, Balbir Singh <bsingharora@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] memcg: get rid of percpu_charge_mutex lock
Message-Id: <20110725101840.f2796524.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <a9244082ba28c4c2e4a6997311d5493bdaa117e9.1311338634.git.mhocko@suse.cz>
References: <cover.1311338634.git.mhocko@suse.cz>
	<a9244082ba28c4c2e4a6997311d5493bdaa117e9.1311338634.git.mhocko@suse.cz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jul 2011 13:20:25 +0200
Michal Hocko <mhocko@suse.cz> wrote:

> percpu_charge_mutex protects from multiple simultaneous per-cpu charge
> caches draining because we might end up having too many work items.
> At least this was the case until 26fe6168 (memcg: fix percpu cached
> charge draining frequency) when we introduced a more targeted draining
> for async mode.
> Now that also sync draining is targeted we can safely remove mutex
> because we will not send more work than the current number of CPUs.
> FLUSHING_CACHED_CHARGE protects from sending the same work multiple
> times and stock->nr_pages == 0 protects from pointless sending a work
> if there is obviously nothing to be done. This is of course racy but we
> can live with it as the race window is really small (we would have to
> see FLUSHING_CACHED_CHARGE cleared while nr_pages would be still
> non-zero).
> The only remaining place where we can race is synchronous mode when we
> rely on FLUSHING_CACHED_CHARGE test which might have been set by other
> drainer on the same group but we should wait in that case as well.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


