Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab1JSVGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 17:06:34 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47890 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab1JSVGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 17:06:32 -0400
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: Jyrki Kuoppala <jkp@iki.fi>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] Fix to qt1010 tuner frequency selection (media/dvb)
Date: Wed, 19 Oct 2011 22:06:27 +0100
Message-ID: <2165330.TqTdf0zloM@valkyrie>
User-Agent: KMail/4.7.2 (Linux/3.1.0-rc10cc+; KDE/4.7.2; x86_64; ; )
In-Reply-To: <4E7F58BB.5080803@iki.fi>
References: <4E528FAE.5060801@iki.fi> <5010154.A6jI82beuA@valkyrie> <4E7F58BB.5080803@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jyrki,

So after a bit more testing...

[...]

> >>        /* 22 */
> >>        if      (freq<  450000000) rd[15].val = 0xd0; /* 450 MHz
> >>        */
> >> 
> >> -    else if (freq<  482000000) rd[15].val = 0xd1; /* 482 MHz */
> >> +    else if (freq<  482000000) rd[15].val = 0xd2; /* 482 MHz */

This change isn't so good.

With this change, I can no longer tune to channel 21 (474 MHz). If I revert it 
back to 0xd1, it's fine.

[...]

> >> 
> >>        else if (freq<  514000000) rd[15].val = 0xd4; /* 514 MHz
> >>        */
> >> 
> >> -    else if (freq<  546000000) rd[15].val = 0xd7; /* 546 MHz */
> >> +    else if (freq<  546000000) rd[15].val = 0xd6; /* 546 MHz */
> >> +    else if (freq<  578000000) rd[15].val = 0xd8; /* 578 MHz */

(This change is still good though, as this does allow me to now tune to the 
BBC channels in this range).

-Carlos
