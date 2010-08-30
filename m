Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab0H3Izy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 04:55:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:53279 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab0H3Izw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 04:55:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH 4/5] tty/hw: move hardware drivers to drivers/tty/hw
Date: Mon, 30 Aug 2010 10:55:49 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
References: <1283115995-4734-1-git-send-email-arnd@arndb.de> <1283115995-4734-5-git-send-email-arnd@arndb.de> <AANLkTinE6E47=NbdWo28i6Z6i-6QqHUmF1+Tr7u_v8o3@mail.gmail.com>
In-Reply-To: <AANLkTinE6E47=NbdWo28i6Z6i-6QqHUmF1+Tr7u_v8o3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008301055.49600.arnd@arndb.de>
X-Provags-ID: V02:K0:TFAjdFh+cGUQRNqRjuOdCPO5DkI7Q1P506hrCS3A0i5
 5mba2osdbZjyEb/xcc3MgqWV/ToB1cK0FqxUYlGdpMdhx5DodY
 IWM1D0ej57g4Zm+4KGcUEtA1m4Ec6rQZWbrli39xFXWcSzpwhw
 JfTur3NmRq4/oles/DCKY6eym4FsowwKmfe8FQ1HQDtkLs2b1f
 GKTyTZqA6KOw0t+jCOR9g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 29 August 2010, Mike Frysinger wrote:
> >  MAINTAINERS                                        |   22 +-
> >  drivers/char/Kconfig                               |  287 +------------------
> >  drivers/char/Makefile                              |   28 +--
> >  drivers/char/pcmcia/Kconfig                        |   22 --
> >  drivers/char/pcmcia/Makefile                       |    3 -
> >  drivers/tty/Makefile                               |    1 +
> >  drivers/tty/hw/Kconfig                             |  308 ++++++++++++++++++++
> >  drivers/tty/hw/Makefile                            |   27 ++
> >  drivers/{char => tty/hw}/amiserial.c               |    0
> 
> does it need to be in tty/hw/ ?  seems like there's so little in tty/
> to not bother with a further hw/ ...

Well, the idea here was to split the stuff that is commonly used
from the obsolete drivers.

BTW, the bfin_jtag_comm.c looks less obsolete than the rest of those
drivers, so I wasn't completely sure whether or not to move it into
the same place as the others.
My impression was that it should actually be converted into an hvc
driver as a cleanup and moved to drivers/tty/hvc. It can probably
get reduced to one third of its size if you do that.

	Arnd
