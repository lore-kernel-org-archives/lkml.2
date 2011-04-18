Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721Ab1DRQaj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 12:30:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:52064 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745Ab1DRQad convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 12:30:33 -0400
Subject: Re: [PATCH v3 2.6.39-rc1-tip 9/26]  9: uprobes: mmap and fork
 hooks.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110401143413.15455.75831.sendpatchset@localhost6.localdomain6>
References: <20110401143223.15455.19844.sendpatchset@localhost6.localdomain6>
	 <20110401143413.15455.75831.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 18 Apr 2011 18:29:23 +0200
Message-ID: <1303144163.32491.875.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-01 at 20:04 +0530, Srikar Dronamraju wrote:
> +               if (vaddr > ULONG_MAX)
> +                       /*
> +                        * We cannot have a virtual address that is
> +                        * greater than ULONG_MAX
> +                        */
> +                       continue; 

I'm having trouble with those checks.. while they're not wrong they're
not correct either. Mostly the top address space is where the kernel
lives and on 32-on-64 compat the boundary is much lower still. Ideally
it'd be TASK_SIZE, but that doesn't work since it assumes you're testing
for the current task.


