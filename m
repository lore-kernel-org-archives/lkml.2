Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980Ab1K2Xny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 18:43:54 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51027 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756278Ab1K2Xnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 18:43:53 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 30 Nov 2011 08:42:11 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 5/7] mm: page_cgroup: check page_cgroup arrays in
 lookup_page_cgroup() only when necessary
Message-Id: <20111130084211.15fdefbf.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1322563925-1667-6-git-send-email-hannes@cmpxchg.org>
References: <1322563925-1667-1-git-send-email-hannes@cmpxchg.org>
	<1322563925-1667-6-git-send-email-hannes@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Nov 2011 11:52:03 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> lookup_page_cgroup() is usually used only against pages that are used
> in userspace.
> 
> The exception is the CONFIG_DEBUG_VM-only memcg check from the page
> allocator: it can run on pages without page_cgroup descriptors
> allocated when the pages are fed into the page allocator for the first
> time during boot or memory hotplug.
> 
> Include the array check only when CONFIG_DEBUG_VM is set and save the
> unnecessary check in production kernels.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


