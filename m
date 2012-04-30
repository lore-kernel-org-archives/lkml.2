Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab2D3BaH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 21:30:07 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51557 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753911Ab2D3BaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 21:30:04 -0400
X-Sasl-enc: 3ya6Gfya1aFOeNV4yvKxz1ElzW5l8rUI69Ud87iCwlD2Czb99pXMhFi2Rg 1335749402
Message-ID: <1335749398.2281.0.camel@perseus.themaw.net>
Subject: Re: autofs: make the autofsv5 packet file descriptor use a
 packetized pipe
From: Ian Kent <raven@themaw.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Tokarev <mjt@tls.msk.ru>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Thomas Meyer <thomas@m3y3r.de>, autofs@vger.kernel.org
Date: Mon, 30 Apr 2012 09:29:58 +0800
In-Reply-To: <CA+55aFzDhkVzaUYQwKbkUqoRNb223+w0-k=pOxTZHja75JOMvQ@mail.gmail.com>
References: <20120429205429.63CCD7C0064@ra.kernel.org>
	 <4F9DD994.70202@zytor.com>
	 <CA+55aFy72rPMq3M2_PU0ue45Fb38_Effrfhu2uOpdVXt9H1XOg@mail.gmail.com>
	 <4F9DDCB6.1070908@zytor.com>
	 <CA+55aFwGZm4+rdJ+xArhsVJ8P5gH3xxCfuoHibotr0Sik484=w@mail.gmail.com>
	 <4F9DDE47.5060008@zytor.com>
	 <CA+55aFzDhkVzaUYQwKbkUqoRNb223+w0-k=pOxTZHja75JOMvQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-04-29 at 17:43 -0700, Linus Torvalds wrote:
> On Sun, Apr 29, 2012 at 5:35 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> >
> > Which is funny/sad, because that's actually the intended way the
> > interface is meant to work.
> 
> Well, the autofs packet model is actually horribly badly misdesigned
> even for that: the header doesn't contain the size of the packet. It
> contains the packet *type*, and from that you can then determine the
> size (of course, every other program would determine it *wrongly* for
> this whole x86-64 alignment reason), but that is actually a horrible
> model because it assumes you know all the packet types.
> 
> (There's a "len" field in the v5 packet, but that's not the packet
> length, that's the length of the name component)
> 
> And the reason nobody does that is that in practice there is only ever
> one single type of packet that is possible anyway, so there's no point
> in even reading the header to find the type.
> 
> So a much nicer model is one where the actual *size* of the packet is
> in the header. That would have allowed for not having that fixed
> maximum size of a name etc, and would have avoided the whole problem
> to begin with.
> 
> Of course, the nicest model of all is to just use a packetized
> interface to begin with, so that none of these issues exist. Which is
> what we're now effectively moving to, unless we can find some horrible
> program that makes that impossible due to it playing games and knowing
> it's a "stream".
> 
> Looking at am-utils, I think we're ok so far. But maybe you know of
> yet another crazy user of the autofs interfaces.

autodir looks ok as well.

http://sourceforge.net/projects/intraperson/files/latest/download

> 
>                       Linus


