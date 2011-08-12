Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666Ab1HLNFq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 09:05:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:34252 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab1HLNFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 09:05:45 -0400
X-Authority-Analysis: v=1.1 cv=YhhhcVvq/Bf3xBNEvzTEV9JHGW2mXul7kEbaqsyQnMQ= c=1 sm=0 a=b6fuAeHeA_gA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=5nDEedgFmzgbygEZf50A:9 a=E7PL98EbeFmZ9fkpu5IA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 3/5][RFC] ftrace: Return pt_regs to function trace
 callback (x86_64 only so
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jason Baron <jbaron@redhat.com>, yrl.pp-manager.tt@hitachi.com
In-Reply-To: <4E4479E9.5040804@hitachi.com>
References: <20110810162222.017387055@goodmis.org>
	 <20110810163038.238028499@goodmis.org>  <4E436EDC.2080101@hitachi.com>
	 <1313067566.18583.288.camel@gandalf.stny.rr.com>
	 <4E4479E9.5040804@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 12 Aug 2011 09:05:40 -0400
Message-ID: <1313154341.18583.316.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-12 at 09:55 +0900, Masami Hiramatsu wrote:

> Please note, kprobes is the function which basically provides a
> breakpoint handler in the kernel. Users expect that. So all registers
> should be provided as breakpoint interrupt does. That's what I said
> "transparently".

Well, I think I'm on the right track then. Because I'm working to get
the function graph tracer to use this functionality as well.

I believe that I can make this work "transparently" too.

I'm now working on having ftrace use the breakpoint/update method as
well as the stop_machine() method. If an arch has an alternative to
stop_machine, then it can use that method instead.

-- Steve



