Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab1KWTcG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 14:32:06 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:58346 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab1KWTcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 14:32:04 -0500
X-Authority-Analysis: v=2.0 cv=Pdt9d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=rC-_LfCRzf8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=3nbZYyFuAAAA:8 a=2QWnC7eoKgDJ-wjxPC8A:9 a=VfwdzeOoO1cSx4Vmy_AA:7 a=QEXdDO2ut3YA:10 a=EvKJbDF4Ut8A:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH v7 3.2-rc2 20/30] tracing: Extract out common code for
 kprobes/uprobes traceevents.
From: Steven Rostedt <rostedt@goodmis.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Wilson <wilsons@start.ca>
In-Reply-To: <20111118111039.10512.78989.sendpatchset@srdronam.in.ibm.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
	 <20111118111039.10512.78989.sendpatchset@srdronam.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Nov 2011 14:32:01 -0500
Message-ID: <1322076721.20742.66.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-18 at 16:40 +0530, Srikar Dronamraju wrote:
> --- /dev/null
> +++ b/kernel/trace/trace_probe.h
> @@ -0,0 +1,160 @@
> +/*
> + * Common header file for probe-based Dynamic events.
> + *
> + * This program is free software; you can redistribute it and/or
> modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
> 02111-1307  USA
> + *
> + * Copyright (C) IBM Corporation, 2010
> + * Author:     Srikar Dronamraju
> + *
> + * Derived from kernel/trace/trace_kprobe.c written by

Shouldn't the above be:

 include/linux/trace_kprobe.h ?

Although, I would think both of these files are a bit more that derived
from. I would have been a bit stronger on the wording and say: This code
was copied from trace_kprobe.[ch] written by Masami ...

Then say,

Updates to make this generic:

 * Copyright (C) IBM Corporation, 2010
 * Author:     Srikar Dronamraju

-- Steve

> + * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> + */
> + 



