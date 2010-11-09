Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab0KIJKt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 04:10:49 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:43774 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337Ab0KIJKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 04:10:46 -0500
Date: Tue, 9 Nov 2010 10:10:06 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: avoid "free" overflow in
 memcg_hierarchical_free_pages()
Message-ID: <20101109091006.GR23393@cmpxchg.org>
References: <1289292853-7022-1-git-send-email-gthelen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289292853-7022-1-git-send-email-gthelen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 12:54:13AM -0800, Greg Thelen wrote:
> memcg limit and usage values are stored in res_counter, as 64-bit
> numbers, even on 32-bit machines.  The "free" variable in
> memcg_hierarchical_free_pages() stores the difference between two
> 64-bit numbers (limit - current_usage), and thus should be stored
> in a 64-bit local rather than a machine defined unsigned long.

It is converted to pages before the assignment, but even that might
overflow on 32-bit if the difference is sufficiently large (> 1<<44).

> Reported-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> Signed-off-by: Greg Thelen <gthelen@google.com>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
