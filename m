Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab1GaBfz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 21:35:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58169 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752711Ab1GaBfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 21:35:51 -0400
MIME-Version: 1.0
In-Reply-To: <CAF_S4t8TFour-Yw1T+qdG9mCzy9+tGBR0hQG83+ra6PRzPhNHQ@mail.gmail.com>
References: <20110730234630.7270.qmail@science.horizon.com> <CAF_S4t8TFour-Yw1T+qdG9mCzy9+tGBR0hQG83+ra6PRzPhNHQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 30 Jul 2011 15:35:29 -1000
Message-ID: <CA+55aFyimDdpCRER_7pc30S-QLhUkt0z-Y=gD48f7t=FxxFh7g@mail.gmail.com>
Subject: Re: [PATCH 1/2] random: Add support for architectural random hooks
To: Bryan Donlan <bdonlan@gmail.com>
Cc: George Spelvin <linux@horizon.com>, linux-kernel@vger.kernel.org,
        mpm@selenic.com, tytso@mit.edu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 30, 2011 at 3:02 PM, Bryan Donlan <bdonlan@gmail.com> wrote:
>
> The problem, as you can see here, is we need to test for the existence
> of an architecture-specific HWRNG once for _every word processed_.

See the patch I sent out. Not only doesn't it check an
architecture-specific flag on x86, IT COSTS NOTHING AT ALL on other
architectures. Not per byte, not per call, not at all.

On x86, it does have the cost of:

 - basically one conditional for the whole loop (branching out if
there is no rdrand support at all). You cannot do much better than
that, except of course if you statically say "compile for an x86 that
doesn't have rdrand")

 - a per-word cost of checking CF - which you are supposed to do
anyway (ie the rdrand hardware will return with CF clear if the data
isn't reliable).

So at least on x86, I think you can get pretty close to "optimal
behavior" with my approach.

              Linus
