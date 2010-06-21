Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701Ab0FUOMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 10:12:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60258 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932686Ab0FUOMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 10:12:45 -0400
X-Authority-Analysis: v=1.1 cv=w1shWbTWTAfAQ6jIUag4hBIbd8wqGnfzh/ne7nEp+Po= c=1 sm=0 a=REo-tUJNy-sA:10 a=ood2b7iyd8MA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=lTKsN74elYcQin_NR4YA:9 a=sPD7Ix6XrlHjXSZbAw4LQ4aSFE0A:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH v5 7/14] x86 support for Uprobes
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20100615121506.GM13800@linux.vnet.ibm.com>
References: <20100614082748.29068.21995.sendpatchset@localhost6.localdomain6>
	 <20100614082913.29068.86825.sendpatchset@localhost6.localdomain6>
	 <20100614175423.GG23754@infradead.org>
	 <20100615062332.GE13800@linux.vnet.ibm.com>
	 <20100615115155.GA4831@redhat.com>
	 <20100615121506.GM13800@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 21 Jun 2010 10:12:40 -0400
Message-ID: <1277129560.9181.6.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-15 at 17:45 +0530, Srikar Dronamraju wrote:

> local_irq_enable() translates to raw_local_irq_enable().
> However raw_local_irq_enable on x86 seems to depend on CONFIG_PARAVIRT.
> On a machine, where CONFIG_PARAVIRT was defined, local_irq_enable
> translates to something other than native_irq_enable.
> It translates to PVOP_VCALLEE0(pv_irq_ops.irq_enable);
> 
> Is it okay to use local_irq_enable() and then make CONFIG_UPROBES depend
> on !CONFIG_PARAVIRT?
> 

It should still work under paravirt. If it does not, we need to figurure
out why.

On boot up, when CONFIG_PARAVIRT is set but the kernel is running on
bare metal, a lot of the calls to things like "pv_irq_ops.irq_enabled"
are converted to the native caller anyway. Perhaps the conversion messed
up?

-- Steve


