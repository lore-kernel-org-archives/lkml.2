Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab0JNIKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 04:10:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58726 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754633Ab0JNIKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 04:10:03 -0400
Date: Thu, 14 Oct 2010 01:10:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Casey Dahlin <cdahlin@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: allow ZONE_DMA to be configurable
Message-Id: <20101014011056.a58bac55.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1010131713160.24646@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1010131713160.24646@chino.kir.corp.google.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Oct 2010 17:15:04 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:

> ZONE_DMA is unnecessary for a large number of machines that do not
> require addressing in the lower 16MB of memory because they do not use
> ISA devices with 16-bit address registers (plus one page byte register).
> 
> This patch allows users to disable ZONE_DMA for x86 if they know they
> will not be using such devices with their kernel.
> 
> This prevents the VM from unnecessarily reserving a ratio of memory
> (defaulting to 1/256th of system capacity) with lowmem_reserve_ratio
> for such allocations when it will never be used.
> 

I wonder how hard it would be to do this at runtime, probably with a
boot parameter.

I'd be a little concerned at the effects of this on page reclaim and
the page allocator - it might expose weird pre-existing bugs or
inefficiencies.  But we can cross that bridge when we fall off it, I
guess.

