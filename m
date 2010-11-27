Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab0K0KhA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 05:37:00 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:36552 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752320Ab0K0Kg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 05:36:59 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAGdt8Ex5Lcx2/2dsb2JhbACjC3K+AYVHBA
Date: Sat, 27 Nov 2010 21:36:56 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Nick Piggin <npiggin@kernel.dk>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Could we do immediate pte zaps in vunmap?
Message-ID: <20101127103656.GA6884@amd>
References: <4CEF6B8B.8080206@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CEF6B8B.8080206@goop.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 12:10:51AM -0800, Jeremy Fitzhardinge wrote:
> What if vm_unmap_ram() and co. immediately zeroed out the ptes, but
> lazily deferred the tlb flushes?  It seems to me there's no benefit in
> batching up the pte clearing since that can't be amortized like the tlb
> flush.

Yes that can be done.


> I think that would solve the problem we have with the interactions
> between lazy unmap and Xen.  The issue is having stray pte entries
> around (because Xen keeps track of those as part of its page-type
> mechanism), but stale tlb entries are no problem.

It would be great if that solves it.
