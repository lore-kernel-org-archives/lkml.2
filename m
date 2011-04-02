Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab1DBAIB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 20:08:01 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49972
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752129Ab1DBAH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 20:07:59 -0400
Date: Fri, 01 Apr 2011 17:07:20 -0700 (PDT)
Message-Id: <20110401.170720.104061844.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: a.p.zijlstra@chello.nl, avi@redhat.com, mel@csn.ul.ie, aarcange@redhat.com,
        tglx@linutronix.de, riel@redhat.com, mingo@elte.hu,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-mm@kvack.org,
        benh@kernel.crashing.org, hugh.dickins@tiscali.co.uk,
        npiggin@kernel.dk, paulmck@linux.vnet.ibm.com,
        yanmin_zhang@linux.intel.com, schwidefsky@de.ibm.com,
        rmk@arm.linux.org.uk, lethal@linux-sh.org, jdike@addtoit.com,
        tony.luck@intel.com, hughd@google.com
Subject: Re: [PATCH 02/17] mm: mmu_gather rework
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTimvHdGZptwmmw73C2jsy=HqgreEAxNurT1Hxbv=@mail.gmail.com>
References: <4D87109A.1010005@redhat.com>
	<1301659631.4859.565.camel@twins>
	<AANLkTimvHdGZptwmmw73C2jsy=HqgreEAxNurT1Hxbv=@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 1 Apr 2011 09:13:51 -0700

> What's the difference? Integer assignment makes a hell of a difference. Do this:
> 
>   long long expression = ...
>   ...
>   bool val = expression;
> 
> and depending on implementation it will either just truncate the value
> to a random number of bits, or actually do a compare with zero.

But note that, as you indicate, using int's to store boolean values
have this exact problem.

And most of the time people are converting an "int used as a boolean
value" into a "bool".

At least the "bool" has a chance of giving true boolean semantics in
the case you describe, whereas the 'int' always has the potential
truncation issue.

So, personally, I see it as a net positive to convert int to bool when
the variable is being used to take on true/false values.
