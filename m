Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab0KXPxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 10:53:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35323 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab0KXPxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 10:53:20 -0500
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=UaNWXry1k3EA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=9BLoJqIw0YXVjHMsbR0A:9 a=ghHzuzem5yuU0U_0ey8A:7 a=Lc3kKYUrsbOrM-8lyy6OeozBrGcA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 1/3] jump label: add enabled/disabled state to jump
 label key entries
From: Steven Rostedt <rostedt@goodmis.org>
To: Jason Baron <jbaron@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
        mathieu.desnoyers@polymtl.ca, hpa@zytor.com, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, ddaney@caviumnetworks.com,
        michael@ellerman.id.au, linux-kernel@vger.kernel.org
In-Reply-To: <20101124154200.GD2815@redhat.com>
References: <cover.1290546539.git.jbaron@redhat.com>
	 <d03959060763fecdf2523a3f1353e1fc59f8f4a1.1290546539.git.jbaron@redhat.com>
	 <1290586809.2072.424.camel@laptop> <20101124145401.GA2815@redhat.com>
	 <1290611478.2072.482.camel@laptop> <20101124151936.GB2815@redhat.com>
	 <1290612245.2072.486.camel@laptop>  <20101124154200.GD2815@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 24 Nov 2010 10:53:17 -0500
Message-ID: <1290613997.30543.529.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-24 at 10:42 -0500, Jason Baron wrote:

> > And I think the only arch where you can do text pokes without cross-cpu
> > synchronization is one that doesn't have SMP support.
> > 
> > 
> 
> is this really true?
> 
> The powerpc implementation uses patch_instruction():
> 
> 
> arch/powerpc/lib/code-patching.c:
> 
> void patch_instruction(unsigned int *addr, unsigned int instr)
> {
>         *addr = instr;
>         asm ("dcbst 0, %0; sync; icbi 0,%0; sync; isync" : : "r"
> (addr));
> }

Is this ever called outside of boot up? After SMP is enabled? (besides
for creating trampolines, before they are used).

-- Steve


