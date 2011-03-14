Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab1CNROA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 13:14:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59924 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab1CNRN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 13:13:59 -0400
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=OjXHl2S905kA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=AKMhOgkj_QJxKB-hJr4A:9 a=Abqye561LVGYEMGOfsYA:7 a=MURfYrteXVQ5wjnhus-LIz2QBwwA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH v2 2.6.38-rc8-tip 1/20]  1: mm: Move replace_page() to
 mm/memory.c
From: Steven Rostedt <rostedt@goodmis.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20110314170227.GN24254@linux.vnet.ibm.com>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
	 <20110314133413.27435.67467.sendpatchset@localhost6.localdomain6>
	 <1300112195.9910.92.camel@gandalf.stny.rr.com>
	 <20110314170227.GN24254@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 14 Mar 2011 13:13:54 -0400
Message-ID: <1300122834.9910.126.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-14 at 22:32 +0530, Srikar Dronamraju wrote:
> * Steven Rostedt <rostedt@goodmis.org> [2011-03-14 10:16:35]:
> 
> > On Mon, 2011-03-14 at 19:04 +0530, Srikar Dronamraju wrote:
> > > User bkpt will use background page replacement approach to insert/delete
> > > breakpoints. Background page replacement approach is based on
> > > replace_page. Hence replace_page() loses its static attribute.
> > > 
> > 
> > Just a nitpick, but since replace_page() is being moved, could you
> > specify that in the change log. Something like:
> > 
> > "Hence, replace_page() is moved from ksm.c into memory.c and its static
> > attribute is removed."
> 
> Okay, Will take care to add the moved from ksm.c into memory.c in the
> next version of patchset.


Thanks!

> > I like to see in the change log "move x to y" when that is actually
> > done, because it is hard to see if anything actually changed when code
> > is moved. Ideally it is best to move code in one patch and make the
> 
> As discussed in IRC, moving and removing the static attribute had to
> be one patch so that mm/ksm.c compiles correctly. The other option we
> have is to remove the static attribute first and then moving the
> function.

Hmm, maybe that may be a good idea. Since it is really two changes. One
is to make it global for other usages. I'm not even sure why you moved
it. The change log for the move can explain that.

-- Steve

> 
> > change in another. If you do cut another version of this patch set,
> > could you do that. This alone is not enough to require a new release.
> > 
> 


