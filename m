Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758781Ab0EDV2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 17:28:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42570 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752880Ab0EDV23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 17:28:29 -0400
Date: Tue, 4 May 2010 14:26:31 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       eric.dumazet@gmail.com, Arnd Bergmann <arnd@arndb.de>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH tip/core/rcu 28/48] net: Make accesses to ->br_port safe
 for sparse RCU
Message-ID: <20100504142631.148b52dc@nehalam>
In-Reply-To: <1273004398-19760-28-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20100504201934.GA19234@linux.vnet.ibm.com>
	<1273004398-19760-28-git-send-email-paulmck@linux.vnet.ibm.com>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  4 May 2010 13:19:38 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> The new versions of the rcu_dereference() APIs requires that any pointers
> passed to one of these APIs be fully defined.  The ->br_port field
> in struct net_device points to a struct net_bridge_port, which is an
> incomplete type.  This commit therefore changes ->br_port to be a void*,
> and introduces a br_port() helper function to convert the type to struct
> net_bridge_port, and applies this new helper function where required.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: David Miller <davem@davemloft.net>
> Cc: Stephen Hemminger <shemminger@linux-foundation.org>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>

I would rather make the bridge hook generic and not take a type argument.
