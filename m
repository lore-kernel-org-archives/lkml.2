Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751207Ab1DURpt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 13:45:49 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:44001 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703Ab1DURps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 13:45:48 -0400
Date: Thu, 21 Apr 2011 23:01:20 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 2.6.39-rc1-tip 7/26]  7: x86: analyze instruction
 and determine fixups.
Message-ID: <20110421173120.GJ10698@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110401143223.15455.19844.sendpatchset@localhost6.localdomain6>
 <20110401143348.15455.68644.sendpatchset@localhost6.localdomain6>
 <1303219751.7181.101.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1303219751.7181.101.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt <rostedt@goodmis.org> [2011-04-19 09:29:11]:

> On Fri, 2011-04-01 at 20:03 +0530, Srikar Dronamraju wrote:
> 
> > +
> > +static void report_bad_prefix(void)
> > +{
> > +	printk(KERN_ERR "uprobes does not currently support probing "
> > +		"instructions with any of the following prefixes: "
> > +		"cs:, ds:, es:, ss:, lock:\n");
> > +}
> > +
> > +static void report_bad_1byte_opcode(int mode, uprobe_opcode_t op)
> > +{
> > +	printk(KERN_ERR "In %d-bit apps, "
> > +		"uprobes does not currently support probing "
> > +		"instructions whose first byte is 0x%2.2x\n", mode, op);
> > +}
> > +
> > +static void report_bad_2byte_opcode(uprobe_opcode_t op)
> > +{
> > +	printk(KERN_ERR "uprobes does not currently support probing "
> > +		"instructions with the 2-byte opcode 0x0f 0x%2.2x\n", op);
> > +}
> 
> Should these really be KERN_ERR, or is KERN_WARNING a better fit?
> 
> Also, can a non-privileged user cause these printks to spam the console
> and cause a DoS to the system?
> 

Sometimes, the user might try registering a probe at a valid file +
valid offset + valid consumer; but an instruction that we cant probe.
Then trying to figure why its failing would be very hard.

how about pr_warn_ratelimited()?

-- 
Thanks and Regards
Srikar
