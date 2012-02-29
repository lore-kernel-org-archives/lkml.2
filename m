Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488Ab2B2ABg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 19:01:36 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54844 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab2B2ABf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 19:01:35 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 29 Feb 2012 09:00:05 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] kernel: cgroup: push rcu read locking from
 css_is_ancestor() to callsite
Message-Id: <20120229090005.1ef4cdb2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1330438489-21909-1-git-send-email-hannes@cmpxchg.org>
References: <1330438489-21909-1-git-send-email-hannes@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Feb 2012 15:14:48 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> Library functions should not grab locks when the callsites can do it,
> even if the lock nests like the rcu read-side lock does.
> 
> Push the rcu_read_lock() from css_is_ancestor() to its single user,
> mem_cgroup_same_or_subtree() in preparation for another user that may
> already hold the rcu read-side lock.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


