Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700Ab2LSV4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 16:56:09 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:55098 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab2LSV4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 16:56:01 -0500
MIME-Version: 1.0
In-Reply-To: <20121219204852.GH24895@liondog.tnic>
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
	<1355436141-8668-3-git-send-email-yinghai@kernel.org>
	<20121214143437.GC4966@liondog.tnic>
	<CAE9FiQVEjDwojC=iYomaYt+7k4Jw6VJyCYr5n3U3q_yRhEZ04A@mail.gmail.com>
	<20121219204852.GH24895@liondog.tnic>
Date: Wed, 19 Dec 2012 13:55:59 -0800
X-Google-Sender-Auth: zXJE46fUvs7sQLt2MavidCOzv6k
Message-ID: <CAE9FiQVXr7X7PuJNGZbEZ=k3xWNw=_kJ07VdRtoKZyDYwV66AA@mail.gmail.com>
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

On Wed, Dec 19, 2012 at 12:48 PM, Borislav Petkov <bp@alien8.de> wrote:
>
> "Also, do not boundary-check 'next' but pass 'end' down to
> phys_pud_init() instead because the loop in there terminates at
> PTRS_PER_PUD and thus can handle a possibly bigger 'end' properly."

---
Just like the way we calculate next for pud and pmd, aka
round down and add size.

Also, do not do boundary-checking with 'next', and just pass 'end'
down to phys_pud_init() instead. Because the loop in phys_pud_init()
terminates at PTRS_PER_PUD and thus can handle a possibly bigger
'end' properly.
---
