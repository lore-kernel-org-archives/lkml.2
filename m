Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934169Ab0EDVnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 17:43:23 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56999 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933217Ab0EDVnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 17:43:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [PATCH tip/core/rcu 28/48] net: Make accesses to ->br_port safe for sparse RCU
Date: Tue, 4 May 2010 23:41:49 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.34-rc6-00090-g1509e54-dirty; KDE/4.4.2; x86_64; ; )
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       eric.dumazet@gmail.com, David Miller <davem@davemloft.net>
References: <20100504201934.GA19234@linux.vnet.ibm.com> <1273004398-19760-28-git-send-email-paulmck@linux.vnet.ibm.com> <20100504142631.148b52dc@nehalam>
In-Reply-To: <20100504142631.148b52dc@nehalam>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005042341.49480.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/RAJE6cZetWiSz8yctXNj3KCSaXJNmBjg6BvE
 BenzIm++ZXNvyL4VUZxrJ7GU9kd3OgQT6YJGCx+8rFdB37JJFR
 wuv+1TtwEFzSGnFpz8tbA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 May 2010 23:26:31 Stephen Hemminger wrote:
> > The new versions of the rcu_dereference() APIs requires that any pointers
> > passed to one of these APIs be fully defined.  The ->br_port field
> > in struct net_device points to a struct net_bridge_port, which is an
> > incomplete type.  This commit therefore changes ->br_port to be a void*,
> > and introduces a br_port() helper function to convert the type to struct
> > net_bridge_port, and applies this new helper function where required.
> > 
> 
> I would rather make the bridge hook generic and not take a type argument.

Not sure if you were confused by the comment in the same way that I was.

The bridge hook is not impacted by this at all, since we can either pass
a void* or a struct net_bridge_port* to it. The br_port() helper
is used for all the places where we actually want to dereference 
dev->br_port and access its contents.

	Arnd
