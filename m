Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab1HAKkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 06:40:05 -0400
Received: from gate.crashing.org ([63.228.1.57]:44312 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999Ab1HAKkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 06:40:02 -0400
Subject: Re: [PATCH] perf: powerpc: Disable pagefaults during callchain
 stack read
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Ahern <dsahern@gmail.com>, anton@samba.org, acme@ghostprotocols.net,
        mingo@elte.hu, paulus@samba.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1312192792.2617.381.camel@laptop>
References: <1312059200-11563-1-git-send-email-dsahern@gmail.com>
	 <1312192792.2617.381.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Aug 2011 20:39:07 +1000
Message-ID: <1312195147.8793.794.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-01 at 11:59 +0200, Peter Zijlstra wrote:
> > Signed-off-by: David Ahern <dsahern@gmail.com>
> > CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > CC: Anton Blanchard <anton@samba.org> 
> 
> Hmm, Paul, didn't you fix something like this early on? Anyway, I've
> no
> objections since I'm really not familiar enough with the PPC side of
> things. 

I'm travelling so I haven't had a chance to review properly or even test
but it looks like an ad-hoc fix for the immediate problem.

Ultimately, I want to rework that stuff to do a __gup_fast like x86 does
(maybe as a fallback from an attempt at access first) so we work around
access permissions blocked by lack of dirty/accessed bits but in the
meantime, this should fix the immediate issue.

Cheers,
Ben.


