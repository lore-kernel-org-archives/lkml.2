Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab2D3Ahf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 20:37:35 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:65140 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab2D3Ahd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 20:37:33 -0400
MIME-Version: 1.0
In-Reply-To: <4F9DDD3E.6010801@zytor.com>
References: <20120429205429.63CCD7C0064@ra.kernel.org> <4F9DD994.70202@zytor.com>
 <CA+55aFy72rPMq3M2_PU0ue45Fb38_Effrfhu2uOpdVXt9H1XOg@mail.gmail.com> <4F9DDD3E.6010801@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 29 Apr 2012 17:37:11 -0700
X-Google-Sender-Auth: TSroBgoTP6ktVt6YgC5qcFw8aPs
Message-ID: <CA+55aFyjJa0jeyhXNoa8D5C43T=EfTtr2CkxTc8n+=N_t1w79g@mail.gmail.com>
Subject: Re: autofs: make the autofsv5 packet file descriptor use a packetized pipe
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Tokarev <mjt@tls.msk.ru>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Ian Kent <raven@themaw.net>, Thomas Meyer <thomas@m3y3r.de>,
        autofs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2012 at 5:30 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Incidentally, I think there is a good reason to add a v6 packet type
> regardless, for efficiency: with packetized pipes there really is no
> point in sending a packet which is mostly padding for no good reason.

That I agree with - making a v6 that sends a minimum-sized packets,
and where the readers just always try to read the maximum size.

That said, this is not exactly something high-performance, and copying
the pointless padding to make a fixed-size packet isn't a big deal.
We're talking just 240 extra bytes or so (NAME_MAX is 255, and most
names are obviously much shorter), so I do believe that we might as
well wait unless there are other good cleanups too.

                   Linus
