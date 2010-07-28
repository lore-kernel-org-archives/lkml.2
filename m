Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab0G1OJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 10:09:52 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38861 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab0G1OJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 10:09:48 -0400
From: Andi Kleen <andi@firstfloor.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: ak@linux.intel.com, konrad.wilk@oracle.com, akataria@vmware.com,
        lenb@kernel.org, x86@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, petr@vmware.com
Subject: Re: swiotlb detection should be memory hotplug aware ?
References: <4C49A83C.8070203@linux.intel.com>
	<20100723145945.GA31857@phenom.dumpdata.com>
	<4C49B3F5.3030904@linux.intel.com>
	<20100728190939D.fujita.tomonori@lab.ntt.co.jp>
Date: Wed, 28 Jul 2010 13:09:57 +0200
In-Reply-To: <20100728190939D.fujita.tomonori@lab.ntt.co.jp> (FUJITA
	Tomonori's message of "Wed, 28 Jul 2010 19:10:19 +0900")
Message-ID: <8739v3kgl6.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> writes:
>
>> The other problem is that using only  two bits for the needed address 
>> space is also extremly
>> inefficient (4GB and 16MB on x86). Really want masks everywhere and 
>> optimize for the
>> actual requirements.
>
> swiotlb doesn't allocate GFP_DMA memory. It handles only GFP_DMA32.

I was lumping GFP_DMA and swiotlb together here. The
pci_alloc_consistent() function uses both interchangedly.
They really effectively are the same thing these days
and just separated by historical accident.


> I have a half-baked patch for it. I'll send it later.

The problem are still the *_map users which usually cannot sleep,
and then it's difficult to grow.
For *_alloc it's relatively easy and to some extend already 
implemented.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
