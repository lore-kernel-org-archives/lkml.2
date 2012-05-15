Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab2EOF1E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 01:27:04 -0400
Received: from mtv-iport-2.cisco.com ([173.36.130.13]:22978 "EHLO
	mtv-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab2EOF1D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 01:27:03 -0400
X-Greylist: delayed 568 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 May 2012 01:27:03 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av8EAMrlsU+rRDoI/2dsb2JhbAA6CrAng1SBB4IXAQQSAR0KUQEqBhgHVwEEGxqHawGZX4EooAmLEg8SgjmCQ2MEiGSbcIFpgwmBNw
X-IronPort-AV: E=Sophos;i="4.75,591,1330905600"; 
   d="scan'208";a="44820232"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: CFA 4.0 patch
Date: Mon, 14 May 2012 22:17:33 -0700
Message-ID: <4E75C4FECC27A44E9F7E0737D71946900F686C61@xmb-sjc-21e.amer.cisco.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: CFA 4.0 patch
Thread-Index: Ac0yVjghRQI/rP3bSCOVdgaBzmSzXwAAAr5gAADruFA=
From: "Andre Hedrick (anhedric)" <anhedric@cisco.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 15 May 2012 05:17:34.0017 (UTC) FILETIME=[08D40310:01CD325A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a missing part of the CFA 4.0 and above support.

6.2.1.6.1 Word 0: General Configuration
	This field indicates the general characteristics of the device.
When Word 0 of the Identify drive information is 848Ah then the device
is a CompactFlash Storage Card and complies with the CFA specification
and CFA command set. It is recommended that PC Card modes of operation
report only the 848Ah value as they are always intended as removable
devices.

Bits 15-0: CF Standard Configuration Value
Word 0 is 848Ah. This is the recommended value of Word 0.
	Some operating systems require Bit 6 of Word 0 to be set to 1
(Non-removable device) to use the card as the root storage device. The
Card must be the root storage device when a host completely replaces
conventional disk storage with a CompactFlash Card in True IDE mode. To
support this requirement and provide capability for any future removable
media Cards, alternate handling of Word 0 is permitted.

Bits 15-0: CF Preferred Alternate Configuration Values

044Ah: This is the alternate value of Word 0 turns on ATA device and
turns off Removable Media and Removable Device while 	preserving all
Retired bits in the word.

0040h: This is the alternate value of Word 0 turns on ATA device and
turns off Removable Media and Removable Device while 	zeroing all
Retired bits in the word

Cheers,
Andre
--------------------
The Linux X-ATA/SATA guy


--- linux-2.6.32.orig/include/linux/ata.h	Mon May 14 15:48:24 2012
+++ linux-2.6.32/include/linux/ata.h	Mon May 14 15:51:42 2012
@@ -819,6 +819,10 @@
 {
 	if (id[ATA_ID_CONFIG] == 0x848A)	/* Traditional CF */
 		return 1;
+	if (id[ATA_ID_CONFIG] == 0x044A)	/* Alternative CF w/
removable turned off, preserving retired bits */
+		return 1;
+	if (id[ATA_ID_CONFIG] == 0x0040)	/* Alternative CF w/
removable turned off, zeroing retired bits*/
+		return 1;
 	/*
 	 * CF specs don't require specific value in the word 0 anymore
and yet
 	 * they forbid to report the ATA version in the word 80 and
require the
