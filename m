Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908Ab0JXQVA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 12:21:00 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:4026 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820Ab0JXQU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 12:20:59 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAAb6w0yrRN+K/2dsb2JhbAChZnGeV5s0hUgEhFSFeYUE
X-IronPort-AV: E=Sophos;i="4.58,232,1286150400"; 
   d="scan'208";a="609059865"
From: Roland Dreier <rdreier@cisco.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Frysinger <vapier@gentoo.org>, Luca Barbieri <luca@luca-barbieri.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/atomic64_test: do not build on non-atomic64 systems
References: <1287250035-30404-1-git-send-email-vapier@gentoo.org>
	<20101021150250.f6499506.akpm@linux-foundation.org>
	<201010211823.38287.vapier@gentoo.org>
	<20101021155528.b3d6d027.akpm@linux-foundation.org>
	<AANLkTim6AFDw_1V9rtF4e_2tmgctbKHziQa-1e3=q7og@mail.gmail.com>
	<20101021162410.5c0d6720.akpm@linux-foundation.org>
	<AANLkTikGbK7=eW9L4A62Rin-E3usq4Ke_dPoCdStDyEw@mail.gmail.com>
	<20101022133138.6d82f79a.akpm@linux-foundation.org>
X-Message-Flag: Warning: May contain useful information
Date: Sun, 24 Oct 2010 09:20:34 -0700
In-Reply-To: <20101022133138.6d82f79a.akpm@linux-foundation.org> (Andrew
	Morton's message of "Fri, 22 Oct 2010 13:31:38 -0700")
Message-ID: <adavd4ro94d.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > That's only part of the problem.  The following won't build also:

 > drivers/infiniband/hw

Interesting... I hadn't looked at that usage before.  Both drivers that
seem to use atomic64 already depend on 64BIT in Kconfig, so I suspect
the intersection of 64BIT and !ATOMIC64 is empty?

But eg drivers/infiniband/hw/qib/qib_rc.c does essentially:

	atomic64_t *maddr;
	u64 sdata = <something>
	...
	maddr = (atomic64_t *) qp->r_sge.sge.vaddr;
	atomic64_add_return(sdata, maddr)

is it legit to cast some random address to atomic64_t and expect it to
work across archs that implement atomic64?  (I expect x86_64 is probably
OK but I wonder if other architectures might not be so understanding)

 - R.
