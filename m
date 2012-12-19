Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab2LSUtE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 15:49:04 -0500
Received: from mail.skyhub.de ([78.46.96.112]:56147 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592Ab2LSUs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 15:48:56 -0500
Date: Wed, 19 Dec 2012 21:48:53 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 02/27] x86, mm: make pgd next calculation consistent
 with pud/pmd
Message-ID: <20121219204852.GH24895@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yinghai Lu <yinghai@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
 <1355436141-8668-3-git-send-email-yinghai@kernel.org>
 <20121214143437.GC4966@liondog.tnic>
 <CAE9FiQVEjDwojC=iYomaYt+7k4Jw6VJyCYr5n3U3q_yRhEZ04A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAE9FiQVEjDwojC=iYomaYt+7k4Jw6VJyCYr5n3U3q_yRhEZ04A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 07:37:14PM -0800, Yinghai Lu wrote:
> update to :
> 
> ---
> Subject: [PATCH] x86, mm: make pgd next calculation consistent with pud/pmd
> 
> Just like the way we calculate next for pud and pmd, aka
> round down and add size.
> 
> also remove not needed next checking, just pass end with phys_pud_init.
> 
> pyhs_pud_init() uses PTRS_PER_PUD to stop its loop early so it could handle
> big end properly.

Almost there, let's merge the last two sentences:

"Also, do not boundary-check 'next' but pass 'end' down to
phys_pud_init() instead because the loop in there terminates at
PTRS_PER_PUD and thus can handle a possibly bigger 'end' properly."

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
