Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab0KJHLN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 02:11:13 -0500
Received: from mail.fem.tu-ilmenau.de ([141.24.101.79]:45394 "EHLO
	mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422Ab0KJHLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 02:11:12 -0500
X-Greylist: delayed 616 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Nov 2010 02:11:12 EST
From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
To: Chris Wilson <chris@chris-wilson.co.uk>
Subject: [bisected] i915 regression in post 2.6.36 kernels
Date: Wed, 10 Nov 2010 08:02:19 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36; KDE/4.5.3; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201011100802.20332.johannes.hirte@fem.tu-ilmenau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the latest kernel, I don't get any windows in KDE displayed. After
starting kdm, I get the background picture and the mouse cursor but not the
login window. I can login blindly and a ps on console shows me that the
expected KDE processes are started but still nothing is displayed. 
I've bisected this to:

5c12a07e8073295ce8b57a822f811ac34e4f8420 is the first bad commit
commit 5c12a07e8073295ce8b57a822f811ac34e4f8420
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Wed Sep 22 11:22:30 2010 +0100

    drm/i915: Drop ring->lazy_request
    
    We are not currently using it as intended, so remove the complication.

    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>


hardware is a Gigabyte M912 with

00:00.0 Host bridge: Intel Corporation Mobile 945GME Express Memory Controller Hub (rev 03)
        Subsystem: Giga-byte Technology Device 1999
        Flags: bus master, fast devsel, latency 0
        Capabilities: [e0] Vendor Specific Information: Len=09 <?>
        Kernel driver in use: agpgart-intel

00:02.0 VGA compatible controller: Intel Corporation Mobile 945GME Express Integrated Graphics Controller (rev 03) (prog-if 00 [VGA controller])        
        Subsystem: Giga-byte Technology Device 1999                                                                                                     
        Flags: bus master, fast devsel, latency 0, IRQ 16                                                                                               
        Memory at f2200000 (32-bit, non-prefetchable) [size=512K]                                                                                       
        I/O ports at 18d0 [size=8]                                                                                                                      
        Memory at d0000000 (32-bit, prefetchable) [size=256M]                                                                                           
        Memory at f2300000 (32-bit, non-prefetchable) [size=256K]                                                                                       
        Expansion ROM at <unassigned> [disabled]
        Capabilities: [90] MSI: Enable- Count=1/1 Maskable- 64bit-
        Capabilities: [d0] Power Management version 2
        Kernel driver in use: i915

00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME, 943/940GML Express Integrated Graphics Controller (rev 03)
        Subsystem: Giga-byte Technology Device 1999
        Flags: bus master, fast devsel, latency 0
        Memory at f2280000 (32-bit, non-prefetchable) [disabled] [size=512K]
        Capabilities: [d0] Power Management version 2


regards,
  Johannes
