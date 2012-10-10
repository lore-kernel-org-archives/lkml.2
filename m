Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769Ab2JJX4o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:56:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:44551 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757629Ab2JJX4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 19:56:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,567,1344236400"; 
   d="scan'208";a="225334558"
Message-ID: <50760B29.4040407@intel.com>
Date: Wed, 10 Oct 2012 16:56:25 -0700
From: Alexander Duyck <alexander.h.duyck@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] x86: Improve 64 bit __phys_addr call performance
References: <20121009185057.15478.86075.stgit@gitlad.jf.intel.com> <20121010135801.GW16230@one.firstfloor.org>
In-Reply-To: <20121010135801.GW16230@one.firstfloor.org>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2012 06:58 AM, Andi Kleen wrote:
>> The second change was to streamline the code by making use of the carry flag
>> on an add operation instead of performing a compare on a 64 bit value.  The
>> advantage to this is that it allows us to reduce the overall size of the call.
>> On my Xeon E5 system the entire __phys_addr inline call consumes 30 bytes and
>> 5 instructions.  I also applied similar logic to the debug version of the
>> function.  My testing shows that the debug version of the function with this
>> patch applied is slightly faster than the non-debug version without the patch.
> Looks good. Thanks. 
>
> Probably should still split the callers though (or have a pa_symbol_fast
> that does not do the check)
>
> -Andi

I hadn't thought of that.  I couldn't drop support for symbols from
__pa, but I can get away with dropping support for regular addresses
from __pa_symbol.

I just submitted a patch to drop support for standard virtual addresses
from __pa_symbol.  I will also submit some patches tomorrow morning for
cleaning up a number of places I had found where we were calling
__pa/virt_to_phys when we should have been calling __pa_symbol.

Thanks,

Alex
