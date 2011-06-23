Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933746Ab1FWUXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 16:23:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:55851 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759864Ab1FWUXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 16:23:50 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=n8OuPOP5gMEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=ZAgKxoWkzoUn93R7XSwA:9 a=-DBsoA4H1K1Z-cjGtVIA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 09/15] xen/trace: add tlb flush tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Xen Devel <Xen-devel@lists.xensource.com>,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
In-Reply-To: <4E03996B.9050904@goop.org>
References: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
	 <4db3e32a6b21efdb4d82646816ddb1bb82ff2259.1308607697.git.jeremy.fitzhardinge@citrix.com>
	 <20110621140705.GD28229@dumpdata.com>  <4E03996B.9050904@goop.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 23 Jun 2011 16:23:48 -0400
Message-ID: <1308860628.531.42.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-23 at 12:52 -0700, Jeremy Fitzhardinge wrote:
> On 06/21/2011 07:07 AM, Konrad Rzeszutek Wilk wrote:
> >> +TRACE_EVENT(xen_mmu_flush_tlb,
> >> +	    TP_PROTO(int x),
> >> +	    TP_ARGS(x),
> >> +	    TP_STRUCT__entry(__array(char, x, 0)),
> >> +	    TP_fast_assign((void)x),
> >> +	    TP_printk("%s", "")
> > Um, why not just "" without the %s?
> 
> Uh, vararg macro bogusness; need to supply 2 args.
> 

Ouch! I didn't notice this before. Do you really need this empty event?
Why not just use the function tracer for this? It should work.

If you really need something like this, maybe I'll add a
DEFINE_EVENT_NOARGS() that will not require arguments and can eliminate
a lot of code that TRACE_EVENT() adds.

-- Steve


