Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760094Ab0LNVMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 16:12:32 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:57581 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758540Ab0LNVMb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 16:12:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=bEtu3JhdqWOD1fJsWa340E9pvmorN6fMXgRJ2cV0iA8TaDbSeojRj//AvBgVP/p9xA
         2gex82AGM3Hv1p+xdKUsc+hfCWLHJzrhOSab8CM/9wx2787tynZ6SJI5Ot7gZ9EOp5N+
         sUmaP9gOBgYaqBwyTG9PJfYQgPBNC00Bw59TE=
MIME-Version: 1.0
In-Reply-To: <1292356893.29257.1.camel@koala>
References: <22c797d00709272118i33d32b9dy93d5f5ec8f8edd30@mail.gmail.com>
	<20071024011712.GA3762@falooley.org>
	<1193208689.26096.48.camel@pmac.infradead.org>
	<20071227181524.GA19051@falooley.org>
	<20071228174853.GA4252@uranus.ravnborg.org>
	<20101207072919.GA8511@falooley.org>
	<AANLkTineLxHdcDKZEUGiqVNAauSX_xyQrs49kKaqhiWo@mail.gmail.com>
	<20101207182012.GA10546@falooley.org>
	<1292343878.2538.80.camel@localhost>
	<20101214195124.GA6010@falooley.org>
	<1292356893.29257.1.camel@koala>
Date: Tue, 14 Dec 2010 22:12:28 +0100
X-Google-Sender-Auth: N69dsufX8BqrsruJXep4sk6Za0s
Message-ID: <AANLkTim2i5e=5uioB8TQhpP9U9ZzSg=zLaH_xscP2Wmg@mail.gmail.com>
Subject: Re: [PATCH] mtd: allow mtd and jffs2 when ARCH=um
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: dedekind1@gmail.com
Cc: Jason Lunz <lunz@acm.org>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>, David Woodhouse <dwmw2@infradead.org>,
        atom ota <atomota@sleepyhammer.com>,
        user-mode-linux-devel@lists.sourceforge.net,
        Jeff Dike <jdike@addtoit.com>, lkml <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org, Rob Landley <rob@landley.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 21:01, Artem Bityutskiy <dedekind1@gmail.com> wrote:
> On Tue, 2010-12-14 at 11:51 -0800, Jason Lunz wrote:
>> On Tue, Dec 14, 2010 at 06:24:38PM +0200, Artem Bityutskiy wrote:
>> > But I think your solution is a bit dirty, because it adds a great deal
>> > of little 'if HAS_IOMEM' and '#ifdef CONFIG_HAS_IOMEM' to many places.
>> > This is error-prone.
>>
>> The intent of that patch was to allow as much of the mtd subsystem to
>> compile as possible. My thinking was to try and rectify the fact that
>> uml has gone without mtd (and hence jffs2) support for years even though
>> much of it works just fine. I think the entire subsystem being marked
>> BROKEN in kconfig kept anyone from experimenting with it.
>>
>> The patch I sent was actually a reaction to feedback I got from Sam
>> Ravnborg on my last attempt (um, three years ago :/ ) in which he
>> suggested pushing down the ifdefs closer to their points of use. But I
>> agree, the minimal version has a much smaller footprint.
>>
>> The version below still meets the goal of allowing jffs2-on-block2mtd
>> usage under uml but is much smaller because only the mtd core is
>> included. Compile-tested on i386, x86_64, um/i386, and um/x86_64.
>>
>> > Instead, you should solve this problem in UML code. I do not know how,
>> > but may be you can add readb/writeb there which actually do nothing or
>> > print a scary warning, or do BUG(), and let things which use them just
>> > fail run-time.
>>
>> Something like this could work, but it would be error-prone for anyone
>> else who attempts using iomem-requiring drivers on uml. Instead of
>> getting obvious compile failures we'd have broken drivers that BUG() or
>> emit scary warnings. That doesn't seem to me like an improvement.
>
> This problem does not seem to be mtd-specific, right? So my point was
> that it would be nicer to come up with a general solution.

The generic solution for stuff that needs I/O operations is to mark it
"depends on HAS_IOMEM".

I used a similar patch in the past, IIRC to try axfs on UML.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
