Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab1ECUS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 16:18:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754666Ab1ECUS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 16:18:28 -0400
MIME-Version: 1.0
In-Reply-To: <20110503190822.GA20520@elte.hu>
References: <web-516671337@zbackend1.aha.ru> <BANLkTikFqF1vzMq3L9zDB=MDnCOFYp+XEQ@mail.gmail.com>
 <web-516990066@zbackend1.aha.ru> <BANLkTinCKC23WfG7jnd-ihW9kXz-6SEgFQ@mail.gmail.com>
 <20110503190822.GA20520@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 3 May 2011 13:17:36 -0700
Message-ID: <BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com>
Subject: Re: 2.6.39-rc5-git2 boot crashs
To: Ingo Molnar <mingo@elte.hu>
Cc: werner <w.landgraf@ru.ru>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=KOI8-R
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 3, 2011 at 12:08 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> I have no smart ideas straight away - just an observation: i keep testing
> CONFIG_X86_ELAN=y on real hardware, and it's enabled in about 4% of my configs:

So how often do you do more than just boot?

Because this problem doesn't happen at boot-time, the "bad IO" issue
seems to happen only after some real filesystem work (ie the "unzip a
140MB file" etc). In one of the logs, the SATA driver issue ended up
happening four hours after boot (but I think Werner could trigger it
in minutes by doing heavy FS work).

That's why I'd suspect some subtle race or other and/or memory
allocation re-use.

The subject line "boot crashs" is misleading, because that's the
unrelated logfs thing that I have a tentative patch for.

That said, I don't really see why ELAN would be so special.

Werner: can you test without X86_EXTENDED_PLATFORM, but then picking
the i486 config instead? That should approximate the ELAN
configuration pretty closely, at least in things like compiler flags..

                   Linus
