Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab0EFXMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 19:12:21 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:43597 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105Ab0EFXMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 19:12:20 -0400
Date: Thu, 6 May 2010 16:12:11 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       eric.dumazet@gmail.com, David Miller <davem@davemloft.net>
Subject: Re: [PATCH tip/core/rcu 28/48] net: Make accesses to ->br_port
 safe for sparse RCU
Message-ID: <20100506231211.GK2325@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100504201934.GA19234@linux.vnet.ibm.com>
 <201005042341.49480.arnd@arndb.de>
 <20100505220355.GA20938@linux.vnet.ibm.com>
 <201005061609.25960.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005061609.25960.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 06, 2010 at 04:09:25PM +0200, Arnd Bergmann wrote:
> On Thursday 06 May 2010, Paul E. McKenney wrote:
> > On Tue, May 04, 2010 at 11:41:49PM +0200, Arnd Bergmann wrote:
> > > On Tuesday 04 May 2010 23:26:31 Stephen Hemminger wrote:
> > > > > The new versions of the rcu_dereference() APIs requires that any pointers
> > > > > passed to one of these APIs be fully defined.  The ->br_port field
> > > > > in struct net_device points to a struct net_bridge_port, which is an
> > > > > incomplete type.  This commit therefore changes ->br_port to be a void*,
> > > > > and introduces a br_port() helper function to convert the type to struct
> > > > > net_bridge_port, and applies this new helper function where required.
> > > > 
> > > > I would rather make the bridge hook generic and not take a type argument.
> > > 
> > > Not sure if you were confused by the comment in the same way that I was.
> > > 
> > > The bridge hook is not impacted by this at all, since we can either pass
> > > a void* or a struct net_bridge_port* to it. The br_port() helper
> > > is used for all the places where we actually want to dereference 
> > > dev->br_port and access its contents.
> > 
> > What should I change in the commit message to clear this up?
> > 
> > Of course, if the code needs to change, please let me know what should
> > change there as well.
> 
> I think it's both ok, I was mostly confused by the discussion we had earlier.
> Maybe add a sentence like:
> 
>  The br_handle_frame_hook now needs a forward declaration of struct net_bridge_port.

Done!

> Or you just change br_handle_frame_hook to take a void* to avoid the forward
> declaration. Not sure what Stephen was referring to really.

This sounds like a way to make things quite a bit more intrusive, so
holding off on this.

							Thanx, Paul
