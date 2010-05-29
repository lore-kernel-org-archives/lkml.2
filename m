Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab0E2NTq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 09:19:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:52893 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755449Ab0E2NTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 09:19:41 -0400
X-Authority-Analysis: v=1.1 cv=WC2cwRI/KXdLNEmE8ivg2cmI8vFt6dWmaZdvaJ93QHU= c=1 sm=0 a=PjWTFMnUE30A:10 a=0qYQvVkOOIcA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=23XsJ7uutmLIwl2UcYgA:9 a=HzwmlPrqjGwKzqmlLrYA:7 a=flhqLhW7V6fB4dyT7cUjMr3KWB0A:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: Perf trace event parse errors for KVM events
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Avi Kivity <avi@redhat.com>
Cc: Stefan Hajnoczi <stefanha@gmail.com>, linux-perf-users@vger.kernel.org,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
In-Reply-To: <4C00FF9B.9000107@redhat.com>
References: <20100526123443.GB8905@stefan-thinkpad.transitives.com>
	 <AANLkTil8BiuzrmacV7Lpx1wES0EvLSiVmcfwtSY6Zis2@mail.gmail.com>
	 <1275083157.22648.593.camel@gandalf.stny.rr.com>
	 <4C00FF9B.9000107@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Sat, 29 May 2010 09:19:37 -0400
Message-ID: <1275139177.22648.610.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-05-29 at 14:50 +0300, Avi Kivity wrote:
> On 05/29/2010 12:45 AM, Steven Rostedt wrote:
> > On Fri, 2010-05-28 at 17:42 +0100, Stefan Hajnoczi wrote:
> >    
> >> I get parse errors when using Steven Rostedt's trace-cmd tool, too.
> >>
> >> Any ideas what is going on here?  I can provide more info (e.g. trace
> >> files) if necessary.
> >>      
> > Does trace-cmd fail on the same tracepoints? Have you checkout the
> > latest code?.
> >
> > I do know it fails on some of the KVM tracerpoints since the formatting
> > they use is obnoxious.
> >
> >    
> 
> Isn't there a binary trace for this?
> 

The pretty printing from the kernel handles this fine. But there's
pressure to pass the format to userspace in binary and have the tool
parse it. Currently it uses the print fmt to figure out how to parse.

Using one of the examples that Stefan showed:

kvmmmu/kvm_mmu_get_page: print fmt: "%s %s", ({ const char *ret =
p->buffer + p->len; static const char *access_str[] = { "---", "--x",
"w--", "w-x", "-u-", "-ux", "wu-", "wux" }; union kvm_mmu_page_role
role; role.word = REC->role; trace_seq_printf(p, "sp gfn %llx %u%s q%u%s
%s%s" " %snxe root %u %s%c", REC->gfn, role.level, role.cr4_pae ? "
pae" : "", role.quadrant, role.direct ? " direct" : "",
access_str[role.access], role.invalid ? " invalid" : "", role.nxe ? "" :
"!", REC->root_count, REC->unsync ? "unsync" : "sync", 0); ret; }),
REC->created ? "new" : "existing"


You need a full C parser/interpreter to understand the above.

-- Steve


