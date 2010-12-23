Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab0LWQvL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 11:51:11 -0500
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:60975 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752286Ab0LWQvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 11:51:09 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Afj+62QPlB/t1FS7M/VTwKi0QyDt8KkSpzqnHUTvhQHFh28RZicSVaPQpK0L6/SCwKYl7bLAybq2opLV9JQm0hsGN46+Q7TKipXX3HVKgNQhWcalq26+V6HBa8eglLhA;
Date: Thu, 23 Dec 2010 08:51:06 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Takashi Iwai <tiwai@suse.de>,
        linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: Re: [git pull] drm fixes
Message-ID: <20101223085106.6e53c427@jbarnes-desktop>
In-Reply-To: <AANLkTik4N5Caw2f4nNFgYXDjxwCMvkyLGyTrkz+vDfXS@mail.gmail.com>
References: <alpine.DEB.2.00.1012212339090.30885@skynet.skynet.ie>
	<s5hei99vkqj.wl%tiwai@suse.de>
	<c6d829$pujifv@fmsmga001.fm.intel.com>
	<AANLkTik4N5Caw2f4nNFgYXDjxwCMvkyLGyTrkz+vDfXS@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Dec 2010 19:54:31 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >                         The Lenovo U160's or the
> > Sandybridge SDV? And why does it work for that other OS? <Insert
> > rhetorical question of the day here.>
> 
> Quite frankly, I don't think the question should *ever* be "whose BIOS
> is wrong?"
> 
> You should always take for granted that the BIOS is wrong. It's not a
> question of "blame the BIOS", it's a question of facts of life.
> 
> It's 100% pointless to point fingers and say "the HP BIOS is wrong" or
> "the Lenovo BIOS is wrong". Buggy BIOSes happen. ALWAYS. Any code that
> relies on the BIOS to such a degree that it either works or not based
> on it is by definition broken.
> 
> Why does that code need to figure out some LVDS clock from the BIOS?
> Why can't the code look at the actual hardware state or similar, since
> presumably the screen is on after boot. THAT we can rely on, since a
> BIOS that doesn't initialize LVDS is not going to ever ship even as
> pre-release.

Oh I wish we could just do that.  Strictly speaking though this isn't
so much of a BIOS issue as it is a ROM issue.  Platform vendors provide
no way of getting at platform configuration details related to graphics
aside from the tables they flash into ROM along with the VBIOS.  The
tables are just like an EDID ROM on a display: they communicate data we
have no other way of getting.

In the particular case of SSC, there's a board down spread spectrum
clock reference source at a fixed frequency.  We can't automatically
determine it at runtime (asking the user "can you see this" at boot
time isn't really an option), so we need to rely on the VBT to tell
us.  The Windows driver uses this data as well, but obviously either
it's incorrect on our SDV (possible) or we're failing to parse the data
correctly (likely).  It's also possible we're failing to look at a bit
that says "use/don't use SSC on this platform" making the frequency
field meaningless.

We'll figure it out or disable SSC enabling altogether failing that
(risking interference with other components like wireless and sound).

-- 
Jesse Barnes, Intel Open Source Technology Center
