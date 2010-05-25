Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397Ab0EYJTN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 05:19:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42372 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756278Ab0EYJTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 05:19:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=NSciPlgaUpnVMT3XWGd/mpVIJyfreiVo3McbdKRtoh2vzFUdFz2gPvZe1eWYz4Vwr3
         BE5cLUtYdlS8KpK0Gtz5e2ZncN/WIRmfSxcoMGIzToyxMUh7aK3lchdMP13jSScg1CNh
         p8/BrKV0yFejXcekzHcmZJKeOT1orIYEhhvXQ=
MIME-Version: 1.0
In-Reply-To: <20100525081634.GE5087@laptop>
References: <20100521211452.659982351@quilx.com>
	<20100524070309.GU2516@laptop>
	<alpine.DEB.2.00.1005240852580.5045@router.home>
	<20100525020629.GA5087@laptop>
	<AANLkTik2O-_Fbh-dq0sSLFJyLU7PZi4DHm85lCo4sugS@mail.gmail.com>
	<20100525070734.GC5087@laptop>
	<AANLkTimhTfz_mMWNh_r18yapNxSDjA7wRDnFM6L5aIdE@mail.gmail.com>
	<20100525081634.GE5087@laptop>
Date: Tue, 25 May 2010 12:19:09 +0300
X-Google-Sender-Auth: 49nhnGiZiAquPnYs4N117X9Kd5s
Message-ID: <AANLkTilJBY0sinB365lIZFUaMgMCZ1xyhMdXRTJTVDSV@mail.gmail.com>
Subject: Re: [RFC V2 SLEB 00/14] The Enhanced(hopefully) Slab Allocator
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Nick Piggin <npiggin@suse.de>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Matthew Wilcox <willy@linux.intel.com>, Matt Mackall <mpm@selenic.com>,
       Mel Gorman <mel@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

On Tue, May 25, 2010 at 11:16 AM, Nick Piggin <npiggin@suse.de> wrote:
> I don't think SLUB ever proved itself very well. The selling points
> were some untestable handwaving about how queueing is bad and jitter
> is bad, ignoring the fact that queues could be shortened and periodic
> reaping disabled at runtime with SLAB style of allocator. It also
> has relied heavily on higher order allocations which put great strain
> on hugepage allocations and page reclaim (witness the big slowdown
> in low memory conditions when tmpfs was using higher order allocations
> via SLUB).

The main selling point for SLUB was NUMA. Has the situation changed?
Reliance on higher order allocations isn't that relevant if we're
anyway discussing ways to change allocation strategy.

On Tue, May 25, 2010 at 11:16 AM, Nick Piggin <npiggin@suse.de> wrote:
> SLUB has not been able to displace SLAB for a long timedue to
> performance and higher order allocation problems.
>
> I think "clean code" is very important, but by far the hardest thing to
> get right by far is the actual allocation and freeing strategies. So
> it's crazy to base such a choice on code cleanliness. If that's the
> deciding factor, then I can provide a patch to modernise SLAB and then
> we can remove SLUB and start incremental improvements from there.

I'm more than happy to take in patches to clean up SLAB but I think
you're underestimating the required effort. What SLUB has going for
it:

  - No NUMA alien caches
  - No special lockdep handling required
  - Debugging support is better
  - Cpuset interractions are simpler
  - Memory hotplug is more mature
  - Much more contributors to SLUB than to SLAB

I was one of the people cleaning up SLAB when SLUB was merged and
based on that experience I'm strongly in favor of SLUB as a base.

                        Pekka
