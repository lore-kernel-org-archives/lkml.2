Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab0ECUOI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 16:14:08 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:46173 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756535Ab0ECUOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 16:14:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qHsNir/Wxr6JjJlCzUI8cnRbBxp9fTY1bNF4C8NJjuqX08VBG9tFth/EHMFibqgcIa
         Co1b3/WiRRLyjgoY9/ZVIYG2ljNQZY59OxaLEZYpmpcrH0NYkxv1LWx3sKPv3ekC2gEK
         f1skZo/OQvcAmnWp5/1mjbf/X5oFUN72DmX4Q=
Subject: Re: [PATCH net-next-2.6] net: if6_get_next() fix
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: paulmck@linux.vnet.ibm.com, shemminger@vyatta.com, Valdis.Kletnieks@vt.edu,
       akpm@linux-foundation.org, peterz@infradead.org, kaber@trash.net,
       linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <20100503.130902.172620141.davem@davemloft.net>
References: <1272903293.2226.50.camel@edumazet-laptop>
	 <20100503181629.GJ2597@linux.vnet.ibm.com>
	 <1272916007.2407.75.camel@edumazet-laptop>
	 <20100503.130902.172620141.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 May 2010 22:13:55 +0200
Message-ID: <1272917635.2407.106.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 03 mai 2010 à 13:09 -0700, David Miller a écrit :
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Mon, 03 May 2010 21:46:47 +0200
> 
> > Then, net-next-2.6 doesnt yet have your commit Paul to relax
> > hlist_for_each_entry_rcu(), so its a bit difficult to continue the work.
> 
> Is that in Linus's tree yet?  If it propagates there I can make it
> propagate to net-next-2.6, you just have to tell me you need it.


Hmm, it seems it's already in net-next-2.6, sorry for the confusion.

commit 3120438ad68601f341e61e7cb1323b0e1a6ca367
Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Date:   Mon Feb 22 17:04:48 2010 -0800

    rcu: Disable lockdep checking in RCU list-traversal primitives
    
    The theory is that use of bare rcu_dereference() is more prone
    to error than use of the RCU list-traversal primitives.
    Therefore, disable lockdep RCU read-side critical-section
    checking in these primitives for the time being.  Once all of
    the rcu_dereference() uses have been dealt with, it may be time
    to re-enable lockdep checking for the RCU list-traversal
    primitives.
    


