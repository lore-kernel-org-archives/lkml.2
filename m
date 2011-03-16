Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750965Ab1CPEi2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 00:38:28 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:33944 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799Ab1CPEiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 00:38:25 -0400
Date: Tue, 15 Mar 2011 21:38:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [PATCH V4 1/1] rcu: introduce kfree_rcu()
Message-ID: <20110316043817.GH2273@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4D7F356C.8020903@cn.fujitsu.com>
 <201103151302.09381.arnd@arndb.de>
 <20110315121941.GD2167@linux.vnet.ibm.com>
 <201103151407.24800.arnd@arndb.de>
 <4D802746.3020509@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D802746.3020509@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 10:58:14AM +0800, Lai Jiangshan wrote:
> On 03/15/2011 09:07 PM, Arnd Bergmann wrote:
> > On Tuesday 15 March 2011, Paul E. McKenney wrote:
> >> And it makes use of statically allocated structures a bit clunky.
> > 
> > How do statically allocated structures relate to this? I would
> > expect that you never call kfree_rcu on them, so it shouldn't
> > matter.
> > 
> >> Yet another approach is to use the low-order bit of the rcu_head pointer,
> >> given that the rcu_head structure does have to be aligned.  If this bit
> >> is set, then the function pointer could be interpreted as an offset.
> >> This approach might also allow a slab_free_rcu() to be constructed, given
> >> that the full 32 bits of the function pointer would be available.
> >> For example, if the upper 16 bits are zero, the low-order 16 bits are
> >> the offset.  If the upper 16 bits are 0x1, then the low-order 16 bits
> >> might be an index that selects the desired slab cache.
> > 
> > This solution sounds like a clear improvement over the patch that Lai
> > Jiangshan posted, without any downsides.
> 
> This solution is good, but it changes too much code, I think we will switch to
> this solution until my posted solution can't work under some real bad situation
> happened.

Indeed, the bit patterns are totally internal to this patch, so we can
change as needed -- for example, if we later want to apply this same
technique to slab_free() as well as kfree().

							Thanx, Paul
