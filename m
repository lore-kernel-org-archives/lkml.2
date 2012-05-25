Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab2EYBls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 21:41:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12653 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090Ab2EYBlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 21:41:47 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=irseqbIK9hsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=AAvYLDLOAAAA:8 a=3q-AJX-PbQ9v123QoqQA:9 a=PUjeQqilurYA:10 a=s2loLT2QvaoA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337910106.13348.234.camel@gandalf.stny.rr.com>
Subject: Re: tracing ring_buffer_resize oops.
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@linux.intel.com>
Date: Thu, 24 May 2012 21:41:46 -0400
In-Reply-To: <1337909963.13348.232.camel@gandalf.stny.rr.com>
References: <20120524160146.GA6226@redhat.com>
	 <1337876398.13348.178.camel@gandalf.stny.rr.com>
	 <20120524172223.GA10689@redhat.com>
	 <1337902816.13348.224.camel@gandalf.stny.rr.com>
	 <4FBEC9E6.8040301@linux.intel.com>
	 <1337909963.13348.232.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 21:39 -0400, Steven Rostedt wrote:

> >   Specifically, note that the value of R12 is the same
> > value; R12 is a preserved register and may have been pushed onto the
> > stack by something that wants to save it.
> 
> I don't see R12 as the same value:
> 
> RIP: <ffff88014630a000>
> GS: ffff880148000000
> R12: ffff880145cc0000
> 
> Close but not quite. Even R13 and R15 are close:
> 
> R13: ffff880148008eb8
> R15: ffff88014780cb40
> 
> But this probably does show that the stack is screwed up and did a bad
> iret.
> 

Here's the stack of the first time I saw this crash:

RIP: 92dc:[<ffff88007dc042a0>]  [<ffff88007dc042a0>] 0xffff88007dc0429f
RSP: 0018:0000000000000576  EFLAGS: 00000575
RAX: 0000000000000001 RBX: ffffffff812b4e6e RCX: ffff88007e209e00
RDX: 0000000000005495 RSI: ffffffff826165b0 RDI: ffff88007e209eb8
RBP: ffff88007e209ed8 R08: 0000000000000000 R09: 0000000000000000
R10: ffff880078d6fa00 R11: ffff880078d6fa00 R12: ffff880078c3dfa0
R13: ffffffff810b92dc R14: 00000000000000e6 R15: 00000000000000e8
FS:  0000000000000000(0000) GS:ffff88007e200000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffff88007dc042a0 CR3: 0000000069ec4000 CR4: 00000000000007f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

RCX, RDI, RBP, R10, R11, and R12 are all like GS and RIP.

-- Steve


