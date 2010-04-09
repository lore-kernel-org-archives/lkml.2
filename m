Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485Ab0DIJYZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 05:24:25 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:51709 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab0DIJYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 05:24:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=vnBXQQX79sxEAtxgPM3cGivNI4c6QoSAASuPD1r4sI/faK8l87ngOo0hDdXsINE/Cb
         RhwsOg2bp2cOQnI2sg5EgJ25kcdn7eSsGBr20cJYqpjDjiMeEJdWSXGJ7L1kk+aQ1c9S
         ffLMXyiHQ8pmtVAiGv3wM0+8o/WDXie6nyeV8=
Subject: Re: [PATCH tip/core/urgent 1/4] rcu: add rcu_access_pointer and
 rcu_dereference_protected
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu
In-Reply-To: <23572.1270804211@redhat.com>
References: <1270792042-9358-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20100409054701.GA8833@linux.vnet.ibm.com>  <23572.1270804211@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Apr 2010 11:24:18 +0200
Message-ID: <1270805058.2623.72.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 09 avril 2010 à 10:10 +0100, David Howells a écrit :
> Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > +#define rcu_access_pointer(p) ((void *)ACCESS_ONCE(p))
> > ...
> > +#define rcu_access_pointer(p)		((void *)ACCESS_ONCE(p))
> 
> There's no difference between your two versions of rcu_access_pointer(), so
> you could move that whole construct outside of the #ifdef'ed section.
> 
> Other than that:
> 
> Acked-by: David Howells <dhowells@redhat.com>

I also prefer to keep type checking if possible

#define rcu_access_pointer(p)		(ACCESS_ONCE(p))

Other than that:

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>


