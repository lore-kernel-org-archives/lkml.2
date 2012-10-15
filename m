Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663Ab2JOI5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 04:57:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300Ab2JOI5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 04:57:09 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20121014085617.GA22544@gmail.com>
References: <20121014085617.GA22544@gmail.com> <11002.1350125310@warthog.procyon.org.uk> <CA+55aFzu83ktX=ereRACNa6stEU0H5vNxKObUN9bymYCCaHyew@mail.gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        paulus@samba.org, davem@davemloft.net, jaxboe@fusionio.com,
        tj@kernel.org, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] perf: Fix UAPI fallout
Date: Mon, 15 Oct 2012 09:56:22 +0100
Message-ID: <13954.1350291382@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@kernel.org> wrote:

> Arnaldo: the way we include some of the include files directly 
> into tools/perf/ .c files [such as hw_breakpoint.h] and 
> represent others transparently via utils/include/ [such as 
> rbtree.h] is a bit messy and ought to be cleaned up I suspect.

I tried to make the USERINCLUDE macro in the bottom-level Makefile that, but I
didn't realise I had to export it:-(.

That, however, also brings in linux/kconfig.h but I don't know whether you
want/need that.

> I think the best model would be to cleanly separate from any 
> /usr/include/linux/ muck, which might be out of sync, and which 
> might stand in the way of changes. Is it possible to exclude all 
> of /usr/include/ and try to build purely from 
> include/uapi/linux/

You would also need arch/foo/include/uapi/.

David
