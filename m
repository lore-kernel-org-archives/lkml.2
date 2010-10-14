Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab0JNIcG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 04:32:06 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43220 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935Ab0JNIcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 04:32:04 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] x86: allow ZONE_DMA to be configurable
Cc: kosaki.motohiro@jp.fujitsu.com, David Rientjes <rientjes@google.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Casey Dahlin <cdahlin@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101014011056.a58bac55.akpm@linux-foundation.org>
References: <alpine.DEB.2.00.1010131713160.24646@chino.kir.corp.google.com> <20101014011056.a58bac55.akpm@linux-foundation.org>
Message-Id: <20101014172022.F9F2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 14 Oct 2010 17:32:00 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 13 Oct 2010 17:15:04 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:
> 
> > ZONE_DMA is unnecessary for a large number of machines that do not
> > require addressing in the lower 16MB of memory because they do not use
> > ISA devices with 16-bit address registers (plus one page byte register).
> > 
> > This patch allows users to disable ZONE_DMA for x86 if they know they
> > will not be using such devices with their kernel.
> > 
> > This prevents the VM from unnecessarily reserving a ratio of memory
> > (defaulting to 1/256th of system capacity) with lowmem_reserve_ratio
> > for such allocations when it will never be used.
> > 
> 
> I wonder how hard it would be to do this at runtime, probably with a
> boot parameter.
> 
> I'd be a little concerned at the effects of this on page reclaim and
> the page allocator - it might expose weird pre-existing bugs or
> inefficiencies.  But we can cross that bridge when we fall off it, I
> guess.

In this case, completely ZONE disablling is not required. 16MB saving
is not big matter. To prevent userland process use lower zone is necessary.

I have such patch, because 32bit highmem system has similar requirement.
(user process want to only use ZONE_HIGHMEM, otherwize ZONE_NORMAL easily
exshost)

I'll prepare to post them if necessary.




