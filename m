Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932666Ab0FUOSX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 10:18:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:46641 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932544Ab0FUOSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 10:18:22 -0400
X-Authority-Analysis: v=1.1 cv=CgZcVGhTQjO/Ps/WuM8OsaKfzS+Ps8TRNnlzkE3q20U= c=1 sm=0 a=IqxrBKBoYjYA:10 a=UBIxAjGgU1YA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=VnNF1IyMAAAA:8 a=YsDZIYbtGI6G9jesnTkA:9 a=P32MTmaOVCMhpa54tjsA:7 a=7kd5fJkBr85n06qImdrOG61hWUUA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH v5 10/14] trace: Common code for kprobes/uprobes
 traceevents
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20100614082953.29068.76083.sendpatchset@localhost6.localdomain6>
References: <20100614082748.29068.21995.sendpatchset@localhost6.localdomain6>
	 <20100614082953.29068.76083.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 21 Jun 2010 10:18:19 -0400
Message-ID: <1277129899.9181.8.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-14 at 13:59 +0530, Srikar Dronamraju wrote:
> share_traceevents.patch.
> 
> From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> 
> Changelog from v5: Addressed comments from Masami.
>         Also shared lot more code from kprobes traceevents.
> 
> Move common parts of trace_kprobe.c and trace_uprobec.
> Adjust kernel/trace/trace_kprobe.c after moving common code to
> kernel/trace/trace_probe.h. However they still have few duplicate
> functions.
> 
> TODO: Merge both events to a single probe event.
> 
> Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> ---
> 
>  kernel/trace/trace_kprobe.c |  141 +--------------------------------------
>  kernel/trace/trace_probe.h  |  157 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 161 insertions(+), 137 deletions(-)
>  create mode 100644 kernel/trace/trace_probe.h
> 

> diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
> new file mode 100644
> index 0000000..b4c5763
> --- /dev/null
> +++ b/kernel/trace/trace_probe.h
> @@ -0,0 +1,157 @@
> +/*
> + * Common header file for probe-based Dynamic events.
> + *
> + * This program is free software; you can redistribute it and/or modify
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
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + *
> + * Copyright (C) IBM Corporation, 2010
> + * Author:	Srikar Dronamraju

Note, when moving stuff from one file to another, you still need to keep
the copyright and author of the original file. You can add your name and
copyright as well, when you add your stuff to it.

-- Steve


