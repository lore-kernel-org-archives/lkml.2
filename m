Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab1COWmo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 18:42:44 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59204 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263Ab1COWml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 18:42:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=BQsLLQSPXZYw9fF0Sj2+nyIz6rtUuwuYFiB9QcYN61AjaBKqLiF2coSQDsmBlxdfMp
         NJogoLYe4v/0SCvJav4pxb//BdXOx3OaIYK0zaXEf+Coc/l4WQWexVfupboPX2WEAaYN
         1QvEmSi83eIepBMm/UgnUEcvh55Bo+i3F/JCA=
Subject: Re: [PATCH v2 2.6.38-rc8-tip 4/20] 4: uprobes: Adding and remove a
 uprobe in a rb tree.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        SystemTap <systemtap@sources.redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1300218499.2250.12.camel@laptop>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
	 <20110314133444.27435.50684.sendpatchset@localhost6.localdomain6>
	 <alpine.LFD.2.00.1103151425060.2787@localhost6.localdomain6>
	 <20110315173041.GB24254@linux.vnet.ibm.com>
	 <alpine.LFD.2.00.1103151916120.2787@localhost6.localdomain6>
	 <1300218499.2250.12.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Mar 2011 23:42:24 +0100
Message-ID: <1300228944.2565.19.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 15 mars 2011 à 20:48 +0100, Peter Zijlstra a écrit :
> On Tue, 2011-03-15 at 20:22 +0100, Thomas Gleixner wrote:
> > I am not sure if its a good idea to walk the tree
> > > as and when the tree is changing either because of a insertion or
> > > deletion of a probe.
> > 
> > I know that you cannot walk the tree lockless except you would use
> > some rcu based container for your probes. 
> 
> You can in fact combine a seqlock, rb-trees and RCU to do lockless
> walks.
> 
>   https://lkml.org/lkml/2010/10/20/160
> 
> and
> 
>   https://lkml.org/lkml/2010/10/20/437
> 
> But doing that would be an optimization best done once we get all this
> working nicely.
> 

We have such schem in net/ipv4/inetpeer.c function inet_getpeer() (using
a seqlock on latest net-next-2.6 tree), but we added a counter to make
sure a reader could not enter an infinite loop while traversing tree
(AVL tree in inetpeer case).



