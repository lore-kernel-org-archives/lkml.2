Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab1HXUCd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 16:02:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:39135 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617Ab1HXUCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 16:02:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="41534173"
From: Andi Kleen <andi@firstfloor.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 02/18] x86/ticketlock: convert spin loop to C
References: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
	<f04120629b8b1cfa1c306373e34320687305a518.1314207974.git.jeremy.fitzhardinge@citrix.com>
Date: Wed, 24 Aug 2011 13:02:29 -0700
In-Reply-To: <f04120629b8b1cfa1c306373e34320687305a518.1314207974.git.jeremy.fitzhardinge@citrix.com>
	(Jeremy Fitzhardinge's message of "Wed, 24 Aug 2011 10:52:56 -0700")
Message-ID: <m2liuid1d6.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:
> +
> +	for (;;) {
> +		if (inc.tickets.head == inc.tickets.tail)
> +			goto out;

What's wrong with break ?  Similar below.

> +		cpu_relax();
> +		inc.tickets.head = ACCESS_ONCE(lock->tickets.head);
> +	}
> +out:	barrier();		/* make sure nothing creeps before the lock is taken */
>  }


-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
