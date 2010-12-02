Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599Ab0LBNue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 08:50:34 -0500
Received: from casper.infradead.org ([85.118.1.10]:59831 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394Ab0LBNud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 08:50:33 -0500
Date: Thu, 2 Dec 2010 13:50:28 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Microcai <microcai@fedoraproject.org>
cc: Vojtech Pavlik <vojtech@suse.cz>, linuxconsole@vger.kernel.org,
        linuxconsole-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Kernel fbcon UNICODE font support
In-Reply-To: <1290932981.710.2.camel@cai.gentoo>
Message-ID: <alpine.LFD.2.00.1012020137320.28091@casper.infradead.org>
References: <1290750825.2372.59.camel@cai.gentoo> <20101127125742.GD4865@const.famille.thibault.fr> <AANLkTikfS+c93skkUFNLVJNah0DsjAUPE2jFNAQCAnCg@mail.gmail.com> <20101128081528.GA20705@suse.cz> <1290932981.710.2.camel@cai.gentoo>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1985284609-287301345-1291255126=:28091"
Content-ID: <alpine.LFD.2.00.1012021344090.19542@casper.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1985284609-287301345-1291255126=:28091
Content-Type: TEXT/PLAIN; CHARSET=ISO-2022-JP
Content-ID: <alpine.LFD.2.00.1012021344091.19542@casper.infradead.org>


> 在 2010-11-28日的 09:15 +0100，Vojtech Pavlik写道：
> > 
> > Well, on VGA you could use the 512 glyphs available (9 bit character, 7
> > bit attribute) and dynamically change the font in the video memory to
> > always contain the characters that you need on the screen. Chances are
> > that you won't need all 512 at any single time. The screen isn't that
> > large in classic VGA mode.
> > 
> > But since VGA is mostly dead these days anyway, it'd be a neat hack, but
> > probably not worth the effort.
> 
> Can't do that. That's too tricky, and some times we *DO* need more than
> 512 different glyphs.

BTW the console developement branch is at 

git://git.infradead.org/~jsimmons/public_git/linuxconsole-2.6.git

	I have managed to do massive cleanup to the console layer but its not 
quite ready for general testing. Its mostly working but there are still 
some major bugs. As for the VC screen buffers the issue is that the default
screen buffers where based on the VGA text mode. In fact the visible VC for
vgacon is the actually vga video buffer. When we do a VT switch it copys 
the video buffer to a software buffer and then loads the vga video buffer 
with the VCs software buffer we switched to. 
	This is nice and neat for vgacon but it doesn't flow so nicely with 
graphical consoles or text LCDs. What I like to see is the attribute 
buffer be split from the vc_screenbuf. The bonus is in embbeded systems we 
could arrange the code so we could have a light weight printk VT without 
the extra junk of the VC. Do we really need a attribute buffer for printk?  
I believe that would be the first step in the right direction.
--1985284609-287301345-1291255126=:28091--
