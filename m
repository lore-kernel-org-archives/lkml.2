Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab2JEKeL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 06:34:11 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34719 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932112Ab2JEKeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 06:34:08 -0400
Date: Fri, 5 Oct 2012 12:34:04 +0200
From: Borislav Petkov <bp@alien8.de>
To: Iain Fraser <iainkfraser@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: interrupt context
Message-ID: <20121005103404.GA12655@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Iain Fraser <iainkfraser@gmail.com>, linux-kernel@vger.kernel.org
References: <CA+bLfK5FPqFvU2xy7xKdV4LkAvmY6GAPFrB-4UBzn-cOunQ6Xg@mail.gmail.com>
 <CA+bLfK44cYvhMbrK8ZrZ0BiEo3V=FB2UavCpL1CaRgjKqtN9Yw@mail.gmail.com>
 <20121005093232.GA7333@liondog.tnic>
 <CA+bLfK7+xpbbJp+1sJBOtjoT2auGpbKsVKoDMgRk95o-Fwm9RQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+bLfK7+xpbbJp+1sJBOtjoT2auGpbKsVKoDMgRk95o-Fwm9RQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2012 at 11:20:20AM +0100, Iain Fraser wrote:
> Hi,
> 
> Thanks for the response. But it appears your example illustrates why its bad
> to sleep while you have a lock. Which I understand, what I wanted to know is
> why in interrupt context under no circumstances are you allowed to sleep?
> 
> Btw I have no intention of doing this, I'm just curious. After
> thinking about it further
> I'm starting to think its a "design" decision as opposed to a side effect of the
> kernel implementation.

There are more examples where sleeping in IRQ context is simply
problematic. So prohibiting sleeping in such contexts turns out to be
the simplest solution concerning code complexity, design, handling, etc.

Btw, you can trigger some yourself by adding sleeping functions in an
IRQ handler used on your system, disable the "sleeping-while-atomic"
warnings and try to run it to see what happens.

> If you could answer:
>
> "How can the system timer ( obviously in interrupt context ) call
> schedule when it is impossible to sleep/schedule in interrupt
> context?"

I think the best way to learn these things is to stare at the code until
you've understood exactly what it does when it does it, so I'll let you
answer that.

And you want to learn because you wouldn't be asking those questions in
the first place. :-)

HTH.

-- 
Regards/Gruss,
    Boris.
