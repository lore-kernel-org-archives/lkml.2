Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758663Ab2EIIWm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 04:22:42 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38378 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758629Ab2EIIWh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 04:22:37 -0400
MIME-Version: 1.0
In-Reply-To: <1336485790-30902-6-git-send-email-alex.shi@intel.com>
References: <1336485790-30902-1-git-send-email-alex.shi@intel.com>
	<1336485790-30902-6-git-send-email-alex.shi@intel.com>
Date: Wed, 9 May 2012 18:22:36 +1000
Message-ID: <CAPa8GCDV5xs7gL0JJufL1EXvsdgW4EaMdVMxnFp7DFEnGnt_sw@mail.gmail.com>
Subject: Re: [PATCH v3 5/7] x86/tlb: remove comments for tlb_flush_range
 implement suggestion
From: Nick Piggin <npiggin@gmail.com>
To: Alex Shi <alex.shi@intel.com>
Cc: mgorman@suse.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com,
        jeremy@goop.org, gregkh@linuxfoundation.org, glommer@redhat.com,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        dhowells@redhat.com, fenghua.yu@intel.com, borislav.petkov@amd.com,
        yinghai@kernel.org, ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, hughd@google.com,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, paul.gortmaker@windriver.com, trenn@suse.de,
        tj@kernel.org, oleg@redhat.com, axboe@kernel.dk,
        a.p.zijlstra@chello.nl, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 May 2012 00:03, Alex Shi <alex.shi@intel.com> wrote:
> Thanks to this comments that inspired me using invlpg to replace cr3
> rewrite.
> Now, it is time to remove from code to avoid reader confusing.

Nitpick, but this should just be folded into the patch which does the
invlpg conversion.

>
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  arch/x86/include/asm/tlbflush.h |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
> index ec30dfb..51f8b1c 100644
> --- a/arch/x86/include/asm/tlbflush.h
> +++ b/arch/x86/include/asm/tlbflush.h
> @@ -81,10 +81,6 @@ static inline void __flush_tlb_one(unsigned long addr)
>  *
>  * ..but the i386 has somewhat limited tlb flushing capabilities,
>  * and page-granular flushes are available only on i486 and up.
> - *
> - * x86-64 can only flush individual pages or full VMs. For a range flush
> - * we always do the full VM. Might be worth trying if for a small
> - * range a few INVLPGs in a row are a win.
>  */
>
>  #ifndef CONFIG_SMP
> --
> 1.7.5.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
