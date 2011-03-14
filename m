Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab1CNRIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 13:08:23 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:48415 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986Ab1CNRIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 13:08:22 -0400
Date: Mon, 14 Mar 2011 22:32:27 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
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
Subject: Re: [PATCH v2 2.6.38-rc8-tip 1/20]  1: mm: Move replace_page() to
 mm/memory.c
Message-ID: <20110314170227.GN24254@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
 <20110314133413.27435.67467.sendpatchset@localhost6.localdomain6>
 <1300112195.9910.92.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1300112195.9910.92.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt <rostedt@goodmis.org> [2011-03-14 10:16:35]:

> On Mon, 2011-03-14 at 19:04 +0530, Srikar Dronamraju wrote:
> > User bkpt will use background page replacement approach to insert/delete
> > breakpoints. Background page replacement approach is based on
> > replace_page. Hence replace_page() loses its static attribute.
> > 
> 
> Just a nitpick, but since replace_page() is being moved, could you
> specify that in the change log. Something like:
> 
> "Hence, replace_page() is moved from ksm.c into memory.c and its static
> attribute is removed."

Okay, Will take care to add the moved from ksm.c into memory.c in the
next version of patchset.

> 
> I like to see in the change log "move x to y" when that is actually
> done, because it is hard to see if anything actually changed when code
> is moved. Ideally it is best to move code in one patch and make the

As discussed in IRC, moving and removing the static attribute had to
be one patch so that mm/ksm.c compiles correctly. The other option we
have is to remove the static attribute first and then moving the
function.

> change in another. If you do cut another version of this patch set,
> could you do that. This alone is not enough to require a new release.
> 

-- 
Thanks and Regards
Srikar
