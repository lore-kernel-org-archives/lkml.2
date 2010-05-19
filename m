Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab0ESWuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 18:50:52 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:55814 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475Ab0ESWuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 18:50:50 -0400
Date: Wed, 19 May 2010 15:50:46 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: npiggin@suse.de, torvalds@linux-foundation.org, anton@samba.org,
       akpm@linux-foundation.org, willy@linux.intel.com,
       benh@kernel.crashing.org, paulus@samba.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2]: atomic_t: Remove volatile from atomic_t definition
Message-ID: <20100519225046.GO2237@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LFD.2.00.1005170800100.4195@i5.linux-foundation.org>
 <20100519130327.GW2516@laptop>
 <20100519150132.GJ2237@linux.vnet.ibm.com>
 <20100519.125449.56392211.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100519.125449.56392211.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 12:54:49PM -0700, David Miller wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> Date: Wed, 19 May 2010 08:01:32 -0700
> 
> > On Wed, May 19, 2010 at 11:03:27PM +1000, Nick Piggin wrote:
> >> For atomic_read it shouldn't matter unless gcc is *really* bad at it.
> >> Ah, for atomic_read, the required semantic is surely ACCESS_ONCE, so
> >> that's where the volatile is needed? (maybe it would be clearer to
> >> explicitly use ACCESS_ONCE?)
> > 
> > Explicit use of ACCESS_ONCE() where needed makes a lot of sense to me,
> > and allows better code to be generated for initialization and cleanup
> > code where no other task has access to the atomic_t.
> 
> I agree and I want to see this too, but I think with the tree the size
> that it is we have to work backwards at this point.
> 
> Existing behavior by default, and optimized cases get tagged by using
> a new interface (atomic_read_light(), test_bit{,s}_light(), etc.)

Fair enough!

							Thanx, Paul
