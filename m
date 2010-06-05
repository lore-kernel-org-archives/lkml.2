Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933249Ab0FELwg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 07:52:36 -0400
Received: from smtp.nokia.com ([192.100.122.233]:50555 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932938Ab0FELwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 07:52:35 -0400
Subject: Re: UBIFS: Oops while rebooting 2.6.34-rc6
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Daniel Mack <daniel@caiaq.de>
Cc: Adrian Hunter <adrian.hunter@nokia.com>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, Sven Neumann <s.neumann@raumfeld.com>
In-Reply-To: <20100507152640.GX30801@buzzloop.caiaq.de>
References: <20100507131652.GT30801@buzzloop.caiaq.de>
	 <1273245826.4537.294.camel@localhost>
	 <20100507152640.GX30801@buzzloop.caiaq.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Jun 2010 14:50:05 +0300
Message-ID: <1275738605.20281.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 (2.30.1.2-6.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 05 Jun 2010 11:52:19.0070 (UTC) FILETIME=[8CEDC9E0:01CB04A5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-07 at 17:26 +0200, Daniel Mack wrote:
> > > # reboot
> > > # [  671.190085] UBIFS: un-mount UBI device 0, volume 1
> > > The system is going down NOW!
> > > Sent SIGTERM to all processes
> > > [  672.083833] Unable to handle kernel NULL pointer dereference at virtual address 000000ac
> > > [  672.094587] pgd = c0004000
> > > [  672.097301] [000000ac] *pgd=00000000
> > > [  672.100850] Internal error: Oops: 817 [#1]
> > > [  672.104919] last sysfs file: /sys/devices/platform/spi_gpio.0/spi0.2/value
> > 
> > It's Firday, and I want to go home, so here is another quick idea for
> > you where to dig.
> > 
> > When the system reboots it re-mounts the FS to RO mode, usually. And
> > there is some emergency remount business (see do_emergency_remount()),
> > which will re-mount the FS even if there are files opened for writing.
> > 
> > So, if there is a UBIFS or VFS bug, and somehow one process is in
> > make_reservation() and is about to write something, and another process
> > managed to re-mount the FS to R/O mode, then we may ooops, because UBIFS
> > frees these 'wbuf' objects when it is mounted to R/O (see
> > ubifs_remount_ro()).
> > 
> > So, inject printks to ubifs_remount_ro() to check this theory.
> > 
> > Have a nice weekend and bughunting!
> 
> Thanks for your feedback - I'll give that a try next week.

Was you able to reproduce this oops?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

