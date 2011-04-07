Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037Ab1DGWwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 18:52:13 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36622 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756442Ab1DGWwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 18:52:12 -0400
Date: Fri, 8 Apr 2011 00:52:08 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Raghavendra D Prabhu <rprabhu@wnohang.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Andy Lutomirski <luto@mit.edu>,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [RFT/PATCH v2 2/6] x86-64: Optimize vread_tsc's barriers
Message-ID: <20110407225208.GD21838@one.firstfloor.org>
References: <cover.1302137785.git.luto@mit.edu> <80b43d57d15f7b141799a7634274ee3bfe5a5855.1302137785.git.luto@mit.edu> <BANLkTi=RkeFMpcb36RrJ=+eYm-xk4B2zYw@mail.gmail.com> <20110407164245.GA21838@one.firstfloor.org> <BANLkTikdn+Y2pWoLH_=Q4xHTgT6XGfOuSg@mail.gmail.com> <20110407214307.GA6449@Xye>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110407214307.GA6449@Xye>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If only one lfence or serializing instruction is to be used, can't we
> just use RDTSCP instruction (X86_FEATURE_RDTSCP,available only in >=
> i7's and AMD)  which both provides TSC as well as an upward serializing

RDTSCP is a full synchronization, much heavier and slower than LFENCE
(or even two of them) Besides it doesn't exist on older CPUs.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
