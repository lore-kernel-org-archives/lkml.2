Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912Ab2GICaW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 22:30:22 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41786 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab2GICaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 22:30:21 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FFA41A9.2030806@jp.fujitsu.com>
Date: Mon, 09 Jul 2012 11:27:53 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 01/11] mm: memcg: fix compaction/migration failing due
 to memcg limits
References: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org> <1341449103-1986-2-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1341449103-1986-2-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/07/05 9:44), Johannes Weiner wrote:
> Compaction (and page migration in general) can currently be hindered
> through pages being owned by memory cgroups that are at their limits
> and unreclaimable.
> 
> The reason is that the replacement page is being charged against the
> limit while the page being replaced is also still charged.  But this
> seems unnecessary, given that only one of the two pages will still be
> in use after migration finishes.
> 
> This patch changes the memcg migration sequence so that the
> replacement page is not charged.  Whatever page is still in use after
> successful or failed migration gets to keep the charge of the page
> that was going to be replaced.
> 
> Reported-by: David Rientjes <rientjes@google.com>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

