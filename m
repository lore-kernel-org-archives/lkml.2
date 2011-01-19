Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956Ab1ASFQH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 00:16:07 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47489
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752566Ab1ASFQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 00:16:06 -0500
Date: Tue, 18 Jan 2011 21:16:39 -0800 (PST)
Message-Id: <20110118.211639.68142725.davem@davemloft.net>
To: mathieu.desnoyers@efficios.com
Cc: rostedt@goodmis.org, richm@oldelvet.org.uk, 609371@bugs.debian.org,
        ben@decadent.org.uk, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@redhat.com
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
 Unknown relocation: 36
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110119050844.GA8776@Krystal>
References: <20110118201323.GA14930@Krystal>
	<1295382144.12215.123.camel@gandalf.stny.rr.com>
	<20110119050844.GA8776@Krystal>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Wed, 19 Jan 2011 00:08:45 -0500

> The following works fine for me now. Comments are welcome.

Thanks for doing this work Mathieu.

> - No aligned() type attribute nor variable attribute. I get a crash on x86_64
>   (NULL pointer exception when executing __trace_add_event_call, the 5th call).
>   __alignof__(struct ftrace_event_call) is worth 8.

This is really bizarre.  Does it only happen on x86_64?

I'm wondering if GCC does something bizarre like work with different
default alignments based upon the section or something like that.

If so, maybe adding the section attribute to the array definition will
"fix" things?

> On 32-bit architectures, we really want a aligned(4), and on 64-bit
> architectures, aligned(8). Represent this by creating:
> 
> #define __long_aligned __attribute__((__aligned__(__alignof__(long))))

Do any of these datastructures have, or will have, "u64" or "long
long" types in them?  If so, then we will need to use "8"
unconditionally or "__alignof__(long long)".

I'll see if I can work out why using no align directive explodes
on x86-64.
