Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768Ab0GZIMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 04:12:43 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:46595 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab0GZIMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 04:12:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gaOzP4c+NCM3PjYvaYEIlQ5RKiEdQe+BeCNyqjrlkcyHCNF0aiuE3Yd12h8YbSdc1M
         l5IXCUORVD6uJflkMDjR/h937ADSa+TUKgrzBKYnSEhlQhY4WXTacSCGRXZFcI3FcNFI
         U+7iAavuc3fb+ui2DyVrpkKbuCYhXcR5HLgOE=
Date: Mon, 26 Jul 2010 01:12:37 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        torvalds@linux-foundation.org
Subject: Re: Input: twl40300-keypad - fix handling of "all ground" rows
Message-ID: <20100726081237.GA11284@core.coreip.homeip.net>
References: <201007221959.o6MJx9VQ023618@hera.kernel.org>
 <20100724080551.22893752@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100724080551.22893752@infradead.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 24, 2010 at 08:05:51AM -0700, Arjan van de Ven wrote:
> On Thu, 22 Jul 2010 19:59:09 GMT
> Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:
> 
> > Gitweb:
> > http://git.kernel.org/linus/3fea60261e73dbf4a51130d40cafcc8465b0f2c3
> > Commit:     3fea60261e73dbf4a51130d40cafcc8465b0f2c3 Parent:
> > c25f7b763cc35a249232ce612a36a811b0e263f9 Author:     Dmitry Torokhov
> > <dmitry.torokhov@gmail.com> AuthorDate: Tue Jul 20 20:25:35 2010 -0700
> > Committer:  Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > CommitDate: Tue Jul 20 20:29:48 2010 -0700
> > 
> >     Input: twl40300-keypad - fix handling of "all ground" rows
> >     
> >     The Nokia RX51 board code
> > (arch/arm/mach-omap2/board-rx51-peripherals.c) defines a key map for
> > the matrix keypad keyboard. The hardware seems to use all of the 8
> > rows and 8 columns of the keypad, although not all possible locations
> > are used. 
> 
> 
> 
> > +	KEY(4, 8, KEY_10),
> > +
> >  	KEY(5, 0, KEY_Y),
> > +	KEY(5, 8, KEY_11),
> >
> 
> This patch, as merged, is broken. Nowhere in the kernel are KEY_10 and
> KEY_11 defined.... so this causes a compile failure.
> 
> Are you sure you didn't mean KEY_F10 / KEY_F11 ?
> 

Doh! You are absolutely right. The following should fix that...

-- 
Dmitry


Input: RX51 keymap - fix recent compile breakage

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

The changeset 3fea60261e73dbf4a51130d40cafcc8465b0f2c3 broke
compilation as I managed to use non-existent keycodes.

Reported-by: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 arch/arm/mach-omap2/board-rx51-peripherals.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index c5555ca..0348392 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -220,10 +220,10 @@ static int board_keymap[] = {
 	KEY(4, 4, KEY_LEFTCTRL),
 	KEY(4, 5, KEY_RIGHTALT),
 	KEY(4, 6, KEY_LEFTSHIFT),
-	KEY(4, 8, KEY_10),
+	KEY(4, 8, KEY_F10),
 
 	KEY(5, 0, KEY_Y),
-	KEY(5, 8, KEY_11),
+	KEY(5, 8, KEY_F11),
 
 	KEY(6, 0, KEY_U),
 
