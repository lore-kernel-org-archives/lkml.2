Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750906Ab0LLFX0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 00:23:26 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:40115 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab0LLFXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 00:23:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=TkGWC6t48pKnY/tIOGCDd3wnecm5jjDWKK633s7+3cIkz5sjkepqvrQVot6qKR5n5o
         926Hvaesa0DUvCzrlr3UlST5kGwK9K2l/jt52hEJBvWRfsnLTMwBDJOqlhb2oEZUHsJ5
         BVd9+cp/+QI2VswI6lTv82BA+bDLsyJGCHriQ=
MIME-Version: 1.0
In-Reply-To: <AANLkTinhHkqpVQp10y6uRp9ug73iXRuF4Bed2okPOdit@mail.gmail.com>
References: <20101208213606.13026.47657.stgit@bob.kio>
	<20101208213627.13026.18854.stgit@bob.kio>
	<AANLkTinhHkqpVQp10y6uRp9ug73iXRuF4Bed2okPOdit@mail.gmail.com>
Date: Sun, 12 Dec 2010 15:23:21 +1000
Message-ID: <AANLkTimOHk5KHQy=DyLfi-rG9m-M=yR2RO1e_mRnD3zR@mail.gmail.com>
Subject: Re: [PATCH 5/5] PNP: HP nx6325 fixup: reserve unreported resources
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Adam Belay <abelay@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 12, 2010 at 1:30 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Dec 8, 2010 at 1:36 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
>>
>> The HP nx6325 BIOS doesn't report any devices in the [0xf8000000-0xfbffffff]
>> region via ACPI devices or the E820 memory map, but when we assign it to the
>> 00:14.4 bridge as a prefetchable memory window, the machine hangs.
>
> Quite frankly, I think this patch sucks.
>
> It sucks because these kinds of hw-specific patches are fundamentally
> a sign of something else being wrong. Why didn't windows hit this? Why
> do we need this total hack?
>
> And is there any reason at all to believe that that one particular
> laptop is really special? I doubt it. And what happens for the next
> random machine that comes along an hits this?
>
> Maybe we should just say that if we know the bridge is negative
> decode, and it hasn't been set up by the BIOS, we just don't allocate
> it at all. And try to look like Windows.
>
> Or figure out what else Windows is doing differently.
>
> The whole "allocate bottom up" old PCI allocation has _years_ of
> testing and quirk that have been gathered over a long time. We can't
> just say "we'll do the same thing for the top-down allocator".
>
> The WHOLE AND ONLY POINT of the top-down allocator was to act lik
> Windows and not need crap like this. If that doesn't work, then I
> seriously don't think we should change bottom-up to top-down at all,
> and for 2.6.37 we should just revert the "set to top-down by default".
>
> Seriously. That "whole and only point" thing is important. If we need
> hacks like this, then we shouldn't do it. We're much better off with
> the model that has year of testing an not the upheaval. Top-down
> allocation is in _no_ way inherently better, the only excuse for it
> was supposed to be "we don't need these kinds of hooks".

I agree, I've got an NX6125 predecessor of this and I'll take any
money that is has an equally insane BIOS, considering its the worst
laptop in my pile in nearly every way imaginable.

and I suspect the HP laptop braindamage won't end with those two.

Dave.
