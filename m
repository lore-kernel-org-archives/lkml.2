Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751209Ab1AOHWI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 02:22:08 -0500
Received: from gate.crashing.org ([63.228.1.57]:43571 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043Ab1AOHWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 02:22:06 -0500
Subject: Re: ia64 broken by transparent huge pages - other arches too?
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Luck, Tony" <tony.luck@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org
In-Reply-To: <4d308cf5394566ccc@agluck-desktop.sc.intel.com>
References: <4d308cf5394566ccc@agluck-desktop.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 15 Jan 2011 18:21:36 +1100
Message-ID: <1295076096.4875.60.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-14 at 09:50 -0800, Luck, Tony wrote:
> Didn't Andrew make some rash promise at kernel summit about stopping
> eating if "-mm" wasn't included in linux-next by the end of November?
> 
> Must be getting pretty hungry by now.
> 
> The transparent huge page code just arrived in the merge window
> without having been in linux-next.  I see this error when trying
> to build for ia64 from Linus' tree this morning:

This is insane. Having such a massively invasive change to the whole mm,
barely tested on most architecture, and last I heard still generally
controversial being merged like that without even some integration
testing via -next makes no sense.

Linus, wtf is going on ?

Ben.

> In file included from /home/aegl/generic-smp/arch/ia64/include/asm/pgtable.h:611,
>                  from include/linux/mm.h:41,
>                  from /home/aegl/generic-smp/arch/ia64/include/asm/uaccess.h:39,
>                  from include/linux/poll.h:14,
>                  from include/linux/rtc.h:117,
>                  from include/linux/efi.h:19,
>                  from /home/aegl/generic-smp/arch/ia64/include/asm/sal.h:40,
>                  from /home/aegl/generic-smp/arch/ia64/include/asm/mca.h:20,
>                  from arch/ia64/kernel/asm-offsets.c:17:
> include/asm-generic/pgtable.h: In function ‘pmdp_get_and_clear’:
> include/asm-generic/pgtable.h:96: error: implicit declaration of function ‘__pmd’
> include/asm-generic/pgtable.h:96: error: incompatible types in return
> make[1]: *** [arch/ia64/kernel/asm-offsets.s] Error 1
> 
> 
> Looks like arch/*/include/pgtable.h needs to define __pmd() but only x86
> was blessed with it.
> 
> -Tony
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


