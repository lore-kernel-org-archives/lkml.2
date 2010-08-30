Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab0H3M2j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 08:28:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61093 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459Ab0H3M2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 08:28:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 4/5] tty/hw: move hardware drivers to drivers/tty/hw
Date: Mon, 30 Aug 2010 14:28:34 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Mike Frysinger <vapier.adi@gmail.com>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
References: <1283115995-4734-1-git-send-email-arnd@arndb.de> <201008301055.49600.arnd@arndb.de> <20100830115428.24e76ae5@lxorguk.ukuu.org.uk>
In-Reply-To: <20100830115428.24e76ae5@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008301428.34979.arnd@arndb.de>
X-Provags-ID: V02:K0:exRLbStX9uCqE0VbtzRze4vlXzOH2DmlSFAzrq7/XAV
 hWj7jpifHmecttEr25EOXbCw8XANWlvnk+oTx6JTNOCusOYPSS
 SiG6mn4aEztTQ3FoXeGAizSl/depExXG9X3zamt7bkut2Y6VH6
 o2+N9MjxjyAZtjlWne/s32kESwLccZ5m47qsaiCYgixxjXyreQ
 fjjnlM3kI+rcIVLUrXW5g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 August 2010, Alan Cox wrote:
> > My impression was that it should actually be converted into an hvc
> > driver as a cleanup and moved to drivers/tty/hvc. It can probably
> > get reduced to one third of its size if you do that.
> 
> Not sure it makes sense - hvc seems the wrong abstraction.

It seems to be very similar to hvc_tile.c in purpose, which is
the most trivial driver we have. Why would that not work?

Most of bfin_jtag_comm is about interfacing with the tty layer
and providing a kernel thread to do the polling, which is exactly
what hvc_console.c does.

	Arnd
