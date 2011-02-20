Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007Ab1BTC7L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 21:59:11 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34987
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752238Ab1BTC7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 21:59:10 -0500
Date: Sat, 19 Feb 2011 18:59:46 -0800 (PST)
Message-Id: <20110219.185946.193690650.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: ebiederm@xmission.com, acme@redhat.com, torvalds@linux-foundation.org,
        mhocko@suse.cz, mingo@elte.hu, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org, xemul@openvz.org,
        daniel.lezcano@free.fr
Subject: Re: [PATCH] tcp: fix inet_twsk_deschedule()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1298104556.8559.21.camel@edumazet-laptop>
References: <20110218191146.GG13211@ghostprotocols.net>
	<m1sjvl2i3q.fsf@fess.ebiederm.org>
	<1298104556.8559.21.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Sat, 19 Feb 2011 09:35:56 +0100

> [PATCH] tcp: fix inet_twsk_deschedule()
> 
> Eric W. Biederman reported a lockdep splat in inet_twsk_deschedule()
> 
> This is caused by inet_twsk_purge(), run from process context,
> and commit 575f4cd5a5b6394577 (net: Use rcu lookups in inet_twsk_purge.)
> removed the BH disabling that was necessary.
> 
> Add the BH disabling but fine grained, right before calling
> inet_twsk_deschedule(), instead of whole function.
> 
> With help from Linus Torvalds and Eric W. Biederman
> 
> Reported-by: Eric W. Biederman <ebiederm@xmission.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> CC: Daniel Lezcano <daniel.lezcano@free.fr>
> CC: Pavel Emelyanov <xemul@openvz.org>
> CC: Arnaldo Carvalho de Melo <acme@redhat.com>
> CC: stable <stable@kernel.org> (# 2.6.33+)

Applied, thanks Eric.
