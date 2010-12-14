Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759918Ab0LNUBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 15:01:40 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:34162 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759441Ab0LNUBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 15:01:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=PLNsqZfEhRO+mpLpn8Ww2BtqmcjkQkbH8NSrRIIIe05VNRs64ocK7WrhRLrMHiiStl
         cjAVqZMS9Ce6lASDv4C/GjCvUwsIgHhiuLuVej/EBrNGx0PLxdose4RkgaaLdCjohyvg
         YHhrlZ5c8Od7Sz0YrxFFPHrSiAklG6av7KTZI=
Subject: Re: [PATCH] mtd: allow mtd and jffs2 when ARCH=um
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Jason Lunz <lunz@acm.org>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>, David Woodhouse <dwmw2@infradead.org>,
        atom ota <atomota@sleepyhammer.com>,
        user-mode-linux-devel@lists.sourceforge.net,
        Jeff Dike <jdike@addtoit.com>, lkml <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org, Rob Landley <rob@landley.net>
In-Reply-To: <20101214195124.GA6010@falooley.org>
References: <22c797d00709272118i33d32b9dy93d5f5ec8f8edd30@mail.gmail.com>
	 <20071024011712.GA3762@falooley.org>
	 <1193208689.26096.48.camel@pmac.infradead.org>
	 <20071227181524.GA19051@falooley.org>
	 <20071228174853.GA4252@uranus.ravnborg.org>
	 <20101207072919.GA8511@falooley.org>
	 <AANLkTineLxHdcDKZEUGiqVNAauSX_xyQrs49kKaqhiWo@mail.gmail.com>
	 <20101207182012.GA10546@falooley.org> <1292343878.2538.80.camel@localhost>
	 <20101214195124.GA6010@falooley.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Dec 2010 22:01:33 +0200
Message-ID: <1292356893.29257.1.camel@koala>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-14 at 11:51 -0800, Jason Lunz wrote:
> On Tue, Dec 14, 2010 at 06:24:38PM +0200, Artem Bityutskiy wrote:
> > But I think your solution is a bit dirty, because it adds a great deal
> > of little 'if HAS_IOMEM' and '#ifdef CONFIG_HAS_IOMEM' to many places.
> > This is error-prone.
> 
> The intent of that patch was to allow as much of the mtd subsystem to
> compile as possible. My thinking was to try and rectify the fact that
> uml has gone without mtd (and hence jffs2) support for years even though
> much of it works just fine. I think the entire subsystem being marked
> BROKEN in kconfig kept anyone from experimenting with it.
> 
> The patch I sent was actually a reaction to feedback I got from Sam
> Ravnborg on my last attempt (um, three years ago :/ ) in which he
> suggested pushing down the ifdefs closer to their points of use. But I
> agree, the minimal version has a much smaller footprint.
> 
> The version below still meets the goal of allowing jffs2-on-block2mtd
> usage under uml but is much smaller because only the mtd core is
> included. Compile-tested on i386, x86_64, um/i386, and um/x86_64.
> 
> > Instead, you should solve this problem in UML code. I do not know how,
> > but may be you can add readb/writeb there which actually do nothing or
> > print a scary warning, or do BUG(), and let things which use them just
> > fail run-time.
> 
> Something like this could work, but it would be error-prone for anyone
> else who attempts using iomem-requiring drivers on uml. Instead of
> getting obvious compile failures we'd have broken drivers that BUG() or
> emit scary warnings. That doesn't seem to me like an improvement.

This problem does not seem to be mtd-specific, right? So my point was
that it would be nicer to come up with a general solution.

-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)

