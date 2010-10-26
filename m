Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759931Ab0JZOvG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 10:51:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10620 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756652Ab0JZOvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 10:51:03 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4CC6C62F.1000804@kernel.org>
References: <4CC6C62F.1000804@kernel.org> <4CC69B22.2050708@kernel.org> <20101025224111.7798.38960.stgit@warthog.procyon.org.uk> <12101.1288088542@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
        linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH] MN10300: Fix the PERCPU() alignment to allow for workqueues
Date: Tue, 26 Oct 2010 15:50:42 +0100
Message-ID: <14874.1288104642@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> wrote:

> Ah, I see now.  The actual areas are properly aligned but the percpu
> address is determined as offset from the percpu output section base so
> the percpu pointers in the percpu address space end up misaligned with
> the actual kernel addresses and the code in workqueue checks the
> address in percpu AS, so, yeap, it's caused by the misalignment of the
> percpu section. 

Okay, I see that.

> > FRV's page size is 16KB, so on that we really don't want it to be
> > PAGE_SIZE.
> 
> Why not?  It's in the init section which will be freed anyway and with
> the kernel image compression it's not even gonna add any noticeable
> amount to the kernel image size.  There isn't any benefit in using
> anything smaller than PAGE_SIZE for alignment.  Also, percpu allocator
> guarantees alignment requirement upto PAGE_SIZE is honored.  If the
> output section uses smaller alignment, the percpu AS will end up being
> misaligned.

The bootloader we have doesn't do decompression.  On the other hand, does the
PERCPU stuff need to be allocated space in the image by the linker?  Can it be
initialised to anything other than zeros?

David
