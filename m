Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab0ICOwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 10:52:23 -0400
Received: from cantor.suse.de ([195.135.220.2]:35047 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752874Ab0ICOwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 10:52:20 -0400
From: Petr Tesarik <ptesarik@suse.cz>
Organization: SUSE LINUX, s.r.o.
To: Tony Luck <tony.luck@intel.com>
Subject: Re: Serious problem with ticket spinlocks on ia64
Date: Fri, 3 Sep 2010 16:52:55 +0200
User-Agent: KMail/1.9.10
Cc: "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <201008271537.35709.ptesarik@suse.cz> <201009031104.38433.ptesarik@suse.cz> <201009031635.25093.ptesarik@suse.cz>
In-Reply-To: <201009031635.25093.ptesarik@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201009031652.56476.ptesarik@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 of September 2010 16:35:23 Petr Tesarik wrote:
> On Friday 03 of September 2010 11:04:37 Petr Tesarik wrote:
> > [...]
> > I'm now trying to modify the lock primitives:
> >
> > 1. replace the fetchadd4.acq with looping over cmpxchg
>
> I did this and I feel dumber than ever.

One more thing - the crash dump I got from that run shows that CPU 2 was just 
going through zap_page_range(), so it probably also did a few global TLB 
flushes. I'm not sure how this should matter, but any idea is good now, I 
think.

Anyway, if a global TLB flush is necessary to trigger the bug, it would also 
explain why we couldn't reproduce it in user-space.

OK, I know I'm just wildly guessing (and don't have any explanation for the 
wrap-around mystery) ... but does anybody have a better idea?

Petr Tesarik
