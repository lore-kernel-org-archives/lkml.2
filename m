Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab1CJSfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 13:35:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:39884 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab1CJSfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 13:35:47 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=UwRGqXM3h7MA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=QsmbaZE8cOQEOL0Q0m4A:9 a=8NzlN7xuRiRQp2dYbVAA:7 a=cpaBFiRcoKq7Mv6ODynZvBTy8hkA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/2] jump label: update for .39
From: Steven Rostedt <rostedt@goodmis.org>
To: Jason Baron <jbaron@redhat.com>
Cc: David Daney <ddaney@caviumnetworks.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, peterz@infradead.org,
        hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, michael@ellerman.id.au, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>
In-Reply-To: <20110310182000.GB2906@redhat.com>
References: <cover.1299702291.git.jbaron@redhat.com>
	 <1299728191.15854.319.camel@gandalf.stny.rr.com>
	 <BLU0-SMTP690BB959832A97E002293396C80@phx.gbl>
	 <1299771504.15854.347.camel@gandalf.stny.rr.com>
	 <4D790A13.4060705@caviumnetworks.com>
	 <1299780241.15854.393.camel@gandalf.stny.rr.com>
	 <20110310182000.GB2906@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 10 Mar 2011 13:35:43 -0500
Message-ID: <1299782143.15854.402.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-10 at 13:20 -0500, Jason Baron wrote:
> On Thu, Mar 10, 2011 at 01:04:01PM -0500, Steven Rostedt wrote:
> Now its up to the linker to decide where to place that element. Can we
> > guarantee that it will always be on an 8 byte boundery?
> > Hmm, I wonder if we could add a .ALIGN sizeof(long) before that?
> > 
> 
> we can. Sparc does it, see: arch/sparc/include/asm/jump_label.h.
> 
> So I guess it would be .align 8 for 64-bit and .align 4 for 32-bit...

Now what about the vmlinux.ld? That has a align 8. Is that a one time
short (align to 8 bytes here), or will it carry through aligning the
rest of the section. If not, perhaps we may be OK.

-- Steve


