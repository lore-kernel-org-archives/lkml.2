Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759270Ab0KPDnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 22:43:21 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56527 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083Ab0KPDnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 22:43:20 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 16 Nov 2010 12:37:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>,
        Andrea Righi <arighi@develer.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/4] memcg: use native word to represent dirtyable pages
Message-Id: <20101116123728.295d3095.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101107220353.115646194@cmpxchg.org>
References: <20101107215030.007259800@cmpxchg.org>
	<20101107220353.115646194@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  7 Nov 2010 23:14:36 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> The memory cgroup dirty info calculation currently uses a signed
> 64-bit type to represent the amount of dirtyable memory in pages.
> 
> This can instead be changed to an unsigned word, which will allow the
> formula to function correctly with up to 160G of LRU pages on a 32-bit
> system, assuming 4k pages.  That should be plenty even when taking
> racy folding of the per-cpu counters into account.
> 
> This fixes a compilation error on 32-bit systems as this code tries to
> do 64-bit division.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Reported-by: Dave Young <hidave.darkstar@gmail.com>


Thank you.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

I couldn't read email because of vacation.

