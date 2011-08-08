Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293Ab1HHLYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 07:24:44 -0400
Received: from gw1.transmode.se ([195.58.98.146]:52328 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023Ab1HHLYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 07:24:41 -0400
In-Reply-To: <OFEA1BD2B2.B2A7F07F-ONC12578E6.003D368C-C12578E6.003D7468@LocalDomain>
References: <OF53580ACE.F420CB68-ONC12578E6.0039189A-C12578E6.0039CD0F@transmode.se> <20110808105201.25396.qmail@science.horizon.com> <OFEA1BD2B2.B2A7F07F-ONC12578E6.003D368C-C12578E6.003D7468@LocalDomain>
Subject: Re: [PATCH] add slice by 8 algorithm to crc32.c
X-KeepSent: 9A3189D7:99329960-C12578E6:003E70D6;
 type=4; name=$KeepSent
To: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Cc: "George Spelvin" <linux@horizon.com>, akpm@linux-foundation.org,
        fzago@systemfabricworks.com, linux-kernel@vger.kernel.org,
        rpearson@systemfabricworks.com
X-Mailer: Lotus Notes Release 8.5.2FP3 Aug 10, 2010
Message-ID: <OF9A3189D7.99329960-ONC12578E6.003E70D6-C12578E6.003EAE6D@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Mon, 8 Aug 2011 13:24:38 +0200
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.2FP3|July 10, 2011) at
 08/08/2011 13:24:38
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joakim Tjernlund/Transmode wrote on 2011/08/08 13:11:14:
>
> "George Spelvin" <linux@horizon.com> wrote on 2011/08/08 12:52:01:
> >
> > > I prefer to keep the current code which (at the time) generated good code
> > > for at least ppc:
> > >    /* Align it */
> > >    if (unlikely((long)buf & 3 && len)) {
> > >       do {
> > >          DO_CRC(*buf++);
> > >       } while ((--len) && ((long)buf)&3);
> > >    }
> >
> > Ah, I was looking at fzago's initial patch; I hadn't realized you'd
> > tweaked it.  That's pretty much what I was talking about.
> >
> > Would
> >     if (unlikely((long)buf & 3) && len) {
> >
> > give the compiler better hints?  len != 0 is awfully
> > likely, actually.
>
> Doesn't matter on ppc(gcc 4.4.4). The whole while loop is moved out of line
> in both cases and the generated asm is identical.

Actually, it does make a difference(must remember to save file before gcc :)
Hard to tell if its any better though. Strangle this impacted the inner loop as well,
it gained an extra addi.

 Jocke

