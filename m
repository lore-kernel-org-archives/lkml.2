Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492Ab1CPCRi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 22:17:38 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:39128 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab1CPCRf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 22:17:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iyh3hSd6QtvICE9kN+FUyZGOEF9RKxmiARdjrwKue2YwkeMKU+TREDWo1W9EndX8ZY
         tx+TsUwgZVhguqo3n+hwk1dI7lpvKwpO7Lw2uWlD1jG8thyHUgizrGJPC1mOShvEqifO
         xRugbMZqnKAzDG4632nUE68+nZubHE6kV3W3Q=
MIME-Version: 1.0
In-Reply-To: <5ddb021757c3aec6d2eda30372a422ee.squirrel@webmail.greenhost.nl>
References: <1298404994-2907-1-git-send-email-mjg@redhat.com>
	<1300125566-29648-1-git-send-email-chris@chris-wilson.co.uk>
	<cb03c0cd31393b476e63c4e699247c91.squirrel@webmail.greenhost.nl>
	<b7da2f$qnp1ps@fmsmga001.fm.intel.com>
	<5060ae708cceef8df998d3f59be5d246.squirrel@webmail.greenhost.nl>
	<20110315112724.6729.qmail@stuge.se>
	<24fd59c964cf67c5ec048caa512afcd6.squirrel@webmail.greenhost.nl>
	<AANLkTim6H3UCCsT1iAR2O=PL=5K4ypkT7UqcjqbAf3Vp@mail.gmail.com>
	<5ddb021757c3aec6d2eda30372a422ee.squirrel@webmail.greenhost.nl>
Date: Tue, 15 Mar 2011 22:17:34 -0400
Message-ID: <AANLkTim1JrkhXyQgp3=BU=9uWEN2D7QQg-DJdTk1wEzL@mail.gmail.com>
Subject: Re: [PATCH] ACPI/Intel: Rework Opregion support
From: Alex Deucher <alexdeucher@gmail.com>
To: Indan Zupancic <indan@nul.nu>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Matthew Garrett <mjg@redhat.com>, Len Brown <lenb@kernel.org>,
        Alan Cox <alan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 8:02 PM, Indan Zupancic <indan@nul.nu> wrote:
> On Tue, March 15, 2011 17:06, Alex Deucher wrote:
>> On Tue, Mar 15, 2011 at 7:46 AM, Indan Zupancic <indan@nul.nu> wrote:
>>> They don't give their Linux devs any Fusion hardware, nor do they
>>> open the UVD spec, but at least they release info like this.
>>
>> They do give us fusion hw; before launch even.  That's why we had
>> Linux support before hw was available publicly.  My board just
>> happened to get bricked recently during a failed bios upgrade.
>> A new one is on the way.
>
> Okay, that's better than I thought. I remember a dev saying that
> no one had Fusion hardware, that's where I got this notion from.
>
>> Also we are looking into a potential release of
>> UVD, but unfortunately, our decode hw is intimately tied in with
>> our drm implementation and if someone managed to use the released
>> information to compromise the drm in our windows driver it would very
>> negatively impact our ability to sell into the windows market and
>> would probably get the open source graphics initiative shut down.
>
> Are you talking about HDCP or something else? Because the HDCP master
> key already leaked, so the whole security aspect of it is already a
> joke, open source UVD won't make any difference.
>

It's not HDCP, encrypted bluray is the main issue.  And while there
are hacks for bluray around already, contractual obligations don't
care whether existing hacks are available or not.

> Basically you're telling me that I or someone else should reverse
> engineer de Catalyst driver and break all drm before you consider
> opening up UVD? I'd argue that opening up UVD now is more secure
> because it takes away the only morivation to break UVD's drm.
>
> Alternatively, can't you open up UVD spec except the drm bits,
> so people can at least write their own UVD driver to watch
> unencrypted data?

Without going into detail, they are very intertwined.  The hw was
designed long before we planned to support open source as much as we
are now.  Fortunately, we have been working with our hw teams to make
future UVD implementations take the open source driver into account.

>
> It would be nice to have an open source Fusion based media player/
> IPTV decoder, but I guess that's hoping for too much.
>
> I understand if AMD/ATI wants to keep its 3D driver secret, but
> hardware video decoding?! If you have to keep it secret it means
> shortcuts were taken and it's all insecure anyway. That if it gets
> broken the Open source driver gets blamed is ridiculous and more
> politics than anything else.

We don't keep the 3D engine secret.  Most of the code we've written
and specs we've released are 3D engine stuff.  Fortunately 3D is less
tied up in drm compared to video.  It's all about mitigating risk.
Imagine you run a company and someone asks you this:  "Can we release
programming info for a part of our chip to support 2-3% of our market
that may put at risk 90% of our market?"  What would you do?  The
reason the review is taking so long is that we want to be real sure
that the risk is safe.

>
> This is getting more and more off-topic though, sorry for the noise.
>

Agreed.

Alex

> Greetings,
>
> Indan
>
>
>
