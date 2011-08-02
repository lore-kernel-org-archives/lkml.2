Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab1HBAFj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 20:05:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34286 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752668Ab1HBAFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 20:05:33 -0400
MIME-Version: 1.0
In-Reply-To: <201108011753.p71HrrTr011226@hera.kernel.org>
References: <201108011753.p71HrrTr011226@hera.kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 1 Aug 2011 14:04:42 -1000
Message-ID: <CA+55aFyKFP3KzVfSEO02TjjmMDDL5agCJjKERFdmStM4k9DtQQ@mail.gmail.com>
Subject: Re: [GIT PULL] x86/spinlocks optional for 3.1
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 1, 2011 at 7:53 AM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>
> Sorry for this late pull; testing on this got delayed due to my and
> Ingo's scheduling and the desire to make sure that this would not
> cause a performance regression.
>
> At this time we have good confidence in it, but if you feel this is
> too late feel free to drop it and we'll do it for 3.2.

Hmm. I don't mind it per se, but I hate how this patch that is meant
to combine the inline asm versions into one C version actually creates
*more* lines, and creates *more* inline asm differences between
x86-32/64 due to the xadd.

So quite frankly, I think the patch in this form is totally
self-defeating. I'm not pulling something that is supposed to clean
things up, but just adds more ugliness in some other place.

If that xadd implementation could perhaps be shared, I wouldn't hate
it so much. As it is, I really don't see the point in pulling this.

             Linus
