Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab0FFVy4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 17:54:56 -0400
Received: from zinan.dashjr.org ([173.242.112.54]:52030 "EHLO zinan.dashjr.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754036Ab0FFVyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 17:54:54 -0400
From: "Luke-Jr" <luke@dashjr.org>
To: tomi.valkeinen@nokia.com, slapin@ossfans.org
Subject: OMAP video compile error; regression from 2.6.33-rc4 onward (including current master)
Date: Sun, 6 Jun 2010 16:52:25 -0500
User-Agent: KMail/1.12.4 (Linux/2.6.32-gentoo; KDE/4.3.5; x86_64; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-omap@vger.kernel.org
X-PGP-Key-Fingerprint: CE5A D56A 36CC 69FA E7D2 3558 665F C11D D53E 9583
X-PGP-Key-ID: 665FC11DD53E9583
X-PGP-Keyserver: x-hkp://subkeys.pgp.bet
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201006061652.39248.luke@dashjr.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This doesn't even build, so I don't know how it was tested... Reverting the 
offending commit (simple, but does require conflict resolution) at least lets 
it compile, but I haven't tested whether it alone is enough to work in 
practise yet... hoping Tomi might provide a real fix. Maybe even in time for 
2.6.35 final? :)

https://bugzilla.kernel.org/show_bug.cgi?id=16144

CC      drivers/video/omap/rfbi.o                                               
drivers/video/omap/rfbi.c: In function 'rfbi_get_clocks':                       
drivers/video/omap/rfbi.c:86: error: 'dispc' undeclared (first use in this
function)
drivers/video/omap/rfbi.c:86: error: (Each undeclared identifier is reported
only once
drivers/video/omap/rfbi.c:86: error: for each function it appears in.)          
make[1]: *** [drivers/video/omap/rfbi.o] Error 1                                
make: *** [drivers/video/omap/rfbi.o] Error 2                                   

The 'dispc' referred to herein is and has always been defined in
drivers/video/omap/dispc.c as an anonymous struct.

Broken in...
commit f778a12dd33200513596a0d4d3ba4d5f09e79c09
Author: Tomi Valkeinen <tomi.valkeinen@nokia.com>
Date:   Wed Dec 16 13:18:07 2009 +0200

    OMAP: OMAPFB: fix clk_get for RFBI

    omapfb platform device was still used to get clocks inside rfbi.c

    Signed-off-by: Tomi Valkeinen <tomi.valkeinen@nokia.com>
    Tested-by: Sergey Lapin <slapin@ossfans.org>
