Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab2FNO3H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 10:29:07 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62002 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab2FNO3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 10:29:03 -0400
Date: Thu, 14 Jun 2012 23:28:55 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Grant Grundler <grantgrundler@gmail.com>,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
        akpm@linux-foundation.org, bhutchings@solarflare.com,
        grundler@parisc-linux.org, arnd@arndb.de, benh@kernel.crashing.org,
        avi@redhat.com, mtosatti@redhat.com, linux-net-drivers@solarflare.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 2/5] drivers/net/ethernet/dec/tulip: Use standard
 __set_bit_le() function
Message-Id: <20120614232855.5cb16291d148340c19d01f04@gmail.com>
In-Reply-To: <CAC5umyjkdDqavCo3Dk+WOggCnH+_CZz5jrOr3SougS4HSgV3OA@mail.gmail.com>
References: <20120613130054.b5695621.yoshikawa.takuya@oss.ntt.co.jp>
	<20120613130304.0186fa9d.yoshikawa.takuya@oss.ntt.co.jp>
	<CAC5umyj582T+9GbOYDzOAanmMcVZ-Fdxr7i-8GWf3gTSmtAKUA@mail.gmail.com>
	<20120613214157.0a5179d5358ec7f1b2646606@gmail.com>
	<CAC5umygutE35hVObuooWj=ADP6PZDy4cqLtxGnRtxRX8uTtGSw@mail.gmail.com>
	<20120613230013.3cc59bf908616e94bb4ccef2@gmail.com>
	<CAP6odji_JvRkJP1dSzGK5ww3y71h4k6pXyj4pOQBpqP-X7Nn-A@mail.gmail.com>
	<20120614072831.63845f6ddf024ece28e49f5e@gmail.com>
	<CAC5umyjkdDqavCo3Dk+WOggCnH+_CZz5jrOr3SougS4HSgV3OA@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2012 18:36:42 +0900
Akinobu Mita <akinobu.mita@gmail.com> wrote:

> >> 1) while I agree with Akinobu and thank him for pointing out a
> >> _potential_ alignment problem, this is a separate issue and your
> >> existing patch should go in anyway. There are probably other drivers
> >> with _potential_ alignment issues. Akinobu could get credit for
> >> finding them by submitting patches after reviewing calls to set_bit
> >> and set_bit_le() - similar to what you are doing now.
> >
> > I prefer approach 1.
> >
> > hash_table is local in build_setup_frame_hash(), so if further
> > improvement is also required, we can do that locally there later.
> 
> This potential alignment problem is introduced by this patch.  Because
> the original set_bit_le() in tulip driver can handle unaligned bitmap.
> This is why I recommended it should be fixed in this patch.

The original set_bit_le() was used only in build_setup_frame_hash().

If it's clear that the table is aligned locally in the function, I do
not think the __potential__ problem is introduced by this patch.

As you can see from my response to Arnd in v1 thread, I knew the
alignment requirement at that time and checked the definition of
hash_table before using __set_bit_le().

> But please just ignore me if I'm too much paranoid.  And I'll handle
> this issue if no one wants to do it.

I'm open to suggestions.

But now that the maintainer who can test the driver on real hardware
has suggested this patch should go in, I won't change the patch without
any real issue.

I would thank you if you improve this driver later on top of that.

Thanks,
	Takuya
