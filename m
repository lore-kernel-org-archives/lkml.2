Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab0IVJOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 05:14:17 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:65132 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab0IVJOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 05:14:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/2] TTY: create /tty and move the tty core files there
Date: Wed, 22 Sep 2010 11:13:58 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, Jiri Slaby <jslaby@suse.cz>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Rogier Wolff <R.E.Wolff@bitwizard.nl>,
        "Michael H. Warfield" <mhw@wittsend.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
References: <1283115995-4734-1-git-send-email-arnd@arndb.de> <20100921230733.GA32346@kroah.com> <20100921230804.GB32346@kroah.com>
In-Reply-To: <20100921230804.GB32346@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009221113.58202.arnd@arndb.de>
X-Provags-ID: V02:K0:JtHG/Bj33LwhebxJcgvcL6CnNPoz3LiPMdFZss3cdSY
 8XDPOWkUlhqpFkzHGJd9iwNM3fYNcsXMqATkjy8uVK4kSmk9RJ
 ZBG8SKQfdCPl6HCJDU7k6LpxqT8dBCMxpk6g9WAC8il8tQreFl
 QfxNnaak8UHqmZUFLXKjetwhwfBt/o4Ux3zrr/mUD7LkICbjxh
 rO1UuF/rzTMkBqEIdBFkg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 September 2010, Greg KH wrote:
> The tty code should be at the root of the tree, as everyone
> needs it, and it's always built, and it's not really a "driver"
> 
> Based on work done by Arnd Bergmann <arnd@arndb.de>
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Jiri Slaby <jslaby@suse.cz>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  Makefile                           |    2 +-
>  drivers/char/Makefile              |    4 +---
>  tty/Makefile                       |    8 ++++++++
>  {drivers/char => tty}/n_tty.c      |    0
>  {drivers/char => tty}/tty_audit.c  |    0
>  {drivers/char => tty}/tty_buffer.c |    0
>  {drivers/char => tty}/tty_io.c     |    0
>  {drivers/char => tty}/tty_ioctl.c  |    0
>  {drivers/char => tty}/tty_ldisc.c  |    0
>  {drivers/char => tty}/tty_mutex.c  |    0
>  {drivers/char => tty}/tty_port.c   |    0

My original patch also moved pty.o, sysrq.o and the n_*.o line disciplines.
It's probably debatable where the line disciplines should go (I don't care
much, so don't ask me), but pty and sysrq seem like they should really
be part of the tty core directory.

	Arnd
