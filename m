Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab0LAPFV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 10:05:21 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46259 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007Ab0LAPFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 10:05:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=sIVKn2JbV/nUHIKEByjLfeiHj30Pcjz2NBUA6NqTBOOJR26H+ayPVyp0GmeBfTkE5B
         KIBoDhNbD7SEShmLNQISgD50+IPxn3N7GYx/6CJe4DBmwKs9lQxXE/P98x5RNjggQWwf
         xQcdrjK57JU3bNtbVj5fVkkUrudn3m13Lxq6M=
Date: Wed, 1 Dec 2010 16:05:08 +0100 (CET)
From: Hans Ulli Kroll <ulli.kroll@googlemail.com>
X-X-Sender: elektroman@localhost.localdomain
To: Arnd Bergmann <arnd@arndb.de>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        linux-arm-kernel@lists.infradead.org,
        =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Gemini: Add support for PCI Bus
In-Reply-To: <201011301719.03202.arnd@arndb.de>
Message-ID: <alpine.LNX.2.00.1012011604510.8521@localhost.localdomain>
References: <1290263224-16965-1-git-send-email-ulli.kroll@googlemail.com> <201011291657.53316.arnd@arndb.de> <20101130160527.GB2377@n2100.arm.linux.org.uk> <201011301719.03202.arnd@arndb.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 30 Nov 2010, Arnd Bergmann wrote:

> On Tuesday 30 November 2010, Russell King - ARM Linux wrote:
> > No, the above is correct.  What I was talking about was the difference
> > between these:
> > 
> > config PCI
> >         bool "PCI support" if MIGHT_HAVE_PCI
> > 
> > and
> > 
> > config PCI
> >         bool "PCI support"
> >         depends on MIGHT_HAVE_PCI
> > 
> > In the first instance, PCI itself does not depend on MIGHT_HAVE_PCI.
> > MIGHT_HAVE_PCI controls whether the user is offered the "PCI support"
> > option.
> > 
> > In the second instance, PCI depends on MIGHT_HAVE_PCI, which must be
> > set to 'y' to offer the option and also if PCI is selected.
> 
> Right, I misread the patch as doing the wrong thing, thanks for
> clearing that up.
> 
> > We want the first behaviour.  Platforms which must have PCI support can
> > continue to select PCI as they currently do, and leave the MIGHT_HAVE_PCI
> > option alone.
> > 
> > Platforms which may optionally have PCI support should select
> > MIGHT_HAVE_PCI instead.
> 
> Yes, that sounds good.
> 
> 	Arnd
> 

OK.
I prepare some patch.

Ulli
