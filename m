Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab1FMQu2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 12:50:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35388 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab1FMQuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 12:50:23 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=59rg9CyDpX8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=f5IAXkr0KiT0SUQI9KwA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH v4 3.0-rc2-tip 4/22]  4: Uprobes: register/unregister
 probes.
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1307660606.2497.1770.camel@laptop>
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
	 <20110607125900.28590.16071.sendpatchset@localhost6.localdomain6>
	 <1307660606.2497.1770.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 13 Jun 2011 12:50:19 -0400
Message-ID: <1307983819.9218.78.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-10 at 01:03 +0200, Peter Zijlstra wrote:

> The comment in del_consumer() that says: 'drop creation ref' worries me
> and makes me thing that is the last reference around and the uprobe will
> be freed right there, which clearly cannot happen since its not yet
> removed from the RB-tree.

I agree about that comment. It scared me too, not only about the RB
tree, but the uprobe is used later in that function to drop the
write_rwsem.

I think that comment needs to be changed to something like:

/* Have caller drop the creation ref */

-- Steve


