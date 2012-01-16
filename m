Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589Ab2APTrg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 14:47:36 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:35554 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029Ab2APTre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 14:47:34 -0500
MIME-Version: 1.0
In-Reply-To: <20120116194211.2cd09fb3@pyramind.ukuu.org.uk>
References: <20120109003255.GA6598@havoc.gtf.org> <CA+55aFwcBQSoWfqdT9CxV=GAr5ex0=RnqtBDFty+=_Lua2VXGw@mail.gmail.com>
 <4F12E57E.3090805@garzik.org> <1326676534.13517.3.camel@minggr>
 <1326691403.13517.21.camel@minggr> <CA+55aFzqECJjbtgyOXy_H1smh09SsfgrAuVY7hK2sC-xj1GZHg@mail.gmail.com>
 <20120116194211.2cd09fb3@pyramind.ukuu.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 16 Jan 2012 11:47:12 -0800
X-Google-Sender-Auth: RXMkOYBN7SSkIqnUIjEEYB4FhGg
Message-ID: <CA+55aFxNcAtCmzEejS=3+_L_rp-MOBS0yLS061YgiCsFw_Mt5Q@mail.gmail.com>
Subject: Re: [git patches] libata updates for 3.3
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Lin Ming <ming.m.lin@intel.com>, Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 11:42 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>
> There are two sets of problems with that
>
> The first is that quite a few machines crap themselves if you do this
> because nobody has ever tested things like the IRQ routing or the
> firmware on suspend/resume when they find the hardwared controller has
> gone for a walk.

I think this could trivially be solved at least on these kinds of
Apple machines by just making it a config option, and just not doing
it if it doesn't work. Some kernel command line to say "ahci=force" or
whatever.

That doesn't solve the "user never even realized" problem, but at
least it gives the user the possibility of solving the "crap firmware
doesn't even allow this".

> Putting it back on suspend might help in some cases but then you get to
> pick your way through the documentation minefield, deal with device
> changes while in non AHCI mode, figure out how to set up registers the
> BIOS didn't etc.

Yeah, no, that would just be horrible. I doubt it happens in practice,
though.  I bet the normal PCI/AHCI resume will just do the right
thing. But I haven't tried..

                        Linus
