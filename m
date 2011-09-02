Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301Ab1IBHb2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 03:31:28 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59945 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab1IBHbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 03:31:24 -0400
User-Agent: Microsoft-Entourage/12.30.0.110427
Date: Fri, 02 Sep 2011 08:31:16 +0100
Subject: Re: [Xen-devel] Re: [Revert] Re: [PATCH] mm: sync vmalloc address
 space page tables in alloc_vm_area()
From: Keir Fraser <keir.xen@gmail.com>
To: Ian Campbell <Ian.Campbell@citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        David Vrabel <david.vrabel@citrix.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Message-ID: <CA8644D4.20348%keir.xen@gmail.com>
Thread-Topic: [Xen-devel] Re: [Revert] Re: [PATCH] mm: sync vmalloc address
 space page tables in alloc_vm_area()
Thread-Index: AcxpQkyN6Y7ZjHhdY0KuxuwbyOI3oA==
In-Reply-To: <1314948154.28989.158.camel@zakaz.uk.xensource.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2011 08:22, "Ian Campbell" <Ian.Campbell@citrix.com> wrote:

> On Thu, 2011-09-01 at 21:37 +0100, Jeremy Fitzhardinge wrote:
>> On 09/01/2011 09:11 AM, Konrad Rzeszutek Wilk wrote:
>>> On Thu, Sep 01, 2011 at 12:51:03PM +0100, David Vrabel wrote:
>>>> From: David Vrabel <david.vrabel@citrix.com>
>>> Andrew,
>>> 
>>> I was wondering if you would be Ok with this patch for 3.1.
>>> 
>>> It is a revert (I can prepare a proper revert if you would like
>>> that instead of this patch).
>>> 
>>> The users of this particular function (alloc_vm_area) are just
>>> Xen. There are no others.
>> 
>> I'd prefer to put explicit vmalloc_sync_all()s in the callsites where
>> necessary, and ultimately try to work out ways of avoiding it altogether
>> (like have some hypercall wrapper which touches the arg memory to make
>> sure its mapped?).
> 
> That only syncs the current pagetable though. If that is sufficient (and
> it could well be) then perhaps just doing a vmalloc_sync_one on the
> current page tables directly would be better than faulting to do it?

It's probably sufficient unless the kernel has non-voluntary preemption, and
we are not preempt_disable()d.

 -- Keir

> It's the sort of thing you could hide inside the gnttab_set_map_op type
> helpers I guess?
> 
> Ian.
> 
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel


