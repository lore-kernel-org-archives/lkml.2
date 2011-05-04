Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab1EDKl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 06:41:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36438 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317Ab1EDKl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 06:41:56 -0400
Date: Wed, 4 May 2011 12:41:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Cc: werner <w.landgraf@ru.ru>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
Message-ID: <20110504104140.GA5277@elte.hu>
References: <web-516671337@zbackend1.aha.ru>
 <BANLkTikFqF1vzMq3L9zDB=MDnCOFYp+XEQ@mail.gmail.com>
 <web-516990066@zbackend1.aha.ru>
 <BANLkTinCKC23WfG7jnd-ihW9kXz-6SEgFQ@mail.gmail.com>
 <20110503190822.GA20520@elte.hu>
 <BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com>
 <20110504083559.GB25724@elte.hu>
 <20110504101327.GA847@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504101327.GA847@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

>  - Maybe i reproduced the original crash by pure luck.
> 
>    To exclude this i'll re-test once again with the non-debug .config.

I got a different problem this time around:

Fedora Core release 6 (Zod)
Kernel 2.6.39-rc5-i486-1sys+ on an i686

mercury login: ata1: lost interrupt (Status 0x58)
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1.00: failed command: WRITE DMA EXT
ata1.00: cmd 35/00:38:56:cf:a5/00:01:05:00:00/e0 tag 0 dma 159744 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.00: status: { DRDY }
ata1: soft resetting link
ata1: nv_mode_filter: 0x3f39f&0x3f39f->0x3f39f, BIOS=0x3f000 (0xc60000c0) ACPI=0x3f01f (20:600:0x13)
ata1.00: configured for UDMA/100
ata1.00: device reported invalid CHS sector 0
ata1: EH complete
ata1: lost interrupt (Status 0x58)
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1.00: failed command: WRITE DMA EXT
ata1.00: cmd 35/00:38:56:cf:a5/00:01:05:00:00/e0 tag 0 dma 159744 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.00: status: { DRDY }
ata1: soft resetting link
ata1: nv_mode_filter: 0x3f39f&0x3f39f->0x3f39f, BIOS=0x3f000 (0xc60000c0) ACPI=0x3f01f (20:600:0x13)
ata1.00: configured for UDMA/100
ata1.00: device reported invalid CHS sector 0
ata1: EH complete

Fedora Core release 6 (Zod)
Kernel 2.6.39-rc5-i486-1sys+ on an i686

mercury login: 
Fedora Core release 6 (Zod)
Kernel 2.6.39-rc5-i486-1sys+ on an i686

mercury login: ata1: lost interrupt (Status 0x58)
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1.00: failed command: WRITE DMA EXT
ata1.00: cmd 35/00:38:56:cf:a5/00:01:05:00:00/e0 tag 0 dma 159744 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.00: status: { DRDY }
ata1: soft resetting link
ata1: nv_mode_filter: 0x3f39f&0x3f39f->0x3f39f, BIOS=0x3f000 (0xc60000c0) ACPI=0x3f01f (20:600:0x13)
ata1.00: configured for UDMA/100
ata1.00: device reported invalid CHS sector 0
ata1: EH complete

The system is dead (is not performing any IO) after that.

Note that i reported similar problems early during this merge window, in this mail:

  [sporadic crash] blk: request botched

That sha1 was 89078d572eb9ce8d4c04264b8b0ba86de0d74c8f - that already had 
lockless SLUB:

  e8c500c2b64b: Merge branch 'slub/lockless' into for-linus

I never managed to pin that down, these IO problems were very sporadic in my 
test setup and never reproducible, until today.

	Ingo
