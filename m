Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab0JYVrk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 17:47:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171Ab0JYVrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 17:47:39 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <AANLkTi=_siOR8QtXdW07ZY1mFG9_A2806erd64cRNRCb@mail.gmail.com>
References: <AANLkTi=_siOR8QtXdW07ZY1mFG9_A2806erd64cRNRCb@mail.gmail.com> <20101025212706.27798.23957.stgit@warthog.procyon.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, akpm@linux-foundation.org, Tejun Heo <tj@kernel.org>,
        linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH] workqueue: Fix alignment calculation in alloc_cwqs()
Date: Mon, 25 Oct 2010 22:46:53 +0100
Message-ID: <3487.1288043213@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> No it doesn't. Those bits really require that many bytes of alignment.
> 
> Think about it: if the low 8 bits of the pointer are used for flags,
> then the actual pointer itself needs to be aligned to a 256-byte
> boundary.
> 
> So the code is right. If needs to ask for "1 << WORK_STRUCT_FLAG_BITS"
> alignment, and if it doesn't get it (because the allocator is somehow
> broken - percpu allocator issues?), things will break.

That's a good point.

David
