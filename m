Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890Ab1F0LGx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 07:06:53 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53869 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755658Ab1F0LGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 07:06:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] modules: add default loader hook implementations
Date: Mon, 27 Jun 2011 13:05:44 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Rusty Russell <rusty@rustcorp.com.au>, Jonas Bonn <jonas@southpole.se>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, monstr@monstr.eu, cmetcalf@tilera.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
References: <1308987512-6583-1-git-send-email-jonas@southpole.se> <87hb7b7ic6.fsf@rustcorp.com.au> <BANLkTinmhQT=__WP+10cr2HZPy1TvdxZ=w@mail.gmail.com>
In-Reply-To: <BANLkTinmhQT=__WP+10cr2HZPy1TvdxZ=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106271305.44746.arnd@arndb.de>
X-Provags-ID: V02:K0:r0K5sADrb9K7r9bqDSXFPKxu9SHj08LsDxbXJP2tfjm
 ANP0E3mqM2vMJb8h87emJLPFUTClmGhml1/HMHvWXr84rtc4un
 8D8xrr5AL4w+dsEIPj2SrRwYSsOCBhC4FmfRrNlIZKbvLuxDZg
 rriJzZ0ld4gF61irqWCtzMkYVsf8KWlVT8e6AgSBqZsD8x6++n
 CtvKIwGNePVbRef4l6SjQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 June 2011, Geert Uytterhoeven wrote:
> >> I don't care much either way, you would get my Ack for both solutions.
> >> The __weak approach would definitely make a simpler patch, and the
> >> patch you sent adds extra complexity because of the
> >> asm_generic_moduleloader_hooks macro you used to avoid having to
> >> change all other architectures.
> >
> > I think you misread me.  If all else is equal, I dislike weak functions.
> > But AFAICT the two standard mechanisms are #ifdef HAVE_ARCH and __weak.
> > Inventing a third one is not going to be a win.
> 
> It's not inventing a new one, the third one is already in use.

True. In fact, we are (slowly) migrating away from HAVE_ARCH_* elsewhere.
In include/asm-generic/*.h, the common method is now to #define the exact
symbol if an architecture wants to override the generic version.

Weak symbols are fairly obscure in comparison, but they are actively
used by a few architectures (mips, sh) and some core code in kernel/
and mm/.

	Arnd
