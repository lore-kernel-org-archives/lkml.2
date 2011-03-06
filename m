Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab1CFCuT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 21:50:19 -0500
Received: from smtp-out.google.com ([74.125.121.67]:28781 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308Ab1CFCuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 21:50:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=CNNfWtnY7hBRWK1mQOYMnpWpjp8PLvubxaG2mR2mOscxqh0Ezum7boPsr+LmXGIhpB
         7ERGTuO1lEFhTBtfp5FA==
Date: Sat, 5 Mar 2011 18:50:11 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Justin Mattock <justinmattock@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: <IRQ> [<ffffffff810c9204>] ?
 __alloc_pages_nodemask+0x622/0x696
In-Reply-To: <AANLkTikaLb_xan2ePfo9JCZ1w7RZ76wF8NUT2tYr0ZD=@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1103051847100.8779@chino.kir.corp.google.com>
References: <AANLkTikaLb_xan2ePfo9JCZ1w7RZ76wF8NUT2tYr0ZD=@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Mar 2011, Justin Mattock wrote:

> [  339.787008] SLUB: Unable to allocate memory on node -1 (gfp=0x20)
> [  339.787008]   cache: kmalloc-8192, object size: 8192, buffer size:
> 8264, default order: 3, min order: 2
> [  339.787008]   kmalloc-8192 debugging increased min order, use
> slub_debug=O to disable.
> [  339.787008]   node 0: slabs: 181, objs: 543, free: 0
> [  339.790575] skbuff alloc of size 3904 failed
> [  339.823775] swapper: page allocation failure. order:2, mode:0x4020
> [  339.823781] Pid: 0, comm: swapper Not tainted 2.6.38-rc7-00143-gd1b152c #7
> [  339.823783] Call Trace:
> [  339.823786]  <IRQ>  [<ffffffff810c9204>] ? __alloc_pages_nodemask+0x622/0x696
> [  339.823811]  [<ffffffffa015a077>] ? ath_rxbuf_alloc+0x29/0x9a [ath]
> [  339.823815]  [<ffffffff810f67cf>] ? new_slab+0x7b/0x1c6
> [  339.823819]  [<ffffffffa015a077>] ? ath_rxbuf_alloc+0x29/0x9a [ath]
> [  339.823823]  [<ffffffff810f6dd6>] ? T.925+0x163/0x29c
> [  339.823827]  [<ffffffff810c4ecc>] ? mempool_destroy+0xf/0x17
> [  339.823832]  [<ffffffffa015a077>] ? ath_rxbuf_alloc+0x29/0x9a [ath]
> [  339.823836]  [<ffffffff810f895a>] ? __kmalloc_track_caller+0xfe/0x190
> 

Order-2 atomic allocations are always going to be difficult since we can't 
do synchronous compaction or reclaim, but I'd try the suggestion shown 
above: boot with slub_debug=O or disable slub debugging so that 
kmalloc-8192 is actually order-1 like it should be.
