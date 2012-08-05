Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab2HEVoS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 17:44:18 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:50096 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489Ab2HEVoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 17:44:17 -0400
MIME-Version: 1.0
In-Reply-To: <20120805214016.GH12232@phenom.ffwll.local>
References: <1344009741-14248-1-git-send-email-seth.forshee@canonical.com>
	<1344009741-14248-4-git-send-email-seth.forshee@canonical.com>
	<20120803161416.GA22563@srcf.ucam.org>
	<20120803162451.GF8165@thinkpad-t410>
	<20120803162702.GA22896@srcf.ucam.org>
	<20120804165727.GA4980@thinkpad-t410>
	<20120805211412.GG12232@phenom.ffwll.local>
	<20120805211838.GA27188@srcf.ucam.org>
	<20120805214016.GH12232@phenom.ffwll.local>
Date: Mon, 6 Aug 2012 07:44:16 +1000
Message-ID: <CAPM=9twHbwzPxFbpeXOP2eANVQssVaOHuztG9FDM4CgcQs-9tA@mail.gmail.com>
Subject: Re: [RFC PATCH 3/5] drm/i915: register LVDS connector even if we
 can't get a panel mode
From: Dave Airlie <airlied@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>, dri-devel@lists.freedesktop.org,
        David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        Andreas Heider <andreas@meetr.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 6, 2012 at 7:40 AM, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Sun, Aug 05, 2012 at 10:18:38PM +0100, Matthew Garrett wrote:
>> On Sun, Aug 05, 2012 at 11:14:12PM +0200, Daniel Vetter wrote:
>>
>> > I like this approach more - the only other solution I see is to ask the
>> > currently active driver (i.e. radeon) at bootime for the right mode. Which
>> > sounds much more hellish and fragile ...
>>
>> The "correct" approach is clearly to just have the drm core change the
>> i2c mux before requesting edid, but that's made difficult because of the
>> absence of ordering guarantees in initialisation. I don't like quirking
>> this, since we're then back to the situation of potentially having to
>> add every new piece of related hardware to the quirk list.
>
> The "correct" approach of switching the mux before we fetch the edid is
> actualy the one I fear will result in fragile code: Only run on few
> machines, and as you say with tons of funky interactions with the init
> sequence ordering. And I guess people will bitch&moan about the flickering
> this will cause ;-)
>
> As long as it's only apple shipping multi-gpu machines with
> broken/non-existing vbt, I'll happily stomach the quirk list entries.
> They're bad, but imo the lesser evil.

Well in theory you can switch the ddc lines without switching the other lines,
so we could do a mutex protected mux switch around edid retrival,

Of course someone would have to code it up first then we could see how
ugly it would be.

Dave.
> -Daniel
> --
> Daniel Vetter
> Mail: daniel@ffwll.ch
> Mobile: +41 (0)79 365 57 48
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
