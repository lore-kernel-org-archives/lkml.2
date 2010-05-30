Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab0E3ODK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 10:03:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:56325 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab0E3ODH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 10:03:07 -0400
X-Authority-Analysis: v=1.1 cv=muTmBHIsIIrvj5np50lvqqEF3x9MmSj/zDSU9q1ni6E= c=1 sm=0 a=PjWTFMnUE30A:10 a=0qYQvVkOOIcA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=kzOCOh0lTtS9Sebl23QA:9 a=DVCLZePkM4oDTsG0K9D-rC4YKDwA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
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
       Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
       Johannes Berg <johannes.berg@intel.com>,
       Darren Hart <darren@dvhart.com>
In-Reply-To: <4C021D7E.1060705@redhat.com>
References: <20100526123443.GB8905@stefan-thinkpad.transitives.com>
	 <AANLkTil8BiuzrmacV7Lpx1wES0EvLSiVmcfwtSY6Zis2@mail.gmail.com>
	 <1275083157.22648.593.camel@gandalf.stny.rr.com>
	 <4C00FF9B.9000107@redhat.com>
	 <1275139177.22648.610.camel@gandalf.stny.rr.com>
	 <4C021D7E.1060705@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Sun, 30 May 2010 10:03:02 -0400
Message-ID: <1275228182.15884.1.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-05-30 at 11:10 +0300, Avi Kivity wrote:
> On 05/29/2010 04:19 PM, Steven Rostedt wrote:
>     
> > The pretty printing from the kernel handles this fine. But there's
> > pressure to pass the format to userspace in binary and have the tool
> > parse it. Currently it uses the print fmt to figure out how to parse.
> >
> > Using one of the examples that Stefan showed:
> >
> > kvmmmu/kvm_mmu_get_page: print fmt: "%s %s", ({ const char *ret =
> > p->buffer + p->len; static const char *access_str[] = { "---", "--x",
> > "w--", "w-x", "-u-", "-ux", "wu-", "wux" }; union kvm_mmu_page_role
> > role; role.word = REC->role; trace_seq_printf(p, "sp gfn %llx %u%s q%u%s
> > %s%s" " %snxe root %u %s%c", REC->gfn, role.level, role.cr4_pae ? "
> > pae" : "", role.quadrant, role.direct ? " direct" : "",
> > access_str[role.access], role.invalid ? " invalid" : "", role.nxe ? "" :
> > "!", REC->root_count, REC->unsync ? "unsync" : "sync", 0); ret; }),
> > REC->created ? "new" : "existing"
> >
> >
> > You need a full C parser/interpreter to understand the above.
> >    
> 
> Right.  The tools can fall back to %x/%s based on the structure 
> descriptor if they can't parse the format string.
> 

trace-cmd has plugin support to override how to read the format and
print it out. It now has the ability to write those plugins in python.

-- Steve


