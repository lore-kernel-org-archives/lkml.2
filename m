Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396Ab0EUGGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 02:06:47 -0400
Received: from cantor.suse.de ([195.135.220.2]:33246 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932289Ab0EUGGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 02:06:05 -0400
Date: Fri, 21 May 2010 16:06:00 +1000
From: Nick Piggin <npiggin@suse.de>
To: David Miller <davem@davemloft.net>
Cc: paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org, anton@samba.org,
       akpm@linux-foundation.org, willy@linux.intel.com,
       benh@kernel.crashing.org, paulus@samba.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2]: atomic_t: Remove volatile from atomic_t definition
Message-ID: <20100521060600.GM2516@laptop>
References: <20100519.125449.56392211.davem@davemloft.net>
 <20100519225046.GO2237@linux.vnet.ibm.com>
 <20100521052746.GL2516@laptop>
 <20100520.225454.37197037.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100520.225454.37197037.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20, 2010 at 10:54:54PM -0700, David Miller wrote:
> From: Nick Piggin <npiggin@suse.de>
> Date: Fri, 21 May 2010 15:27:46 +1000
> 
> > Hmm, I'm missing something. David, back up a second, as far as I can see,
> > with Anton's patches, atomic_read() *is* effectively just ACCESS_ONCE()
> > now. Linus pointed out that header tangle is the reason not to just use
> > the macro.
> 
> My bad, I was under the impression that the proposal was to remove
> volatile usage and also not even do ACCESS_ONCE() in atomic_read().
> 
> And then explicitly annotate call sits that actually need the
> ACCESS_ONCE() semantic.

Ah ok, no. I see ACCESS_ONCE is a fundamental ("obvious") property of
atomic_read, so we definitely should keep it, even if we could audit
everyone.

Actually, I bet we have a lot of bugs there with loading integers and
pointers atomically, where the code assumes the loaded value will not
be reloaded by the compiler, because it is an easy thing to assume.

atomic_read_light could be useful though, for sure.

