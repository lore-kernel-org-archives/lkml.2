Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933304Ab1JDSYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 14:24:48 -0400
Received: from hades.mikemestnik.net ([184.106.158.151]:33130 "EHLO
	hades.mikemestnik.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932752Ab1JDSYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 14:24:47 -0400
X-Greylist: delayed 443 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Oct 2011 14:24:47 EDT
Message-ID: <4E8B4CFE.5040508@mikemestnik.net>
Date: Tue, 04 Oct 2011 13:14:22 -0500
From: Mike Mestnik <cheako@mikemestnik.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [optical drive auto-load] [patch request] Add debugging messages
 to optical drive auto-loadtray.
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
  There is an application hammering the first optical drive and I'd like
to discover it's pid and perhaps the name of it's executable.  The
application triggers the drive's auto-loadtray and causes this lovely
feature to become unusable. :(

https://bugs.launchpad.net/linux/+bug/283316/comments/181

I'd like a patch that I could use for testing that would indicate the
application(by pid or path) that causes any of the drives
auto-load/eject features.  These events should be rare enough on every
system to always be logged at an information level.

Please CC me in responses.

On a related note the drives I have require a delay(about 7 seconds)
from the time the tray is indicated as loaded to when the drive is ready
to process read requests.  This causes mount to fail, I've used 'eject
-t $drv; sleep 7; mount $drv;' to counteract this.

The drive is Brand: LG Type: BlueRay Name: Super Multi Blue Model: CH08

arcadia:~# hdparm -i /dev/sr0

/dev/sr0:

 Model=HL-DT-ST BDDVDRW CH08LS10, FwRev=2.00, SerialNo=H94993B4515
 Config={ Fixed Removeable DTR<=5Mbs DTR>10Mbs nonMagnetic }
 RawCHS=0/0/0, TrkSize=0, SectSize=0, ECCbytes=0
 BuffType=unknown, BuffSize=unknown, MaxMultSect=0
 (maybe): CurCHS=0/0/0, CurSects=0, LBA=yes, LBAsects=0
 IORDY=on/off, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
 PIO modes:  pio0 pio3 pio4
 DMA modes:  mdma0 mdma1 mdma2
 UDMA modes: udma0 udma1 udma2 udma3 udma4 udma5 *udma6
 AdvancedPM=no
 Drive conforms to: Unspecified:  ATA/ATAPI-4,5,6,7

 * signifies the current active mode

