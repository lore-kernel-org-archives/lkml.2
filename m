Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab0FMHIH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 03:08:07 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36671 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458Ab0FMHIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 03:08:05 -0400
Date: Sun, 13 Jun 2010 08:58:37 +0200
From: Borislav Petkov <bp@alien8.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Paolo Giarrusso <p.giarrusso@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Borislav Petkov <borislav.petkov@amd.com>,
       Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>
Subject: Re: [uml-devel] [PATCH] x86, hweight: Fix UML boot crash
Message-ID: <20100613065837.GA5623@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Paolo Giarrusso <p.giarrusso@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Borislav Petkov <borislav.petkov@amd.com>,
	Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>,
	user-mode-linux-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>
References: <20100530170346.GC1565@liondog.tnic>
 <4C02B020.2040103@zytor.com>
 <20100530193956.GA2498@liondog.tnic>
 <20100530201738.GB2498@liondog.tnic>
 <4C02D408.1030306@zytor.com>
 <AANLkTimPSQ3K6ulqGV243w__IbMaJTG71VckB8gl701u@mail.gmail.com>
 <20100612141837.GA28572@liondog.tnic>
 <AANLkTimcocYzWrP_5Dv3PxwxMZMq-AtDLfDkYpayuPzG@mail.gmail.com>
 <20100612163444.GC28572@liondog.tnic>
 <AANLkTinMHWI0xGRW-clKm5O91c0QdMG5tDNf3jvUB8Ij@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTinMHWI0xGRW-clKm5O91c0QdMG5tDNf3jvUB8Ij@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Sat, Jun 12, 2010 at 08:37:39PM +0200

> > Cool :). However, according to Geert, this doesn't fix it:
> >
> > http://marc.info/?l=linux-kernel&m=127522065202435&w=2
> >
> > It could be related to the -mregparm being broken on 32-bit UML since
> > Geert's UML "guest" is 32-bit. However, even if we fix this, it won't
> 
> No, guest and host are both x86_64.

Ok, maybe I don't understand UML - it's just that all address values in
the backtrace are 32-bit (e.g. RDX: 00000000ffff8aed, with the upper
8 bytes zeroed out) and I assumed that this is a 32-bit "guest" on a
64-bit host.

-- 
Regards/Gruss,
    Boris.
