Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab0LWDzY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 22:55:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36838 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752127Ab0LWDzX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 22:55:23 -0500
MIME-Version: 1.0
In-Reply-To: <c6d829$pujifv@fmsmga001.fm.intel.com>
References: <alpine.DEB.2.00.1012212339090.30885@skynet.skynet.ie>
 <s5hei99vkqj.wl%tiwai@suse.de> <c6d829$pujifv@fmsmga001.fm.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 22 Dec 2010 19:54:31 -0800
Message-ID: <AANLkTik4N5Caw2f4nNFgYXDjxwCMvkyLGyTrkz+vDfXS@mail.gmail.com>
Subject: Re: [git pull] drm fixes
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Takashi Iwai <tiwai@suse.de>, Dave Airlie <airlied@linux.ie>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 8:59 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Wed, 22 Dec 2010 17:24:36 +0100, Takashi Iwai <tiwai@suse.de> wrote:
>> The commit 448f53a1ede54eb854d036abf54573281412d650
>>   drm/i915/bios: Reverse order of 100/120 Mhz SSC clocks
>>
>> causes a regression on a SandyBridge machine here.
>> The laptop display (LVDS) becomes blank.  Reverting the commit fixes
>> the problem.
>
> The question is whose BIOS is wrong?

I don't think so.

>                         The Lenovo U160's or the
> Sandybridge SDV? And why does it work for that other OS? <Insert
> rhetorical question of the day here.>

Quite frankly, I don't think the question should *ever* be "whose BIOS
is wrong?"

You should always take for granted that the BIOS is wrong. It's not a
question of "blame the BIOS", it's a question of facts of life.

It's 100% pointless to point fingers and say "the HP BIOS is wrong" or
"the Lenovo BIOS is wrong". Buggy BIOSes happen. ALWAYS. Any code that
relies on the BIOS to such a degree that it either works or not based
on it is by definition broken.

Why does that code need to figure out some LVDS clock from the BIOS?
Why can't the code look at the actual hardware state or similar, since
presumably the screen is on after boot. THAT we can rely on, since a
BIOS that doesn't initialize LVDS is not going to ever ship even as
pre-release.

                        Linus
