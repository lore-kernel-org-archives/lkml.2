Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933504Ab2GCULt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 16:11:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:3465 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933424Ab2GCULq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 16:11:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="173086410"
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Calvin Walton <calvin.walton@kepstin.ca>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org, shemminger@vyatta.com
Subject: Re: long boot delays caused by 070ad7e7 floppy change
References: <20120702224648.GA20361@tassilo.jf.intel.com>
	<CA+55aFwre6s=orjUaNKJA=51Fc1mxu_XGX80Bex4Sn-=mWPx5Q@mail.gmail.com>
	<1341323230.3292.10.camel@nayuki.kepstin.ca>
	<CA+55aFyvzz3Lp9zeA6X+QMan0iZFWq_0Xd+ff_trnP1tpn2iJQ@mail.gmail.com>
	<1341337257.2406.1.camel@nayuki.kepstin.ca>
	<CA+55aFzOD33eWj0FQuZ7RWmF-yYwaeNB-9J-YY+mX4mwP7VXuA@mail.gmail.com>
	<CA+55aFwQqTAHNafGBXaoPCzVYw83OZvbG_hOYEDUxmuoMODO3Q@mail.gmail.com>
	<alpine.LNX.2.00.1207032008350.17304@pobox.suse.cz>
	<20120703185808.GM11413@one.firstfloor.org>
	<CA+55aFzFQiYhJcBfGD7moL3gC-ocwXJ2-kTjuNrw5hBGGbz4ag@mail.gmail.com>
	<1341344200.2413.4.camel@nayuki.kepstin.ca>
	<CA+55aFzn+dW+Aj5T_vVP3XG3n3P+7mqJwGQLsWY14yEwduku5Q@mail.gmail.com>
Date: Tue, 03 Jul 2012 13:11:43 -0700
In-Reply-To: <CA+55aFzn+dW+Aj5T_vVP3XG3n3P+7mqJwGQLsWY14yEwduku5Q@mail.gmail.com>
	(Linus Torvalds's message of "Tue, 3 Jul 2012 13:05:51 -0700")
Message-ID: <m2ipe4bo5c.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:
>
> Doing it asynchronously like Andi does helps a bit,

I think it would be more effective if the floppy driver initialized
earlier, I think I have some slowdown because it starts too late.

> but I suspect we
> could make the reset timeout shorter still just to make the initial
> "you don't have a floppy drive" code go faster.
>
> That said, why even compile in the floppy driver any more?

I used to boot simulators from make fdimage some time ago. Until
the kernels got too large :-)

But yes make isoimage is the way to go and

I'll remove it from my configs.

Thanks for the debugging.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
