Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab1CJXQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 18:16:17 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60955 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab1CJXQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 18:16:16 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=UwRGqXM3h7MA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=SuM4_1V_KodVBf8Yg6MA:9 a=yFuhyx863oKDDuwGEa0A:7 a=6VOhQCK9ldrzQInJiVz70l7T8IQA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/2] jump label: update for .39
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: David Daney <ddaney@caviumnetworks.com>, Jason Baron <jbaron@redhat.com>,
        peterz@infradead.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
In-Reply-To: <BLU0-SMTP101D168109508CC1B82F0E496C80@phx.gbl>
References: <1299780241.15854.393.camel@gandalf.stny.rr.com>
	 <20110310182000.GB2906@redhat.com>
	 <1299782143.15854.402.camel@gandalf.stny.rr.com>
	 <4D791CAA.7090108@caviumnetworks.com>
	 <1299783236.15854.405.camel@gandalf.stny.rr.com>
	 <4D791F31.6040100@caviumnetworks.com>
	 <1299785143.15854.407.camel@gandalf.stny.rr.com>
	 <1299786329.15854.409.camel@gandalf.stny.rr.com>
	 <BLU0-SMTP311155BEBE5F141636A6E596C80@phx.gbl>
	 <1299793339.15854.430.camel@gandalf.stny.rr.com>
	 <BLU0-SMTP101D168109508CC1B82F0E496C80@phx.gbl>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 10 Mar 2011 18:16:10 -0500
Message-ID: <1299798970.15854.484.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-10 at 17:48 -0500, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > On Thu, 2011-03-10 at 16:22 -0500, Mathieu Desnoyers wrote:
> > 
> > > > Anyway, I think the best thing for now is to have Jason add
> > > > the .align(sizeof(long)) in the inline assembly for all locations and be
> > > > done with it.
> > > 
> > > You seem to be contradicting yourself here. I'm concerned about having
> > > "structures" of a size not power of two. Can we simply either
> > 
> > But we don't have structures. We have data that has been allocated in
> > assembly. Come to think of it, it may be best to keep these as 
> > ".align 4".
> 
> The .align 4 is certainly not the right answer, because it will trigger
> unaligned accesses on some 64-bit architectures, as we have faced with
> trace event.

Will it? Seems that sparc does this regardless.

Remember, this is 3 natural word sized objects, and vmlinux.ld starts
the section off with .ALIGN 8, hence, the section is already 8 byte
aligned, all objects within this section are 8 bytes (for 64bit archs,
and 4 bytes for 32bit), why would saying ".align 4" cause the linker to
add holes to make it 4 byte aligned when it is already 8 byte aligned.
The ".align 4" should work with both 32bit and 64bit archs.

-- Steve


