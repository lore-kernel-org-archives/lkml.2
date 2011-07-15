Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787Ab1GOPcv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 11:32:51 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33641 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab1GOPcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 11:32:50 -0400
Message-ID: <4E205D96.7010109@gmail.com>
Date: Fri, 15 Jul 2011 11:32:38 -0400
From: Shan Hai <haishan.bai@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: David Laight <David.Laight@ACULAB.COM>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, tony.luck@intel.com,
        linux-kernel@vger.kernel.org, cmetcalf@tilera.com, dhowells@redhat.com,
        paulus@samba.org, tglx@linutronix.de, walken@google.com,
        linuxppc-dev@lists.ozlabs.org, akpm@linux-foundation.org
Subject: Re: [PATCH 0/1] Fixup write permission of TLB on powerpc e500 core
References: <AE90C24D6B3A694183C094C60CF0A2F6D8ADFC@saturn3.aculab.com>
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6D8ADFC@saturn3.aculab.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2011 06:32 AM, David Laight wrote:
>
>> The fault causing futex_atomic_cmpxchg_inatomic() is
>> protected by pagefault_disable(), so the page fault handler has
>> no chance to toggle the SW dirty/young tracking.
> Perhaps that is the bug!
> Whatever pagefault_disable() does, it shouldn't disable the
> SW dirty/young tracking - which should only needs bits moving
> in the page table itself (and TLB update??) rather than any
> operations on the rest of the data areas.
>
> It looks to me as though this could happen any time a page
> is marked inaccessible by the dirty/young tracking.
> Not just as a result of COW.
>

I agree with you, the problem could be triggered by accessing
any user space page which has kernel read only permission
in the page fault disabled context, the problem also affects
architectures which depend on SW dirty/young tracking as
stated by Benjamin in this thread.

In the e500 case, the commit 6cfd8990e27d3a491c1c605d6cbc18a46ae51fef
removed the write permission fixup from TLB miss handlers and left it to
generic code, so it might be right time to fixup the write permission here
in the generic code.


Thanks
Shan Hai

> 	David
>
>

