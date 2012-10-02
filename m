Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab2JBW0K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 18:26:10 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51758 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab2JBW0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 18:26:07 -0400
Date: Tue, 02 Oct 2012 18:26:01 -0400 (EDT)
Message-Id: <20121002.182601.845433592794197720.davem@davemloft.net>
To: linux-mm@kvack.org
CC: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, akpm@linux-foundation.org,
        aarcange@redhat.com, hannes@cmpxchg.org
Subject: [PATCH 0/8] THP support for Sparc64
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here is a set of patches that add THP support for sparc64.

A few of them are relatively minor portability issues I ran into.
Like the MIPS guys I hit the update_mmu_cache() typing issue so I have
a patch for that here.

It is very likely that I need the ACCESSED bit handling fix the
ARM folks have been posting recently as well.

On the sparc64 side the biggest issue was moving to only supporting
4MB pages and then realigning the page tables so that the PMDs map 4MB
(instead of 8MB as they do now).

The rest was just trial and error, running tests, and fixing bugs.

A familiar test case that makes 5 million random accesses to a 1GB
memory area goes from 20 seconds down to 0.43 seconds with THP enabled
on my SPARC T4-2 box.

Signed-off-by: David S. Miller <davem@davemloft.net>
