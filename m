Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab1GaHdu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 03:33:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:33423 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab1GaHdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 03:33:47 -0400
Subject: Re: [PATCH 2/2] Enable 'make CONFIG_FOO=y oldconfig'
From: David Woodhouse <dwmw2@infradead.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>
Date: Sun, 31 Jul 2011 08:33:39 +0100
In-Reply-To: <CACqU3MVkLXoBq7KP2Jff=p7EiKR7DkPa4z7y0Rdah-dGzRvj4g@mail.gmail.com>
References: <1312067499.22074.59.camel@i7.infradead.org>
	 <1312067670.22074.61.camel@i7.infradead.org>
	 <CACqU3MV460WGjmQdOOmhk3ZJT1FNjEjfuHqx8mYcgun9+7SfjA@mail.gmail.com>
	 <4E34998D.8060806@zytor.com>
	 <CACqU3MWn-OQVfLH96E+AeTCEjUw5+girXbuNgmUvXrEQuBe4vg@mail.gmail.com>
	 <4E34A1E4.8040103@zytor.com>
	 <CACqU3MVkLXoBq7KP2Jff=p7EiKR7DkPa4z7y0Rdah-dGzRvj4g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312097621.22074.71.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-07-30 at 21:06 -0400, Arnaud Lacombe wrote:
> The principle of least surprise is broken anyway as the proposed patch
> has absolutely no dependency checking and verification. You can `make
> CONFIG_SATA_MV=y allnoconfig', you will _not_ get it set.

That's always true in kconfig *anyway*. We've *never* really had an
option for "do whatever you need to enable this option". We've even
hard-coded this failure in our language, by introducing this horrible
'select' thing to work around it.

I'd no more expect that, than I would for it to write the code for me if
I type 'make CONFIG_BTRFSv2=y oldconfig'.

So no, it doesn't violate the principle of least surprise.

> ok, the issue is that you will only be allowed to change visible
> symbols. CONFIG_64BIT is conditionally visible (when ARCH=x86), so
> right now, you can not do on x86-64:
> 
> % make ARCH=i386 defconfig
> % make CONFIG_64BIT=n oldconfig # [0]

That works fine here. What was ARCH set to in your second test? If it's
ARCH=x86_64 then that's expected. That's the whole point of my *other*
patch to make 'ARCH=x86' be the default, so that the value of
CONFIG_64BIT in your .config is *not* forcibly overridden to match the
build host. That's a *separate* bug, which I also have a patch for.

-- 
dwmw2

