Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab1BBWvW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 17:51:22 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53616
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754442Ab1BBWvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 17:51:21 -0500
Date: Wed, 02 Feb 2011 14:51:57 -0800 (PST)
Message-Id: <20110202.145157.39164499.davem@davemloft.net>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
        fweisbec@gmail.com, mathieu.desnoyers@efficios.com, tglx@linutronix.de,
        peterz@infradead.org, rusty@rustcorp.com.au
Subject: Re: [PATCH 2/2] Tracepoints: Fix section alignment using pointer
 array
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110202180938.471738176@goodmis.org>
References: <20110202180613.978219945@goodmis.org>
	<20110202180938.471738176@goodmis.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>
Date: Wed, 02 Feb 2011 13:06:15 -0500

> From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> 
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
> 
> (this patch applies on top of -tip)
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> LKML-Reference: <20110126222622.GA10794@Krystal>
> CC: David Miller <davem@davemloft.net>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Rusty Russell <rusty@rustcorp.com.au>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Acked-by: David S. Miller <davem@davemloft.net>
