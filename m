Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126Ab1EaIIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 04:08:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33865 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368Ab1EaIIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 04:08:14 -0400
Date: Tue, 31 May 2011 10:07:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>
Subject: Re: [PATCH 0/5] x86-64: Remove syscall instructions at fixed
 addresses
Message-ID: <20110531080758.GA24172@elte.hu>
References: <cover.1306517576.git.luto@mit.edu>
 <20110529191924.GD9835@elte.hu>
 <BANLkTin9xfS_X9Bscf1qnNZMK=JBgpzV8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTin9xfS_X9Bscf1qnNZMK=JBgpzV8Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Lutomirski <luto@mit.edu> wrote:

> On Sun, May 29, 2011 at 3:19 PM, Ingo Molnar <mingo@elte.hu> wrote:
> > Btw., do you know CONFIG_X86_PTDUMP=y and /debug/kernel_page_tables?
> > You could use that to double check that after your patches all
> > executable (and fixed address) pages are removed [or are harmless].
> 
> Done.  Now there's only one user-executable page and it's mostly harmless.

ok. Will test your v3 series.

> Maybe I'll try to get rid of vread_tsc and vread_hpet later on to 
> make it even more harmless.

Yeah, that's a good idea. They need pushing into the INT 0xCC 
do_intcc() handler, that's all that's needed AFAICS - or can you see 
other complications with them?

Thanks,

	Ingo
