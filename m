Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132Ab0KPOXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 09:23:46 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:2280 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752221Ab0KPOXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 09:23:44 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AogKAKMh4kx5Ldur/2dsb2JhbACUX4ECjH1yvmaFSwSKWA
Message-Id: <20101116140900.039761100@kernel.dk>
User-Agent: quilt/0.48-1
Date: Wed, 17 Nov 2010 01:09:00 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 00/28] [rfc] dcache scaling part 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are 3 main parts to dcache scaling. This one primarily adds new locks
to take over dcache_lock, and some pre/post prep and streamlining patches.

The second implements fine grained locking, and is rather trivial after
part 1.

The third implements rcu-walk. rcu-walk depends on the first part, because it
relies on using d_lock to protect the state of the dentry (when converting from
rcu-walk to refcounted walk). Without the fine grained locing, we'd need to use
dcache_lock for that, which would be a step backwards to put into path walking
again.

Comments?


