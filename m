Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab1JXHvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 03:51:31 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:35253 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725Ab1JXHva convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 03:51:30 -0400
MIME-Version: 1.0
In-Reply-To: <20111024094817.30c01c9b@de.ibm.com>
References: <CA+55aFxPNszU5UHFrDDYnshLEMupaviFwhgEsgmPkqpmuWNZ8A@mail.gmail.com>
 <20111007070842.GA27555@hostway.ca> <20111007174848.GA11011@hostway.ca>
 <1318010515.398.8.camel@twins> <20111008005035.GC22843@hostway.ca>
 <1318060551.8395.0.camel@twins> <20111012213555.GC24461@hostway.ca>
 <20111013232521.GA5654@hostway.ca> <CA+55aFxxfsFMgqA7kYKukvkCX6Z9HrKOtP-22w5Mc21iQj4c=Q@mail.gmail.com>
 <20111020163609.16816e78@de.ibm.com> <20111023113422.GD5156@elte.hu> <20111024094817.30c01c9b@de.ibm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 24 Oct 2011 09:51:09 +0200
X-Google-Sender-Auth: XSO4xrRBMbzrFVmH1q2TKT080Fo
Message-ID: <CA+55aFyybeTZvzSU4L=hV1Y6+wXn2ZkuZF9R+vAj6MRVC+MmBQ@mail.gmail.com>
Subject: Re: Linux 3.1-rc9
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Simon Kirby <sim@hostway.ca>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 9:48 AM, Martin Schwidefsky
<schwidefsky@de.ibm.com> wrote:
>
> These types are still there because cputime_t can be u32 or u64. E.g. this
>
>  timer->expires.cpu = 0;
>
> will give the following sparse warning
>
>  kernel/posix-cpu-timers.c:463:46: warning: implicit cast to nocast type

Ok, we should probably special-case zero for that case too (we
consider zero to be very special - it's not only the NULL pointer, but
0 is special for the bitwise types etc). So this is very arguably a
sparse issue: casting zero is special.

                  Linus
