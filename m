Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760431Ab2EIRPf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 13:15:35 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43665 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab2EIRPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 13:15:33 -0400
MIME-Version: 1.0
In-Reply-To: <1336570043.2527.38.camel@twins>
References: <1336559908-32533-1-git-send-email-imammedo@redhat.com>
 <4FAA452A.1070909@gmail.com> <4FAA588B.5010404@redhat.com>
 <1336564330.2527.23.camel@twins> <4FAA5BFB.40309@redhat.com>
 <1336566096.2527.30.camel@twins> <1336566644.2527.33.camel@twins> <1336570043.2527.38.camel@twins>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 9 May 2012 10:15:11 -0700
X-Google-Sender-Auth: zSP40UuKE2agWM_y8kkyDre17UM
Message-ID: <CA+55aFyjGZ=PLOBfyFub4kS3r2vJ0SFD58rTf21koPodFTSARQ@mail.gmail.com>
Subject: Re: [RFC][PATCH] printk: Add %pb to print bitmaps
To: Peter Zijlstra <peterz@infradead.org>
Cc: Igor Mammedov <imammedo@redhat.com>, Jiang Liu <liuj97@gmail.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, pjt@google.com,
        tglx@linutronix.de, seto.hidetoshi@jp.fujitsu.com,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 9, 2012 at 6:27 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> + * - 'b' For a bitmap, consumes 2 args, second is int
> + * - 'bc' For a cpumask
> + * - 'bn' For a nodemask

Hard NAK.

No way. The "consumes 2 args" is fundamentally idiotic, since it
forces compiler warnings. The whole idea of %pXX was that you can give
it any pointer, because all that the compiler cares about is the "%p"
part, so random pointers to stuff won't break.

Your patch breaks the whole point of the extension.

The "bc" and "bn" would work, except for the fact that I doubt they
are printed out enough to matter.

A "%.*pb" is the only interface that can work for a "sized" bitmap
(with obviously fixed-length ones being possible with a "%.32bp" like
thing)

But the whole va_args games you play are not acceptable. %p *will*
continue to take a void *, and nothing else.

                 Linus
