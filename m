Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab1CUR3L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 13:29:11 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:37123 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab1CUR3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 13:29:10 -0400
Date: Mon, 21 Mar 2011 10:28:59 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, Krzysztof Helt <krzysztof.h1@wp.pl>,
        Petr Vandrovec <vandrove@vc.cvut.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christian Toutant <ctoutant@matrox.com>,
        Gary Hade <garyhade@us.ibm.com>
Subject: [PATCH v3] matroxfb: remove incorrect Matrox G200eV support
Message-ID: <20110321172859.GB7549@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Gary Hade <garyhade@us.ibm.com>

Remove incorrect Matrox G200eV support that was previously
added by commit e3a1938805d2e81b27d3d348788644f3bad004f2

A serious issue with the incorrect G200eV support that reproduces
on the Matrox G200eV equipped IBM x3650 M2 is the total lack of
text (login banner, login prompt, etc) on the console when X is
not running and total lack of text on all of the virtual consoles
after X is started.

Any concerns that the incorrect code (upstream since October 2008)
has been successfully used on non-IBM G200eV equipped system(s)
appear to be unwarranted.  In addition to the serious/non-intermittent
nature of issues that have been spotted on IBM systems, complete
removal of the incorrect code is clearly supported by the following
Matrox (Yannick Heneault) provided input.
 "It impossible that this patch should have work on a system.
 The patch only declare the G200eV as a regular G200 which is
 not case. Many registers are different, including at least the
 PLL programming sequence. If the G200eV is programmed like a
 regular G200, it will not display anything."

v1 - Initial patch that removed the incorrect code for _all_
     G200eV equipped systems.
v2 - Darrick Wong provided patch that blacklisted the incorrect
     code on G200eV equipped IBM systems leaving it enabled on
     all G200eV equipped non-IBM systems.
v3 - Same code changes included with v1 plus additional 
     justification for complete removal of the incorrect code.

Signed-off-by: Gary Hade <garyhade@us.ibm.com>
Cc: Darrick J. Wong <djwong@us.ibm.com>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Petr Vandrovec <vandrove@vc.cvut.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yannick Heneault <yannick_heneault@matrox.com>
Cc: Christian Toutant <ctoutant@matrox.com>

---
 drivers/video/matrox/matroxfb_base.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/video/matrox/matroxfb_base.c b/drivers/video/matrox/matroxfb_base.c
index a082deb..a74439a 100644
--- a/drivers/video/matrox/matroxfb_base.c
+++ b/drivers/video/matrox/matroxfb_base.c
@@ -1461,13 +1461,6 @@ static struct board {
 		MGA_G100,
 		&vbG100,
 		"MGA-G100 (AGP)"},
-	{PCI_VENDOR_ID_MATROX,	PCI_DEVICE_ID_MATROX_G200EV_PCI,	0xFF,
-		0,			0,
-		DEVF_G200,
-		230000,
-		MGA_G200,
-		&vbG200,
-		"MGA-G200eV (PCI)"},
 	{PCI_VENDOR_ID_MATROX,	PCI_DEVICE_ID_MATROX_G200_PCI,	0xFF,
 		0,			0,
 		DEVF_G200,
@@ -2119,8 +2112,6 @@ static struct pci_device_id matroxfb_devices[] = {
 		PCI_ANY_ID,	PCI_ANY_ID,	0, 0, 0},
 	{PCI_VENDOR_ID_MATROX,	PCI_DEVICE_ID_MATROX_G100_AGP,
 		PCI_ANY_ID,	PCI_ANY_ID,	0, 0, 0},
-	{PCI_VENDOR_ID_MATROX,	PCI_DEVICE_ID_MATROX_G200EV_PCI,
-		PCI_ANY_ID,	PCI_ANY_ID,	0, 0, 0},
 	{PCI_VENDOR_ID_MATROX,	PCI_DEVICE_ID_MATROX_G200_PCI,
 		PCI_ANY_ID,	PCI_ANY_ID,	0, 0, 0},
 	{PCI_VENDOR_ID_MATROX,	PCI_DEVICE_ID_MATROX_G200_AGP,
