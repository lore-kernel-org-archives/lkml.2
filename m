Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903Ab0K1IrN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 03:47:13 -0500
Received: from jablonecka.jablonka.cz ([95.173.69.36]:56985 "EHLO
	jablonecka.jablonka.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab0K1IrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 03:47:09 -0500
X-Greylist: delayed 1898 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Nov 2010 03:47:09 EST
Date: Sun, 28 Nov 2010 09:15:28 +0100
From: Vojtech Pavlik <vojtech@suse.cz>
To: microcai <microcai@fedoraproject.org>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linuxconsole-dev@lists.sourceforge.net
Subject: Re: [PATCH] Kernel fbcon UNICODE font support
Message-ID: <20101128081528.GA20705@suse.cz>
References: <1290750825.2372.59.camel@cai.gentoo>
 <20101127125742.GD4865@const.famille.thibault.fr>
 <AANLkTikfS+c93skkUFNLVJNah0DsjAUPE2jFNAQCAnCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikfS+c93skkUFNLVJNah0DsjAUPE2jFNAQCAnCg@mail.gmail.com>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 28, 2010 at 02:50:49PM +0800, microcai wrote:
> 2010/11/27 Samuel Thibault <samuel.thibault@ens-lyon.org>:
> > Hello,
> >
> > Microcai, le Fri 26 Nov 2010 13:53:45 +0800, a écrit :
> >>  I know there are most people speaking only English, and never meet
> >> non-ASCII characters on console. But, hey , what about others ?
> >
> > Well, you can't deny that there _is_ some support for non-ASCII. But
> > just at most 512 glyphs and single width, indeed.
> >
> >>  The first thing I need to handle is that, currently there is no room
> >> for adding UNICODE font, only 8bit for characters, how can you do?
> >
> > (or 9bit, but no more indeed)
> >
> >>  Also , some characters are double-width. So the solution is  make an
> >> backing store. 0xFE and 0xFF stands for character value store else
> >> where, and 0xFF means , left-half of the else where character, and 0xFE
> >> means right-half of the else where character.
> >>
> >>  This is a basic solution, the best is that making vc->vc_screenbuf
> >> store full UNICODE/attribute value, But changing it may break some
> >> drivers, so , currently I won't try that way.
> >
> > I'd much prefer the full unicode way, however.  Trying to hack around
> > with 0xFE/0xFF will just bring hard-to-fix bugs, while it's quite easy
> > to make sure we capture not-up-to-date drivers by changing field names
> > for instance.  I'd say we should first do that, and then it'll be
> > easy to move the old vgaposition/glyph translation cruft into the few
> > drivers that need it.  Yes, this seems to be the hard way.  But that's
> > the short-term hard then mid-term easy way, which is way easier to
> > accept than the short-term easy then mid/long-term tedious way that you
> > propose.
> >
> 
> I did more work,and found that , VGA console (non framebuffer) realy
> need 8bit/8bit attrib/char , because that's how text mode VGA cards
> interpreter them. changing to full type will break VGA drivers.

Well, on VGA you could use the 512 glyphs available (9 bit character, 7
bit attribute) and dynamically change the font in the video memory to
always contain the characters that you need on the screen. Chances are
that you won't need all 512 at any single time. The screen isn't that
large in classic VGA mode.

But since VGA is mostly dead these days anyway, it'd be a neat hack, but
probably not worth the effort.

> So, I add an u32 * unichars to con_putcs() parameter list, VGA drivers
> just ignore that parameter , but fbcon can use it instead of unsigned
> short *s as real char value. And allocate an backing store buffer to
> store full UNICODE characters.
> Also , I delete vc_hi_font_mask, VGA hardware that support 512 font
> chars turn to use u32*unichars passed to con_putcs()
> 
> Will that acceptable ?

-- 
Vojtech Pavlik
Director SuSE Labs
