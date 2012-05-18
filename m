Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933594Ab2ERAIH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 20:08:07 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57679 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932585Ab2ERAIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 20:08:04 -0400
MIME-Version: 1.0
In-Reply-To: <4FB58EFD.7010302@zytor.com>
References: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com>
 <1337292816-10839-9-git-send-email-hjl.tools@gmail.com> <4FB58EFD.7010302@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 May 2012 17:07:42 -0700
X-Google-Sender-Auth: GPcqiqtJRUNZHIWCwc0aRd4aYnQ
Message-ID: <CA+55aFy+XOc350sVuLKDHAaKtz9GdLcVmjxs98N8XLTK4zmMYg@mail.gmail.com>
Subject: Re: [PATCH 08/10] Use __kernel_ulong_t in struct msqid64_ds
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "H.J. Lu" <hjl.tools@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 4:51 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> The sane thing would seem to be to change __BITS_PER_LONG to 32 on x32
> and fix the padding hacks in struct shmid64_ds; H.J., would you agree?

Ugh. That looks like a disaster.

The padding hacks that depend on __BITS_PER_LONG seem pretty damn broken anyway.

They only work if the kernel agrees with the value (which is against
the whole point of making __BITS_PER_LONG be about some user-level ABI
thing) or for little-endian machines.

IOW, all the __BITS_PER_LONG games look totally broken to me. I can't
see how they could possibly even be fixed.


                           Linus
