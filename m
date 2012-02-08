Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab2BHONc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 09:13:32 -0500
Received: from mail1.windriver.com ([147.11.146.13]:58111 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab2BHONb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 09:13:31 -0500
Date: Wed, 8 Feb 2012 09:12:59 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Jiri Slaby <jirislaby@gmail.com>
CC: Alan Cox <alan@linux.intel.com>, Sam Ravnborg <sam@ravnborg.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, <linux-serial@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] serial: relocate remaining serial drivers from tty/ to
 tty/serial/
Message-ID: <20120208141258.GA3223@windriver.com>
References: <1325707287-31038-1-git-send-email-paul.gortmaker@windriver.com>
 <4F04BFA8.9010100@windriver.com>
 <20120104220332.GA22985@suse.de>
 <201201042327.33739.arnd@arndb.de>
 <20120105054240.GA9093@merkur.ravnborg.org>
 <20120105124505.73c88f2c@bob.linux.org.uk>
 <20120105232142.GA10870@windriver.com>
 <4F324ECB.7040102@gmail.com>
 <4F324F4B.3090500@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4F324F4B.3090500@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: [PATCH] serial: relocate remaining serial drivers from tty/ to tty/serial/] On 08/02/2012 (Wed 11:32) Jiri Slaby wrote:

> 
> Hmm, these cannot be built now :(. Why did you move them?
> 
> It looks like they should be moved back.

Once again, sorry for the brown paper bag moment.  :(

Greg, can you ensure this gets applied at your earliest convenience?

Thanks a lot.
Paul.

---

>From 309293f382ce9beef6d8a0fd8b3cedc9900f66e1 Mon Sep 17 00:00:00 2001
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Wed, 8 Feb 2012 09:05:42 -0500
Subject: [PATCH] m32r: relocate drivers back out of 8250 dir

Commit 9bef3d4197379a995fa80f81950bbbf8d32e9e8b

	"serial: group all the 8250 related code together"

inadvertently swept up the m32r driver in the move, because
it had comments mentioning 8250 registers within it.  However
these are only there by nature of the driver being based off
the 8250 source code -- the hardware itself does not actually
have any relation to the original 8250 style UARTs.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/tty/serial/{8250 => }/m32r_sio.c     |    0
 drivers/tty/serial/{8250 => }/m32r_sio.h     |    0
 drivers/tty/serial/{8250 => }/m32r_sio_reg.h |    0
 3 files changed, 0 insertions(+), 0 deletions(-)
 rename drivers/tty/serial/{8250 => }/m32r_sio.c (100%)
 rename drivers/tty/serial/{8250 => }/m32r_sio.h (100%)
 rename drivers/tty/serial/{8250 => }/m32r_sio_reg.h (100%)

diff --git a/drivers/tty/serial/8250/m32r_sio.c b/drivers/tty/serial/m32r_sio.c
similarity index 100%
rename from drivers/tty/serial/8250/m32r_sio.c
rename to drivers/tty/serial/m32r_sio.c
diff --git a/drivers/tty/serial/8250/m32r_sio.h b/drivers/tty/serial/m32r_sio.h
similarity index 100%
rename from drivers/tty/serial/8250/m32r_sio.h
rename to drivers/tty/serial/m32r_sio.h
diff --git a/drivers/tty/serial/8250/m32r_sio_reg.h b/drivers/tty/serial/m32r_sio_reg.h
similarity index 100%
rename from drivers/tty/serial/8250/m32r_sio_reg.h
rename to drivers/tty/serial/m32r_sio_reg.h
-- 
1.7.9

