Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759276Ab0KPDou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 22:44:50 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56613 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756134Ab0KPDot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 22:44:49 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 16 Nov 2010 12:39:12 +0900
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
Subject: Re: [patch 2/4] memcg: catch negative per-cpu sums in dirty info
Message-Id: <20101116123912.95d8605f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101107220353.414283590@cmpxchg.org>
References: <20101107215030.007259800@cmpxchg.org>
	<20101107220353.414283590@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  7 Nov 2010 23:14:37 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> Folding the per-cpu counters can yield a negative value in case of
> accounting races between CPUs.
> 
> When collecting the dirty info, the code would read those sums into an
> unsigned variable and then check for it being negative, which can not
> work.
> 
> Instead, fold the counters into a signed local variable, make the
> check, and only then assign it.
> 
> This way, the function signals correctly when there are insane values
> instead of leaking them out to the caller.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

