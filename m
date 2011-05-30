Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab1E3WEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 18:04:31 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:57008 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751950Ab1E3WE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 18:04:29 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+EmHFhhiuEsAUhqKcEBGcDvdiONqs+8TkH/n7YZm
	ImF9B7/4cfish7
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Greg KH <gregkh@suse.de>
Subject: Re: [GIT PATCH] TTY/serial driver patches for .40
Date: Tue, 31 May 2011 00:04:24 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38.6; KDE/4.4.5; x86_64; ; )
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>
References: <20110523190539.GA17519@kroah.com> <Pine.LNX.4.64.1105261248060.9307@axis700.grange> <20110527010021.GD23506@suse.de>
In-Reply-To: <20110527010021.GD23506@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105310004.24516.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 27 Mai 2011, 03:00:21 schrieb Greg KH:
> > > Here's the big tty/serial merge for .40
> > 
> > /me confused: this patch
> > 
> > > Felipe Balbi (1):
> > >       tty: make receive_buf() return the amout of bytes received
> > 
> > is more than one year old, which I wouldn't care about, if it didn't
> > introduce a regression on my mackerel
> > (arch/arm/mach-shmobile/board-mackerel.c) board. With it in place
> > printing a lot of text over ssh pauses the output multiple times for
> > several seconds. With this patch reverted the behaviour is back to
> > normal. To reproduce one can either cat a few largish files under /etc
> > or just dmesg - if there have been enough messages accumulated.
> 
> I think I'll be reverting this one.

Hi,

maybe that's related to receive_buf returning an unsigned int, which is 
obviously incompatible with -ENODEV, -EINVAL and the likes, which most of the 
functions now return in case of error.
And unfortunately the return value is unfortunately not checked for errors 
either - so the amount is totally screwed then ;)

See the examples in git
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=b1c43f82c5aa265442f82dba31ce985ebb7aa71c

I could create a patch if desired.

Thanks,
Peter
