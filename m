Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab1FIXBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 19:01:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:45535 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756650Ab1FIW7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 18:59:49 -0400
Subject: Re: [PATCH v4 3.0-rc2-tip 5/22]  5: x86: analyze instruction and
 determine fixups.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Jonathan Corbet <corbet@lwn.net>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110607125911.28590.41526.sendpatchset@localhost6.localdomain6>
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
	 <20110607125911.28590.41526.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Jun 2011 01:03:19 +0200
Message-ID: <1307660599.2497.1761.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 18:29 +0530, Srikar Dronamraju wrote:
> +static void report_bad_prefix(void)
> +{
> +       pr_warn_once("uprobes does not currently support probing "
> +               "instructions with any of the following prefixes: "
> +               "cs:, ds:, es:, ss:, lock:\n");
> +}
> +
> +static void report_bad_1byte_opcode(int mode, uprobe_opcode_t op)
> +{
> +       pr_warn_once("In %d-bit apps, "
> +               "uprobes does not currently support probing "
> +               "instructions whose first byte is 0x%2.2x\n", mode, op);
> +}
> +
> +static void report_bad_2byte_opcode(uprobe_opcode_t op)
> +{
> +       pr_warn_once("uprobes does not currently support probing "
> +               "instructions with the 2-byte opcode 0x0f 0x%2.2x\n", op);
> +} 

I really don't like all that dmesg muck, why not simply fail the op?

This _once stuff is pretty useless too, once you've had them all
subsequent probe attempts will not say anything and leave you in the
dark anyway.



