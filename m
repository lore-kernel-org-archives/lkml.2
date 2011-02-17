Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537Ab1BQOAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 09:00:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39897 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925Ab1BQOAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 09:00:11 -0500
Date: Thu, 17 Feb 2011 14:59:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: Re: [PATCH] x86: use bitmap library functions
Message-ID: <20110217135956.GA8053@elte.hu>
References: <1297867715-20394-1-git-send-email-akinobu.mita@gmail.com>
 <20110216153825.GA18805@elte.hu>
 <AANLkTi=eS=mdRQ07EvceP0098_=kj96qRNYeQ0oAduo-@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=eS=mdRQ07EvceP0098_=kj96qRNYeQ0oAduo-@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Akinobu Mita <akinobu.mita@gmail.com> wrote:

> 2011/2/17 Ingo Molnar <mingo@elte.hu>:
> >
> > * Akinobu Mita <akinobu.mita@gmail.com> wrote:
> >
> >> Use bitmap_set()/bitmap_clear() to fill/zero a region of a bitmap
> >> instead of doing set_bit()/clear_bit() each bit.
> >>
> >> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> >> Cc: Thomas Gleixner <tglx@linutronix.de>
> >> Cc: Ingo Molnar <mingo@redhat.com>
> >> Cc: "H. Peter Anvin" <hpa@zytor.com>
> >> Cc: x86@kernel.org
> >> ---
> >>  arch/x86/kernel/ioport.c |   20 +++++---------------
> >>  1 files changed, 5 insertions(+), 15 deletions(-)
> >
> > Before we can merge this it would be nice to tested this using sys_ioperm(), to make
> > sure port IO still gets denied/allowed as expected. You can check /proc/ioperm to
> > see which ports are (probably) safe to read: 0x80/0xed is usually safe to
> > read/write.
> 
> I have tested with this program and there is no difference in behavior
> with this patch.

Great - i've queued it up in tip:x86/asm.

Thanks,

	Ingo
