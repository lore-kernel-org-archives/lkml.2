Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760055Ab0LNUfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 15:35:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42017 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760039Ab0LNUfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 15:35:12 -0500
MIME-Version: 1.0
In-Reply-To: <20101212061743.GA4974@helgaas.com>
References: <20101208213606.13026.47657.stgit@bob.kio> <20101208213627.13026.18854.stgit@bob.kio>
 <AANLkTinhHkqpVQp10y6uRp9ug73iXRuF4Bed2okPOdit@mail.gmail.com> <20101212061743.GA4974@helgaas.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 14 Dec 2010 12:34:20 -0800
Message-ID: <AANLkTikogB78xPGiQZpg6nWKYVffr61A_Adm0a+C3mbR@mail.gmail.com>
Subject: Re: [PATCH 5/5] PNP: HP nx6325 fixup: reserve unreported resources
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Adam Belay <abelay@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 11, 2010 at 10:17 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
>
> Not really -- the main point here is to make multi-host bridge
> machines work reliably, and I really don't see a way to do that
> without using _CRS.
>
> If we're going to use _CRS, I think in the long run we'll be better
> off if we do it similarly to Windows, despite these early problems.

It's not about any "despite these early problems".

It's about "clearly we're not doing things at all like Windows, and
it's just broken".

The thing is, we will never be able to match Windows exactly. It may
well have random hardcoded quirks we simply don't know about.

I'm perfectly happy with you aiming to use _CRS. I am _not_ happy with
you then using that as an excuse to then do things that don't work.

We will NOT start doing random BIOS-specific quirks just because
top-down allocations hit other bugs than bottom-up ones do. Just no.
We'll continue doing that we have tried to do, which is to perhaps
have quirks that are specific to *hardware* (like the ones in
drivers/pci/quirks.c) and just filling in stuff that some BIOSes are
known to get wrong.

That's a maintainable approach. But it's maintainable ONLY if we then
don't do other random changes that invalidates all the years of
testing we've had.

                            Linus
