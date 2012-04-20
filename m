Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085Ab2DTDbt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 23:31:49 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:60314 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab2DTDbs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 23:31:48 -0400
MIME-Version: 1.0
In-Reply-To: <4F90D564.3090508@gmail.com>
References: <1334872799-14589-1-git-send-email-ddaney.cavm@gmail.com>
 <1334872799-14589-2-git-send-email-ddaney.cavm@gmail.com> <4F90BF8D.7030209@zytor.com>
 <4F90D564.3090508@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 19 Apr 2012 20:31:26 -0700
X-Google-Sender-Auth: USVa9jjoSVK7eSDuOJ-VMhazYAM
Message-ID: <CA+55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com>
Subject: Re: [PATCH v1 1/5] scripts: Add sortextable to sort the kernel's
 exception table.
To: David Daney <david.s.daney@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, David Daney <ddaney.cavm@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Daney <david.daney@cavium.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 8:17 PM, David Daney <david.s.daney@gmail.com> wrote:
>
> I hadn't considered that the image was relocatable.  Our MIPS kernels never
> have relocations.
>
> I am working on a version of this that handles the relocations.  It
> shouldn't be too difficult.

It might be better to just make the rule be that we don't have
relocations there - make everything relative to the start of the code
segment or something.

On x86, we already use that _ASM_EXTABLE() macro to hide the
differences between x86-64 and x86-32. So it should be be somewhat
easy to make that same macro make it relative to the code start, and
at the same time also make the exception table perhaps be two 32-bit
words rather than two pointers.

So it would shrink the exception table and avoid relocations at the
same time. Win-win. No?

                      Linus
