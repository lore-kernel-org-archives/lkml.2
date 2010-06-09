Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157Ab0FISvX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 14:51:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18409 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758085Ab0FISvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 14:51:22 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.2.00.1006090945531.4506@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1006090945531.4506@i5.linux-foundation.org> <20100609161909.18222.78028.stgit@warthog.procyon.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FRV: Implement the GDB remote protocol 'p' command to retrieve a register
Date: Wed, 09 Jun 2010 19:50:46 +0100
Message-ID: <21653.1276109446@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > Implement the GDB remote protocol 'p' command to retrieve a single register
> > value.
> 
> Is there any value to this? Apparently it used to work just because that 
> command never did anything (rather than return an error). Why not just 
> reinstate that behavior instead?

That's a reasonable argument.  The 'p' command would be more efficient if gdb
uses it when required to get single values, but once it has decided to use the
'g' command, it seems to stick with it.

> There's doesn't seem to be any reason to implement the single-register 
> case unless there is some legacy use of it. There's a good reason gdb 
> tends to use the "register block" thing, and it tends to be easier to 
> implement too (no crazy case statements etc).

It's slower to use 'g', however, if we only want the value in one register,
and I'm usually doing gdb protocol over serial.

However, as stated above, once it's decided to use 'g', gdb doesn't seem to
want to use 'p' any more.

David
