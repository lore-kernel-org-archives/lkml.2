Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751332Ab1DGEXp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 00:23:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:37503 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab1DGEXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 00:23:43 -0400
Subject: Re: [PATCH] POWER: perf_event: Skip updating kernel counters if
 register value shrinks
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Eric B Munson <emunson@mgebm.net>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu,
        acme@ghostprotocols.net, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, anton@samba.org
In-Reply-To: <20110406212733.GB2596@mgebm.net>
References: <1301059689-4556-1-git-send-email-emunson@mgebm.net>
	 <1301378637.2402.671.camel@pasglop> <20110329142519.GA3527@mgebm.net>
	 <1301433165.2402.689.camel@pasglop> <20110330183656.GA2564@mgebm.net>
	 <1301551476.2407.61.camel@pasglop>  <20110406212733.GB2596@mgebm.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Apr 2011 14:22:57 +1000
Message-ID: <1302150177.2458.30.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Doesn't that mean that power_pmu_read() can only ever increase the value of
> > the perf_event and so will essentially -stop- once the counter rolls over ?
> > 
> > Similar comments every where you do this type of comparison.
> > 
> > Cheers,
> > Ben.
> 
> Sorry for the nag, but am I missing something about the way the register and
> the previous values are reset in the overflow interrupt handler?

Well, not all counters get interrupts right ? Some counters are just
free running... I'm not sure when that power_pmu_read() function is
actually used by the core, I'm not that familiar with perf, but I'd say
better safe than sorry. When comparing counter values, doing in a way
that is generally safe vs. wraparounds. Eventually do a helper for that.

Cheers,
Ben.


