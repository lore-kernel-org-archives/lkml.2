Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758311Ab2BITXN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 14:23:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15049 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140Ab2BITXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 14:23:11 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CA+55aFzePmV8st-PaQeO_eS05CUWQePDoQsXdd=HaiLffz+wxw@mail.gmail.com>
References: <CA+55aFzePmV8st-PaQeO_eS05CUWQePDoQsXdd=HaiLffz+wxw@mail.gmail.com> <20120209154819.32070.93358.stgit@warthog.procyon.org.uk> <1328804920.6099.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <CA+55aFxHdFa4otDWJg4f+8sKEP3MBZqKBQCnH0Q8LXYtpdt1EA@mail.gmail.com> <CA+55aFyw1n=Bz3vi73RD5R13HyWLaVyPZc_z5rR7nGPzvs-BOw@mail.gmail.com> <7095.1328809567@redhat.com> <CA+55aFw5z85wuU8xJ_YFp0QB653yAGPOqeGXhJLbdj9ogpHqOA@mail.gmail.com> <8689.1328810841@redhat.com> <CA+55aFwxTe6+zng6OnK_oHBxwLsX+Z7wD45d=XLTGSL+6aoh9g@mail.gmail.com> <21276.1328813456@redhat.com> 
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, Eric Dumazet <eric.dumazet@gmail.com>,
        adobriyan@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Reduce the number of expensive division instructions done by _parse_integer()
Date: Thu, 09 Feb 2012 19:23:03 +0000
Message-ID: <26494.1328815383@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Btw, what was the load that you noticed this on?
> 
> Because quite frankly, I think we only support bases 8/10/16 in the
> kernel, and if you really have some case where this all is expensive,
> it might be better to simply have three different functions for the
> three bases. That would turn the multiplies into constants too, and
> also simplify the character tests.
> 
> That said, I can't really see how this could ever be all that hot a
> function. Did you ever see it in a profile, or was this all just from
> looking at the code?

Just by looking at the code.  I can't think of anything particularly where
this is likely to be encountered in a critical path.

David
