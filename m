Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222Ab1GaEe3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 00:34:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55338 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750762Ab1GaEeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 00:34:22 -0400
MIME-Version: 1.0
In-Reply-To: <CAF_S4t9PhDQBBfaLLaq1sE9YkJvQq5Q+ULegpD0aoTnv0CPutw@mail.gmail.com>
References: <20110730234630.7270.qmail@science.horizon.com>
 <CAF_S4t8TFour-Yw1T+qdG9mCzy9+tGBR0hQG83+ra6PRzPhNHQ@mail.gmail.com>
 <CA+55aFyimDdpCRER_7pc30S-QLhUkt0z-Y=gD48f7t=FxxFh7g@mail.gmail.com> <CAF_S4t9PhDQBBfaLLaq1sE9YkJvQq5Q+ULegpD0aoTnv0CPutw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 30 Jul 2011 18:33:38 -1000
Message-ID: <CA+55aFzUeRd0fx79eepx98HLk3-EMWPyu2V-9VM1qtT60q-bVQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] random: Add support for architectural random hooks
To: Bryan Donlan <bdonlan@gmail.com>
Cc: George Spelvin <linux@horizon.com>, linux-kernel@vger.kernel.org,
        mpm@selenic.com, tytso@mit.edu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 30, 2011 at 4:02 PM, Bryan Donlan <bdonlan@gmail.com> wrote:
>
> In any case though, what about my suggestion - don't mess with urandom
> at all, and let udev replace the /dev/urandom device node with one
> directed to a fast hwrng device if one is detected?

Umm, user space is encouraged to do exactly that.

However, at no point does that mean "the kernel shouldn't do the best
it can". So it's a totally independent issue.

The kernel will want to use rdrand regardless of what user space does.
Both for legacy applications that don't know about rdrand, and for
scripts that don't want to bother. And for just its own use.

             Linus
