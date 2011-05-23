Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030203Ab1EWUGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 16:06:34 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:38636 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932909Ab1EWUGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 16:06:31 -0400
Date: Mon, 23 May 2011 22:06:22 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Subject: Re: select() on /dev/input/eventX not level-triggered?
Message-ID: <20110523200622.GA1590@ucw.cz>
References: <20110519235051.GA9782@elf.ucw.cz>
 <20110523181312.GA20438@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110523181312.GA20438@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2011-05-23 11:13:12, Dmitry Torokhov wrote:
> On Fri, May 20, 2011 at 01:50:51AM +0200, Pavel Machek wrote:
> > Hi!
> > 
> > I'm debugging strange behaviour on /dev/input/eventX ... it seems that
> > select is not behaving level-triggered as it apparently should. I can
> > reproduce it when hitting windows & alt keys.
> > 
> > Now, I really should rewrite it into C, first, but perhaps someone has
> > an idea?

(Ok, so  we agree that select()  should mark descriptor as ready as
long as data are available... right?)

> Is this with next or with mainline? In next we try not to signal that FD
> is ready unless we have full packet in the buffer...

2.6.39-rcX mainline.

> FWIW I see python indeed not reading the tail of events (btw the format
> should be 'llhhi' and the size on 64 bit arches is 24, not 16) but when
> I hacked evtest to use select and non-blockign read it all worked
> properly.

It  was on x32, but I'll fix that, thanks.

Difference was I'm not using non-blocking read(). It is unusual but
should work AFAICT. Just read one packet when select shows its ready;
if there's more than one, don't loop around read, but rely on select
returning immediately.

I did verify it on strace, so it should not  be python artefact.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
