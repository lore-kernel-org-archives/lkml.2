Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab2IIPJ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 11:09:29 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:43374 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752989Ab2IIPJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 11:09:27 -0400
Message-ID: <1347203365.2050.3.camel@joe2Laptop>
Subject: Re: [PATCH/RFC] um: Preinclude include/linux/kern_levels.h
From: Joe Perches <joe@perches.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 09 Sep 2012 08:09:25 -0700
In-Reply-To: <CAMuHMdVyWRGyTPbA9pL267XWnvBnbN77353WjF8Ovmd062NSwg@mail.gmail.com>
References: <1345140905-10209-1-git-send-email-geert@linux-m68k.org>
	 <CAMuHMdVyWRGyTPbA9pL267XWnvBnbN77353WjF8Ovmd062NSwg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-09-09 at 10:33 +0200, Geert Uytterhoeven wrote:
> Ping?

Richard?  Are you going to pick up this patch?
It seems sensible.

Geert, I suggest sending it directly to Linus as a fix
if Richard doesn't respond in a few days.

> On Thu, Aug 16, 2012 at 8:15 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
> > The userspace part of UML uses the asm-offsets.h generator mechanism to
> > create definitions for UM_KERN_<LEVEL> that match the in-kernel
> > KERN_<LEVEL> constant definitions.
> >
> > As of commit 04d2c8c83d0e3ac5f78aeede51babb3236200112 ("printk: convert
> > the format for KERN_<LEVEL> to a 2 byte pattern"), KERN_<LEVEL> is no
> > longer expanded to the literal '"<LEVEL>"', but to '"\001" "LEVEL"', i.e.
> > it contains two parts.
> >
> > However, the combo of DEFINE_STR() in
> > arch/x86/um/shared/sysdep/kernel-offsets.h and sed-y in Kbuild doesn't
> > support string literals consisting of multiple parts. Hence for all
> > UM_KERN_<LEVEL> definitions, only the SOH character is retained in the actual
> > definition, while the remainder ends up in the comment. E.g. in
> > include/generated/asm-offsets.h we get
> >
> >     #define UM_KERN_INFO "\001" /* "6" KERN_INFO */
> >
> > instead of
> >
> >     #define UM_KERN_INFO "\001" "6" /* KERN_INFO */
> >
> > This causes spurious '^A' output in some kernel messages:


