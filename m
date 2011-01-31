Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab1AaDSg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 22:18:36 -0500
Received: from ozlabs.org ([203.10.76.45]:48738 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122Ab1AaDSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 22:18:35 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH] Tracepoints: fix section alignment using pointer array
Date: Mon, 31 Jan 2011 13:48:27 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-24-generic; KDE/4.5.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
References: <20110126222622.GA10794@Krystal>
In-Reply-To: <20110126222622.GA10794@Krystal>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101311348.27501.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jan 2011 08:56:22 am Mathieu Desnoyers wrote:
> Make the tracepoints more robust, making them solid enough to handle compiler
> changes by not relying on anything based on compiler-specific behavior with
> respect to structure alignment. Implement an approach proposed by David Miller:
> use an array of const pointers to refer to the individual structures, and export
> this pointer array through the linker script rather than the structures per se.
> It will consume 32 extra bytes per tracepoint (24 for structure padding and 8
> for the pointers), but are less likely to break due to compiler changes.
> 
> History:
> 
> commit 7e066fb870fcd1025ec3ba7bbde5d541094f4ce1 added the aligned(32) type and
> variable attribute to the tracepoint structures to deal with gcc happily
> aligning statically defined structures on 32-byte multiples.
> 
> commit 15e3540ce2159705f18fad6147ffedf04445ad64 tried to use a 8-byte alignment
> for tracepoint structures by applying both the variable and type attribute to
> tracepoint structures definitions and declarations. It worked fine with gcc
> 4.5.1, but broke with gcc 4.4.4 and 4.4.5.
> 
> The reason is that the "aligned" attribute only specify the _minimum_ alignment
> for a structure, leaving both the compiler and the linker free to align on
> larger multiples. Because tracepoint.c expects the structures to be placed as an
> array within each section, up-alignment cause NULL-pointer exceptions due to the
> extra unexpected padding.

Hmm, that assumption is used in module parameters too, so we already rely on 
the toolchain not to over-pad.

Perhaps we should fix that too, or wait until it explodes?

Cheers,
Rusty.
