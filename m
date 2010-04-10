Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751253Ab0DJGDw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 02:03:52 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:34679 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab0DJGDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 02:03:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZJxMGqRCx/y6+h0tzRt7bTRpHn147qHmXHRP87sxvyIBe24LHzmUuyJZCoEbqabETC
         rPBrzigOd7nwz3t/y6K1Sx0DTWy2Y69yzhE488TBw61i7y0rccBvCq1xsdBMFM6SXkQN
         Iz92p+RavxiJ+8u3ZFLFcaisgT3K13Kvbirgk=
Subject: Re: [PATCH tip/core/urgent 1/3] rcu: add rcu_access_pointer and
 rcu_dereference_protected
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com
In-Reply-To: <1270852752-25278-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20100409223843.GA25133@linux.vnet.ibm.com>
	 <1270852752-25278-1-git-send-email-paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 10 Apr 2010 08:03:43 +0200
Message-ID: <1270879423.2093.5.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 09 avril 2010 à 15:39 -0700, Paul E. McKenney a écrit :
> This patch adds variants of rcu_dereference() that handle situations
> where the RCU-protected data structure cannot change, perhaps due to
> our holding the update-side lock, or where the RCU-protected pointer is
> only to be fetched, not dereferenced.  These are needed due to some
> performance concerns with using rcu_dereference() where it is not
> required, aside from the need for lockdep/sparse checking.
> 
> The new rcu_access_pointer() primitive is for the case where the pointer
> is be fetch and not dereferenced.  This primitive may be used without
> protection, RCU or otherwise, due to the fact that it uses ACCESS_ONCE().
> 
> The new rcu_dereference_protected() primitive is for the case where updates
> are prevented, for example, due to holding the update-side lock.  This
> primitive does neither ACCESS_ONCE() nor smp_read_barrier_depends(), so
> can only be used when updates are somehow prevented.
> 
> Suggested-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>


