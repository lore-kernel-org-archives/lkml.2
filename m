Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933143Ab1JDRxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 13:53:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932845Ab1JDRxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 13:53:37 -0400
Date: Tue, 4 Oct 2011 13:53:12 -0400
From: Jason Baron <jbaron@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        peterz@infradead.org
Subject: Re: [PATCH RFC V2 3/5] jump_label: if a key has already been
 initialized, don't nop it out
Message-ID: <20111004175312.GC2520@redhat.com>
References: <cover.1317506051.git.jeremy.fitzhardinge@citrix.com>
 <477dead9647029012f93c651f2892ed0e86b89e7.1317506051.git.jeremy.fitzhardinge@citrix.com>
 <20111003150205.GB2462@redhat.com>
 <4E89E28C.7010700@goop.org>
 <20111004141011.GA2520@redhat.com>
 <4E8B3489.60902@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8B3489.60902@zytor.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 04, 2011 at 09:30:01AM -0700, H. Peter Anvin wrote:
> On 10/04/2011 07:10 AM, Jason Baron wrote:
> > 
> > 1) The jmp +0, is a 'safe' no-op that I know is going to initially
> > boot for all x86. I'm not sure if there is a 5-byte nop that works on
> > all x86 variants - but by using jmp +0, we make it much easier to debug
> > cases where we may be using broken no-ops.
> > 
> 
> There are *plenty*.  jmp+0 is about as pessimal as you can get.
> 
> The current recommendation when you don't know the CPU you're running at is:
> 
> 	3E 8D 74 26 00	(GENERIC_NOP5_ATOMIC)
> 
> ... on 32 bits and ...
> 
> 	0F 1F 44 00 00	(P6_NOP5_ATOMIC)
> 
> ... on 64 bits.
> 
> 	-hpa
> 

We're currently patching the code at run-time (boot and module load
time), with the 'ideal' no-op anyway, so the initial no-op doesn't
really matter much (other than to save patching if the initial and ideal
match).

-Jason
