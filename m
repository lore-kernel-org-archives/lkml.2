Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab2KEVoh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 16:44:37 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44676 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158Ab2KEVof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 16:44:35 -0500
Date: Mon, 5 Nov 2012 13:44:32 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Aaditya Kumar <aaditya.kumar.30@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        kosaki.motohiro@jp.fujitsu.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Mel Gorman <mel@csn.ul.ie>, akpm@linux-foundation.org,
        Minchan Kim <minchan.kim@gmail.com>, takamori.yamaguchi@jp.sony.com,
        takuzo.ohara@ap.sony.com, amit.agarwal@ap.sony.com,
        tim.bird@am.sony.com, frank.rowand@am.sony.com,
        kan.iibuchi@jp.sony.com, aaditya.kumar@ap.sony.com
Subject: Re: [PATCH] mm: bugfix: set current->reclaim_state to NULL while
 returning from kswapd()
In-Reply-To: <CAEtiSasbEXUeFwCNO09nT8TsEzLF-zZVyJ_pCO9V49hDPbpbAQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1211051342240.5296@chino.kir.corp.google.com>
References: <CAEtiSasbEXUeFwCNO09nT8TsEzLF-zZVyJ_pCO9V49hDPbpbAQ@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Nov 2012, Aaditya Kumar wrote:

> From: Takamori Yamaguchi <takamori.yamaguchi@jp.sony.com>
> 
> In kswapd(), set current->reclaim_state to NULL before returning, as
> current->reclaim_state holds reference to variable on kswapd()'s stack.
> 
> In rare cases, while returning from kswapd() during memory off lining,
> __free_slab() can access dangling pointer of current->reclaim_state.
> 

It's __free_slab() for slub and kmem_freepages() for slab.

> Signed-off-by: Takamori Yamaguchi <takamori.yamaguchi@jp.sony.com>
> Signed-off-by: Aaditya Kumar <aaditya.kumar@ap.sony.com>

Acked-by: David Rientjes <rientjes@google.com>
