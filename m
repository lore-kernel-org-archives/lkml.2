Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab1AVAEn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 19:04:43 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54346
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755013Ab1AVAEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 19:04:41 -0500
Date: Fri, 21 Jan 2011 16:05:16 -0800 (PST)
Message-Id: <20110121.160516.256850550.davem@davemloft.net>
To: mathieu.desnoyers@efficios.com
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@elte.hu, richm@oldelvet.org.uk, ben@decadent.org.uk,
        sparclinux@vger.kernel.org
Subject: Re: [patch 3/3] tracepoints: use __u64_aligned/U64_ALIGN()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110121203643.046218322@efficios.com>
References: <20110121203630.725922272@efficios.com>
	<20110121203643.046218322@efficios.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Fri, 21 Jan 2011 15:36:33 -0500

> commit 7e066fb870fcd1025ec3ba7bbde5d541094f4ce1 added the aligned(32) type and
> variable attribute to the tracepoint structures to deal with gcc happily
> aligning statically defined structures on 32-byte multiples.
> 
> Working on issues within Ftrace, we came up with __64_aligned, which deals with
> this issue more elegantly by forcing an 8-byte alignment to both the type
> declaration and variable definition.
> 
> This therefore saves space, bringing down the size of struct tracepoint from 64
> bytes to 38 on 64-bit architectures.
> 
> Updating:
> - The type attribute (for iteration over the struct tracepoint array)
> - Added the variable attribute to the extern definition (needed to force gcc to
>   consider this alignment for the following definition)
> - The definition variable attribute (to force gcc to this specific alignment for
>   the static definitions)
> - The linker script (8-byte alignment can now replace the previous 32-byte
>   alignment for the custom tracepoint section)
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

Acked-by: David S. Miller <davem@davemloft.net>
