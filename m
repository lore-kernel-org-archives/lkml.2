Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933302Ab1JDSFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 14:05:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35579 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932969Ab1JDSFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 14:05:54 -0400
X-Authority-Analysis: v=1.1 cv=cSzO76bR5tCkfUT9bEmBgR3d7VUusRLeq08eKGxa4EU= c=1 sm=0 a=msyzJTVhAHgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=3Hg23OBV5lzhnHel5ewA:9 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [PATCH RFC V2 3/5] jump_label: if a key has already been
 initialized, don't nop it out
From: Steven Rostedt <rostedt@goodmis.org>
To: Jason Baron <jbaron@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        peterz@infradead.org
Date: Tue, 04 Oct 2011 14:05:51 -0400
In-Reply-To: <20111004175312.GC2520@redhat.com>
References: <cover.1317506051.git.jeremy.fitzhardinge@citrix.com>
	 <477dead9647029012f93c651f2892ed0e86b89e7.1317506051.git.jeremy.fitzhardinge@citrix.com>
	 <20111003150205.GB2462@redhat.com> <4E89E28C.7010700@goop.org>
	 <20111004141011.GA2520@redhat.com> <4E8B3489.60902@zytor.com>
	 <20111004175312.GC2520@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317751553.18063.12.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-04 at 13:53 -0400, Jason Baron wrote:
> On Tue, Oct 04, 2011 at 09:30:01AM -0700, H. Peter Anvin wrote:
> > On 10/04/2011 07:10 AM, Jason Baron wrote:
> > > 
> > > 1) The jmp +0, is a 'safe' no-op that I know is going to initially
> > > boot for all x86. I'm not sure if there is a 5-byte nop that works on
> > > all x86 variants - but by using jmp +0, we make it much easier to debug
> > > cases where we may be using broken no-ops.
> > > 
> > 
> > There are *plenty*.  jmp+0 is about as pessimal as you can get.
> > 
> > The current recommendation when you don't know the CPU you're running at is:
> > 
> > 	3E 8D 74 26 00	(GENERIC_NOP5_ATOMIC)
> > 
> > ... on 32 bits and ...
> > 
> > 	0F 1F 44 00 00	(P6_NOP5_ATOMIC)
> > 
> > ... on 64 bits.
> > 
> > 	-hpa
> > 
> 
> We're currently patching the code at run-time (boot and module load
> time), with the 'ideal' no-op anyway, so the initial no-op doesn't
> really matter much (other than to save patching if the initial and ideal
> match).

Out of correctness, we should still update this to use the proper
"default" nops, as mcount already does.

-- Steve


