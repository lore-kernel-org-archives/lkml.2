Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab0GNLv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 07:51:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:35663 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753137Ab0GNLv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 07:51:58 -0400
Message-ID: <4C3DA4B9.1060206@kernel.org>
Date: Wed, 14 Jul 2010 13:51:21 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Heinz Diehl <htd@fancy-poultry.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-mm@kvack.org, Nick Piggin <npiggin@suse.de>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [S+Q2 00/19] SLUB with queueing (V2) beats SLAB netperf TCP_RR
References: <20100709190706.938177313@quilx.com> <20100710195621.GA13720@fancy-poultry.org> <alpine.DEB.2.00.1007121010420.14328@router.home> <20100712163900.GA8513@fancy-poultry.org> <alpine.DEB.2.00.1007121156160.18621@router.home> <20100713135650.GA6444@fancy-poultry.org> <alpine.DEB.2.00.1007132055470.14067@router.home>
In-Reply-To: <alpine.DEB.2.00.1007132055470.14067@router.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 14 Jul 2010 11:51:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 07/14/2010 04:01 AM, Christoph Lameter wrote:
> I dont see anything in there at first glance that would cause slub to
> increase its percpu usage. This is straight upstream?

It's basically checking constant expressions there and
PERCPU_DYNAMIC_EARLY_SIZE is defined as 12k, so slub is thinking that
it's gonna use more memory on that build.

> Try to just comment out the BUILD_BUG_ON. I had it misfire before and
> fixed the formulae to no longer give false positives. Maybe that is
> another case. Tejun wanted that but never was able to give me an exact
> formular to check for.

Yeah, unfortunately, due to alignment requirements, it can't be
determined with accuracy.  We'll just have to size it sufficiently.

> At the Ottawa Linux Symposium right now so responses may be delayed.
> Hotels Internet connection keeps getting clogged for some reason.

I'm in suse labs conf until next week so I don't think I'll be doing
much till then either.

Thanks.

-- 
tejun
