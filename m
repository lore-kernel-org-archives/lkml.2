Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab0H3PZE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 11:25:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59505 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab0H3PZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 11:25:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH 4/5] tty/hw: move hardware drivers to drivers/tty/hw
Date: Mon, 30 Aug 2010 17:25:01 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
References: <1283115995-4734-1-git-send-email-arnd@arndb.de> <201008301428.34979.arnd@arndb.de> <AANLkTi=F3xYJ5_umQTT9N7RqQBL04162RVEka5A9YgYN@mail.gmail.com>
In-Reply-To: <AANLkTi=F3xYJ5_umQTT9N7RqQBL04162RVEka5A9YgYN@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008301725.01424.arnd@arndb.de>
X-Provags-ID: V02:K0:6oDLinIyb/r9J8YOHrlkrs0VK8MTubtWbb/x/wNP1J5
 y2peXc43TafzBYlCjpaXnZEggiUIyaF5lcSWfG+FlxmAd1cJlq
 qbPXT7pYA9qpkdwHr283okk7TqmHehrwbkZ4gitA0rH4Op2td1
 r/jvv6u91GuuUHJVMl1IhY5pjpLgYcXpixN+4vgcIB3O55Aof2
 JSdJUr78cBC8rx5k54fIA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 August 2010, Mike Frysinger wrote:
> 
> On Mon, Aug 30, 2010 at 08:28, Arnd Bergmann wrote:
> > On Monday 30 August 2010, Alan Cox wrote:
> >> > My impression was that it should actually be converted into an hvc
> >> > driver as a cleanup and moved to drivers/tty/hvc. It can probably
> >> > get reduced to one third of its size if you do that.
> >>
> >> Not sure it makes sense - hvc seems the wrong abstraction.
> >
> > It seems to be very similar to hvc_tile.c in purpose, which is
> > the most trivial driver we have. Why would that not work?
> >
> > Most of bfin_jtag_comm is about interfacing with the tty layer
> > and providing a kernel thread to do the polling, which is exactly
> > what hvc_console.c does.
> 
> i have no idea what "hvc" is, but my limited knowledge was that it was
> for large powerpc servers, so i didnt bother looking at it too much.
> i simply wanted a way to create a tty on top of the hardware channel.
> if there is a framework that doesnt break this usage and lets me
> simplify my driver, then either works for me.

HVC started out as the console for large powerpc, but has turned into
a generic framework for TTY drivers that are based on simple read/write
operations with or without interrupts. 

Please take a look at drivers/char/hvc_tile.c, which was added recently
for a scenario quite similar to yours (debug port, not irq).

	Arnd
