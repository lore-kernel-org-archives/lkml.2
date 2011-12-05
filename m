Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932727Ab1LEX0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 18:26:35 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52449 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508Ab1LEX0e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 18:26:34 -0500
MIME-Version: 1.0
In-Reply-To: <tip-287de5b2cb365b98190b5de8ace1c5a31768a5ae@git.kernel.org>
References: <tip-287de5b2cb365b98190b5de8ace1c5a31768a5ae@git.kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 5 Dec 2011 15:26:12 -0800
X-Google-Sender-Auth: QaFGg9ckqjA9G68idxoIkMCnEmE
Message-ID: <CA+55aFwMfUduX_5kNKjo=S8ShEBb_OE_D6o-jSMy53Sa0iZHAw@mail.gmail.com>
Subject: Re: [tip:x86/mm] x86/mm: Avoid superflous leave_mm() in the TLB flush path
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        torvalds@linux-foundation.org, shaohua.li@intel.com,
        akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 5, 2011 at 9:56 AM, tip-bot for Shaohua Li
<shaohua.li@intel.com> wrote:
>
> x86/mm: Avoid superflous leave_mm() in the TLB flush path
>
> If just one page VA tlb is required to be flushed and current
> task is in lazy TLB state, doing leave_mm() is superfluous
> because it flushes the whole TLB.  This can reduce some TLB
> miss.

Are you sure this is a good idea?

We may be *much* better off leaving the VM and avoiding future IPI's
than trying to flush pages one by one over and over again.

IPI's are expensive.

I don't think you thought this through, and if you *did* think it
through and actually have numbers that it's cheaper to stay with the
MM, I think you need to show those numbers.

                     Linus
