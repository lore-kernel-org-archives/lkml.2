Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759941Ab0LNUpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 15:45:43 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40980 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759597Ab0LNUpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 15:45:42 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTikogB78xPGiQZpg6nWKYVffr61A_Adm0a+C3mbR@mail.gmail.com>
References: <20101208213606.13026.47657.stgit@bob.kio> <20101208213627.13026.18854.stgit@bob.kio>
 <AANLkTinhHkqpVQp10y6uRp9ug73iXRuF4Bed2okPOdit@mail.gmail.com>
 <20101212061743.GA4974@helgaas.com> <AANLkTikogB78xPGiQZpg6nWKYVffr61A_Adm0a+C3mbR@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 14 Dec 2010 12:44:51 -0800
Message-ID: <AANLkTi=a4kOssPYfdYHW5yn9q03=2_6v4bZeCj4iGsUi@mail.gmail.com>
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

On Tue, Dec 14, 2010 at 12:34 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> That's a maintainable approach. But it's maintainable ONLY if we then
> don't do other random changes that invalidates all the years of
> testing we've had.

Btw, looking at all the x86-specific commits that have gone in, I'm
*extremely* unhappy that they apparently stopped honoring that
"resource_alloc_from_bottom" flag that I explicitly asked for.

So it looks like it's not enough to just set that flag. We have to
actually revert all the commits in this area as broken.

Which is sad, but since they clearly *are* broken and don't honor the
flag that was there explicitly to avoid this problem and make it easy
to test reverting it, I'm really pissed off. The WHOLE POINT of that
flag was to give people an option to say "use the old resource
allocation order because the new one doesn't work for me".

So at this point the only question is whether I should just revert the
whole effing lot, or whether there are patches to fix the code to
honor the "allocate from bottom" bit and then just set it by default
again.

Bjorn? Preferences?

                           Linus
