Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab2FYKD2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 06:03:28 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52100 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab2FYKD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 06:03:26 -0400
Date: Mon, 25 Jun 2012 12:03:21 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Jack Steiner <steiner@sgi.com>, Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 3/3] x86: UV2 BAU hang workarounds
Message-ID: <20120625100321.GB27081@gmail.com>
References: <E1Si3c5-0008I6-CG@eag09.americas.sgi.com>
 <20120622131459.GC31884@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120622131459.GC31884@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cliff Wickman <cpw@sgi.com> wrote:

> On SGI's UV2 the BAU (Broadcast Assist Unit) driver can hang under a
> heavy load.  To cure this: 
> 
> - Disable the UV2 extended status mode (see UV2_EXT_SHFT), as this
>   mode changes BAU behavior in more ways then just delivering an extra bit
>   of status.  Revert status to just two meaningful bits, like UV1.
> - Use no IPI-style resets on UV2.  Just give up the request for whatever the
>   reason it failed and let it be accomplished with the legacy IPI method.
> - Use no alternate sending descriptor (the former UV2 workaround
>   bcp->using_desc and handle_uv2_busy() stuff).  Just disable the use of the
>   BAU for a period of time in favor of the legacy IPI method when the h/w bug
>   leaves a descriptor busy.
>   -- new tunable: giveup_limit determines the threshold at which a hub is 
>      so plugged that it should do all requests with the legacy IPI method for a
>      period of time
>   -- generalize disable_for_congestion() (renamed disable_for_period()) for
>      use whenever a hub should avoid using the BAU for a period of time
> 
> Misc:
> - fix find_another_by_swack(), which is part of the UV2 bug workaround
> - correct and clarify the statistics (new stats s_overipilimit s_giveuplimit
>   s_enters s_ipifordisabled s_plugged s_congested)

Sigh, it looks like something that ought to be 7 successive, 
easy to review commits got mixed up into a single, huge, hard to 
review commit. How did that happen?

Thanks,

	Ingo
