Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab1GTOjn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 10:39:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:10701 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969Ab1GTOjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 10:39:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,235,1309762800"; 
   d="scan'208";a="29866076"
Message-ID: <4E26E8AC.7080407@intel.com>
Date: Wed, 20 Jul 2011 07:39:40 -0700
From: Darren Hart <darren.hart@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Shan Hai <haishan.bai@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@samba.org,
        tglx@linutronix.de, walken@google.com, dhowells@redhat.com,
        cmetcalf@tilera.com, tony.luck@intel.com, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] mm/futex: Fix futex writes on archs with SW tracking
 of dirty & young
References: <1310717238-13857-1-git-send-email-haishan.bai@gmail.com>	 <1310717238-13857-2-git-send-email-haishan.bai@gmail.com>	 <1310725418.2586.309.camel@twins> <4E21A526.8010904@gmail.com>	 <1310860194.25044.17.camel@pasglop>	 <4b337921-d430-4b63-bc36-ad31753cf800@email.android.com>	 <1310912990.25044.203.camel@pasglop>  <1310944453.25044.262.camel@pasglop>	 <1310961691.25044.274.camel@pasglop>  <4E23D728.7090406@gmail.com>	 <1310972462.25044.292.camel@pasglop>  <4E23E02C.8090401@gmail.com>	 <1310974591.25044.298.camel@pasglop>  <4E24FA51.70602@gmail.com> <1311049762.25044.392.camel@pasglop>
In-Reply-To: <1311049762.25044.392.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Obviously no objection from the futex side of things, looks good. Couple
nits on the function comment:

On 07/18/2011 09:29 PM, Benjamin Herrenschmidt wrote:
...
> -/**
> +/*
> + * fixup_user_fault() - manually resolve a user page  fault

s/  fault/ fault/

> + * @tsk:	the task_struct to use for page fault accounting, or
> + *		NULL if faults are not to be recorded.
> + * @mm:		mm_struct of target mm
> + * @address:	user address
> + * @fault_flags:flags to pass down to handle_mm_fault()
> + *
> + * This is meant to be called in the specific scenario where for
> + * locking reasons we try to access user memory in atomic context
> + * (within a pagefault_disable() section), this returns -EFAULT,
> + * and we want to resolve the user fault before trying again.
> + *
> + * Typically this is meant to be used by the futex code.
> + *
> + * The main difference with get_user_pages() is that this function
> + * will unconditionally call handle_mm_fault() which will in turn
> + * perform all the necessary SW fixup of the dirty and young bits
> + * in the PTE, while handle_mm_fault() only guarantees to update
> + * these in the struct page.
> + *
> + * This is important for some architectures where those bits also
> + * gate the access permission to the page because their are

s/their/they/

Thanks,

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
