Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192Ab1HHLLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 07:11:18 -0400
Received: from gw1.transmode.se ([195.58.98.146]:49375 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318Ab1HHLLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 07:11:17 -0400
In-Reply-To: <20110808105201.25396.qmail@science.horizon.com>
References: <OF53580ACE.F420CB68-ONC12578E6.0039189A-C12578E6.0039CD0F@transmode.se> <20110808105201.25396.qmail@science.horizon.com>
Subject: Re: [PATCH] add slice by 8 algorithm to crc32.c
X-KeepSent: EA1BD2B2:B2A7F07F-C12578E6:003D368C;
 type=4; name=$KeepSent
To: "George Spelvin" <linux@horizon.com>
Cc: akpm@linux-foundation.org, fzago@systemfabricworks.com,
        linux-kernel@vger.kernel.org, rpearson@systemfabricworks.com
X-Mailer: Lotus Notes Release 8.5.2FP3 Aug 10, 2010
Message-ID: <OFEA1BD2B2.B2A7F07F-ONC12578E6.003D368C-C12578E6.003D7468@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Mon, 8 Aug 2011 13:11:14 +0200
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.2FP3|July 10, 2011) at
 08/08/2011 13:11:15
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"George Spelvin" <linux@horizon.com> wrote on 2011/08/08 12:52:01:
>
> > I prefer to keep the current code which (at the time) generated good code
> > for at least ppc:
> >    /* Align it */
> >    if (unlikely((long)buf & 3 && len)) {
> >       do {
> >          DO_CRC(*buf++);
> >       } while ((--len) && ((long)buf)&3);
> >    }
>
> Ah, I was looking at fzago's initial patch; I hadn't realized you'd
> tweaked it.  That's pretty much what I was talking about.
>
> Would
>     if (unlikely((long)buf & 3) && len) {
>
> give the compiler better hints?  len != 0 is awfully
> likely, actually.

Doesn't matter on ppc(gcc 4.4.4). The whole while loop is moved out of line
in both cases and the generated asm is identical.

