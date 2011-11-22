Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763Ab1KVBAF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 20:00:05 -0500
Received: from ozlabs.org ([203.10.76.45]:38021 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757660Ab1KVA74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 19:59:56 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Pawel Moll <pawel.moll@arm.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization\@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH] virtio-mmio: Devices parameter parsing
In-Reply-To: <1321898210.3093.263.camel@hornet.cambridge.arm.com>
References: <1321365185-2928-1-git-send-email-pawel.moll@arm.com> <87sjlooq3m.fsf@rustcorp.com.au> <1321467222.3137.417.camel@hornet.cambridge.arm.com> <87vcqe9ml9.fsf@rustcorp.com.au> <1321886688.3093.248.camel@hornet.cambridge.arm.com> <1321898210.3093.263.camel@hornet.cambridge.arm.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 22 Nov 2011 11:23:31 +1030
Message-ID: <87fwhhx9is.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Nov 2011 17:56:50 +0000, Pawel Moll <pawel.moll@arm.com> wrote:
> On Mon, 2011-11-21 at 14:44 +0000, Pawel Moll wrote:
> > I'll post v3 tonight or tomorrow.
> 
> Ok, it won't be v3 then...
> 
> I tried again, using your suggestions - see below (just the crucial bit,
> however I have the kernel-parameters.txt bits ready as well). Parsing
> works like charm, however when it gets to device_register() and
> platform_device_register_resndata() I hit the same problem as
> previously. Both are using slab allocator...
> 
> device_register()->device_add()->device_private_init()->kzalloc()
> 
> and
> 
> platform_device_register_resndata()->platform_device_register_full()->
> platform_device_alloc()->kzalloc().
> 
> Essentially it seems that the parameter callbacks are just executed
> waaay to early to do more than just set few integers here and there...
> 
> Any ideas?

Rewrite the kernel and every arch so allocators work as soon as we hit
start_kernel() and we can get rid of hundreds of ugly workarounds?

Perhaps not today.  So, we will need a linked list of devices and
resources.  Yeah, that means allocating, which means YA
slab_is_available()/alloc_bootmem() hack.

Think of yourself as a pioneer...

Thanks :)
Rusty.
