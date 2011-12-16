Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760905Ab1LPW2W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 17:28:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57337 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab1LPW2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 17:28:15 -0500
Date: Fri, 16 Dec 2011 14:28:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Ying Han <yinghan@google.com>
Subject: Re: [PATCH 1/4] memcg: simplify page cache charging.
Message-Id: <20111216142814.dbb77209.akpm@linux-foundation.org>
In-Reply-To: <20111214164922.05fb4afe.kamezawa.hiroyu@jp.fujitsu.com>
References: <20111214164734.4d7d6d97.kamezawa.hiroyu@jp.fujitsu.com>
	<20111214164922.05fb4afe.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Dec 2011 16:49:22 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> Because of commit ef6a3c6311, FUSE uses replace_page_cache() instead
> of add_to_page_cache(). Then, mem_cgroup_cache_charge() is not
> called against FUSE's pages from splice.

Speaking of ef6a3c6311 ("mm: add replace_page_cache_page() function"),
may I pathetically remind people that it's rather inefficient?

http://lkml.indiana.edu/hypermail/linux/kernel/1109.1/00375.html
