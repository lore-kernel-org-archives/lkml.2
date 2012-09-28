Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758344Ab2I1O6o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 10:58:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38543 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758246Ab2I1O6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 10:58:42 -0400
Date: Fri, 28 Sep 2012 16:58:42 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, eranian@google.com, acme@redhat.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 02/31] perf, x86: Basic Haswell PMU support
Message-ID: <20120928145842.GS16230@one.firstfloor.org>
References: <1348806696-31170-1-git-send-email-andi@firstfloor.org> <1348806696-31170-3-git-send-email-andi@firstfloor.org> <1348823145.3292.62.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348823145.3292.62.camel@twins>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 11:05:45AM +0200, Peter Zijlstra wrote:
> On Thu, 2012-09-27 at 21:31 -0700, Andi Kleen wrote:
> >  /*
> > + * Also filter out TSX bits.
> > + */
> > +#define TSX_FIXED_EVENT_CONSTRAINT(c, n)       \
> > +       EVENT_CONSTRAINT(c, (1ULL << (32+n)),   \
> > +                        X86_RAW_EVENT_MASK|HSW_INTX|HSW_INTX_CHECKPOINTED)
> 
> How volatile are those bits? Will the re-appear in future chips or are
> they prone to get re-assigned different semantics in future chips?

Traditionally these bits have been fairly stable.

> 
> If they're 'stable' we might as well add then to FIXED_EVENT_CONSTRAINT,
> its not like those bits would ever appear on previous hardware.

Ok will do.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
