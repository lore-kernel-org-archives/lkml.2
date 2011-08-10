Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab1HJA5d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 20:57:33 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:44967 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751164Ab1HJA5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 20:57:31 -0400
Subject: Re: [PATCH] treewide: Update sha_transform
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mandeep Singh Baines <msb@chromium.org>, linux-kernel@vger.kernel.org,
        Ramsay Jones <ramsay@ramsay1.demon.co.uk>,
        Nicolas Pitre <nico@fluxnic.net>,
        Joachim Eastwood <manabian@gmail.com>,
        Andreas Schwab <schwab@linux-m68k.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        GeertUytterhoeven <geert@linux-m68k.org>
In-Reply-To: <CA+55aFwHEoDkWr6Mh=r1KG4MLRbY0_iVF-v3BPkK+zhxkriHdw@mail.gmail.com>
References: <1312844837-10086-1-git-send-email-msb@chromium.org>
	 <1312847115.1643.22.camel@Joe-Laptop> <20110809055226.GE6103@google.com>
	 <1312880303.1676.5.camel@Joe-Laptop>
	 <CA+55aFwHEoDkWr6Mh=r1KG4MLRbY0_iVF-v3BPkK+zhxkriHdw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Aug 2011 17:57:28 -0700
Message-ID: <1312937848.11924.44.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-09 at 08:41 -0700, Linus Torvalds wrote:
> On Tue, Aug 9, 2011 at 1:58 AM, Joe Perches <joe@perches.com> wrote:
> > Eliminate possible sha_transform unaligned accesses to data by copying
> > data to an aligned __u32 array if necessary.
> This is wrong. Not only does it double the stack space, when I tried
> it for git it just made things slower. So don't do it.

Maybe the aligned copy should be in an
#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS block.

Maybe Mandeep could test aligned/unaligned speeds
for his board?

