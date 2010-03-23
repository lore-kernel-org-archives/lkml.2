Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab0CWQiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 12:38:23 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60849 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755118Ab0CWQiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 12:38:22 -0400
Message-ID: <4BA8EE75.7090303@ti.com>
Date: Tue, 23 Mar 2010 11:38:13 -0500
From: Pavan Savoy <pavan_savoy@ti.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] serial: TTY: new ldisc for TI BT/FM/GPS chips
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

patch below,

 > On Mon, Mar 22, 2010 at 04:19:12PM -0500, pavan_savoy@ti.com wrote:
 > > From: Pavan Savoy <pavan_savoy@ti.com>
 > >
 > > This change adds the Kconfig and Make file for TI's
 > > ST line discipline driver and the BlueZ driver for BT
 > > core of the TI BT/FM/GPS combo chip.
 > >
 > > Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
 > > ---
 > >  drivers/misc/Kconfig        |    1 +
 >
 > Why 'misc'?  Why not 'char' like all the other ldiscs?
 >
 > Or 'drivers/ldisc' to be more specific?

 >We've discussed having /tty or drivers/tty for a while. The ldiscs are
 >currently everywhere - drivers/net, isdn, char ....

 >I am not sure an ldisc directory helps though - slip and ppp are in
 >drivers/net for example and clearly belong there.
 >  #define N_V253               19      /* Codec control over voice 
modem */
 > +#define N_TI_SHARED  20      /* for TI's WL7 connectivity chips */
 >Be more specific or some future TI shared bus protocol might cause
 >confusion N_TI_WL7 sounds fine.
 >Alan

Yes, I just felt that drivers which belong no-where are put up in 
drivers/misc.
Oh and name now changed to N_TI_WL, not WL7 because it kinda works with 
WL6 chips with BT and FM only too, WL7 has the extra GPS core.


 From 4770551c9ae22ee35b3a9ef5cc9395f218962021 Mon Sep 17 00:00:00 2001
From: Pavan Savoy <pavan_savoy@ti.com>
Date: Mon, 22 Mar 2010 14:37:04 -0400
Subject: [PATCH 1/7] serial: TTY: new ldisc for TI BT/FM/GPS chips

A new N_TI_WL line discipline added for TI BT/FM/GPS
combo chips which make use of same TTY to communicate
with chip. This is to be made use of individual protocol
BT/FM/GPS drivers.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
  include/linux/tty.h |    3 ++-
  1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/tty.h b/include/linux/tty.h
index 4409967..8288ee1 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -23,7 +23,7 @@
   */
  #define NR_UNIX98_PTY_DEFAULT	4096      /* Default maximum for Unix98 
ptys */
  #define NR_UNIX98_PTY_MAX	(1 << MINORBITS) /* Absolute limit */
-#define NR_LDISCS		20
+#define NR_LDISCS		21

  /* line disciplines */
  #define N_TTY		0
@@ -48,6 +48,7 @@
  #define N_PPS		18	/* Pulse per Second */

  #define N_V253		19	/* Codec control over voice modem */
+#define N_TI_WL		20	/* for TI's WL connectivity chips */

  /*
   * This character is the same as _POSIX_VDISABLE: it cannot be used as
-- 
1.5.4.3

