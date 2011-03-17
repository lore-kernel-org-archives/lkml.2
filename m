Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab1CQRf6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 13:35:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58967 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751576Ab1CQRf4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 13:35:56 -0400
MIME-Version: 1.0
In-Reply-To: <s5haagtvfc2.wl%tiwai@suse.de>
References: <4D81D6F9.3040304@t-online.de> <AANLkTim=R7GVDY0Nt-6q1mjO3vas-qRy7=VxqgWWtz_s@mail.gmail.com>
 <s5haagtvfc2.wl%tiwai@suse.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 Mar 2011 10:33:04 -0700
Message-ID: <AANLkTi=ZSS=gDtGOcKBdE0BfJLpu0Ye1UhuNcbkz70Vs@mail.gmail.com>
Subject: Re: [BUG][2.6.38] IRQ Lock Inversion / i915 fails
To: Takashi Iwai <tiwai@suse.de>
Cc: Knut Petersen <Knut_Petersen@t-online.de>,
        Jaroslav Kysela <perex@perex.cz>,
        Chris Wilson <chris@chris-wilson.co.uk>, jesse.barnes@intel.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?David_M=FCller?= <d.mueller@elsoft.ch>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 10:15 AM, Takashi Iwai <tiwai@suse.de> wrote:
>
> The trigger callback should be called always in irq-disabled context,
> so this should be OK.

Oh, ok. I missed the snd_pcm_action_lock_irq() thing disabling
interrupts in that call sequence..

> But loopback_pos_update() is called in the
> timer callback, and this can be the issue.

Hmm. If the timer callback is the only other case doing that, then
that should be ok.

In fact, now that I look at that lockdep thing, I'm confused. Where
does the hard irq come in at all for that lock? It seems to come from
self_group.lock, but I don't see why/how they nest.

That said, the sound locking is odd, I'm sure you see it. But a
commentary about how this came about in the changelog would be good.

                     Linus
