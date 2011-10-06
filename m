Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841Ab1JFT2n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 15:28:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:37560 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab1JFT2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 15:28:42 -0400
X-Authority-Analysis: v=1.1 cv=agqPq5NoKwAPC9P66H7dbYUCjxvmT73as08i4x3aqAA= c=1 sm=0 a=msyzJTVhAHgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=AH-lfbgdtNEcOgX23IsA:9 a=vJcPFCk81GmUwGN446QA:7 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [PATCH RFC V2 3/5] jump_label: if a key has already been
 initialized, don't nop it out
From: Steven Rostedt <rostedt@goodmis.org>
To: Richard Henderson <rth@redhat.com>
Cc: Jason Baron <jbaron@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        peterz@infradead.org
Date: Thu, 06 Oct 2011 15:28:39 -0400
In-Reply-To: <4E8DF870.6010000@redhat.com>
References: <cover.1317506051.git.jeremy.fitzhardinge@citrix.com>
	  <477dead9647029012f93c651f2892ed0e86b89e7.1317506051.git.jeremy.fitzhardinge@citrix.com>
	  <20111003150205.GB2462@redhat.com> <4E89E28C.7010700@goop.org>
	  <20111004141011.GA2520@redhat.com> <4E8B3489.60902@zytor.com>
	  <4E8CF348.4080405@goop.org> <4E8CF385.2080804@zytor.com>
	  <4E8DEB19.1050509@goop.org> <20111006181055.GA2505@redhat.com>
	 <1317925615.4729.14.camel@gandalf.stny.rr.com>
	 <4E8DF870.6010000@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317929321.4729.17.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-06 at 11:50 -0700, Richard Henderson wrote:
> On 10/06/2011 11:26 AM, Steven Rostedt wrote:
>  
> > 
> > That jmp to l_yes should easily be a two byte jump.
> 
> Until the compiler decides to re-order the code.  That's the problem --
> in the general case you do not know how far away the destination is really
> going to be.

Yeah, I was discussing this with Peter Zijlstra on IRC.

> 
> There are a couple of possibilities for improvement:
> 
> (1) Do as Jason suggests above and let the assembler figure out the size
> of the branch that is needed.  Without adding more data to __jump_table,
> you'll want to be extremely careful about checking the two pointers to 
> see what size branch has been installed.

Yeah, that could be done at patch time.


> 
> (2) Always reserve 5 bytes of space, but if the distance is small enough
> patch in a 2-byte jump.  That doesn't help with the icache footprint.

I don't think this one is worth it.

-- Steve

