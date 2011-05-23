Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628Ab1EWQo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 12:44:26 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45107 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756343Ab1EWQoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 12:44:25 -0400
Date: Mon, 23 May 2011 18:44:21 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        andi@firstfloor.org, ming.m.lin@intel.com
Subject: Re: [PATCH 1/3] perf_events: update Intel extra regs shared constraints management (v3)
Message-ID: <20110523164421.GC15299@one.firstfloor.org>
References: <20110523161247.GA11590@quad>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110523161247.GA11590@quad>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 06:12:47PM +0200, Stephane Eranian wrote:
>     
> This patch improves the code managing the extra shared registers
> used for offcore_response events on Intel Nehalem/Westmere. The
> idea is to use static allocation instead of dynamic allocation.
> This simplifies greatly the get and put constraint routines for
> those events.
>     
> The patch also renames per_core to shared_regs because the same
> data structure gets used whether or not HT is on. When HT is
> off, those events still need to coordination because they use
> a extra MSR that has to be shared within an event group.
>     
> The first post of this patch had an older (bogus) version of
> the patch with bogus initialization of reg->idx.

I did a quick read -- not full check -- and it looked good to me.
I like the idea of preallocating the slots.

Acked-by: Andi Kleen <ak@linux.intel.com>

-Andi
