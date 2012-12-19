Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab2LSDhU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 22:37:20 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:53505 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536Ab2LSDhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 22:37:16 -0500
MIME-Version: 1.0
In-Reply-To: <20121214143437.GC4966@liondog.tnic>
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
	<1355436141-8668-3-git-send-email-yinghai@kernel.org>
	<20121214143437.GC4966@liondog.tnic>
Date: Tue, 18 Dec 2012 19:37:14 -0800
X-Google-Sender-Auth: VJ6a6iJ1f-sBcX2gefJqNJXmqmM
Message-ID: <CAE9FiQVEjDwojC=iYomaYt+7k4Jw6VJyCYr5n3U3q_yRhEZ04A@mail.gmail.com>
Subject: Re: [PATCH v6 02/27] x86, mm: make pgd next calculation consistent
 with pud/pmd
From: Yinghai Lu <yinghai@kernel.org>
To: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 6:34 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Thu, Dec 13, 2012 at 02:01:56PM -0800, Yinghai Lu wrote:
>> Just like PUD_SIZE, and PMD_SIZE next calculation, aka
>> round down and add size.
>
> Why? Please explain more verbosely.
>
>> also remove not need next checking, just pass end instead.
>> later phys_pud_init uses PTRS_PER_PUD checking to exit early
>> if end is too big.
>
> Where? In the for-loop? Where does it check 'end'?
>

update to :

---
Subject: [PATCH] x86, mm: make pgd next calculation consistent with pud/pmd

Just like the way we calculate next for pud and pmd, aka
round down and add size.

also remove not needed next checking, just pass end with phys_pud_init.

pyhs_pud_init() uses PTRS_PER_PUD to stop its loop early so it could handle
big end properly.
---
