Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436Ab1DSN3O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 09:29:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46354 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab1DSN3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 09:29:13 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=1QQH6BUniP4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=owHtBCBMGy2idkNl1-sA:9 a=5cPSLGuINJWaWo-Cx0UA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH v3 2.6.39-rc1-tip 7/26]  7: x86: analyze instruction
 and determine fixups.
From: Steven Rostedt <rostedt@goodmis.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
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
In-Reply-To: <20110401143348.15455.68644.sendpatchset@localhost6.localdomain6>
References: <20110401143223.15455.19844.sendpatchset@localhost6.localdomain6>
	 <20110401143348.15455.68644.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 19 Apr 2011 09:29:11 -0400
Message-ID: <1303219751.7181.101.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-01 at 20:03 +0530, Srikar Dronamraju wrote:

> +
> +static void report_bad_prefix(void)
> +{
> +	printk(KERN_ERR "uprobes does not currently support probing "
> +		"instructions with any of the following prefixes: "
> +		"cs:, ds:, es:, ss:, lock:\n");
> +}
> +
> +static void report_bad_1byte_opcode(int mode, uprobe_opcode_t op)
> +{
> +	printk(KERN_ERR "In %d-bit apps, "
> +		"uprobes does not currently support probing "
> +		"instructions whose first byte is 0x%2.2x\n", mode, op);
> +}
> +
> +static void report_bad_2byte_opcode(uprobe_opcode_t op)
> +{
> +	printk(KERN_ERR "uprobes does not currently support probing "
> +		"instructions with the 2-byte opcode 0x0f 0x%2.2x\n", op);
> +}

Should these really be KERN_ERR, or is KERN_WARNING a better fit?

Also, can a non-privileged user cause these printks to spam the console
and cause a DoS to the system?

-- Steve


