Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab1L1Xhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 18:37:51 -0500
Received: from ironport02-1.csupomona.edu ([134.71.187.45]:34251 "EHLO
	ironport02-1.csupomona.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752182Ab1L1Xhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 18:37:43 -0500
X-Greylist: delayed 970 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Dec 2011 18:37:43 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvwEAIij+06GR/cU/2dsb2JhbABErGaBBYIzNIEANQGeIp89iF4XgxoEiDeMSgGSVQ
Date: Wed, 28 Dec 2011 15:19:25 -0800
From: "Paul B. Henson" <henson@acm.org>
To: linux-kernel@vger.kernel.org
Subject: Broken suspend to RAM on Asus P8P67-M motherboard (bad BIOS?)
Message-ID: <20111228231919.GI8711@bender.csupomona.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have an Asus P8P67-M Pro motherboard which fails to suspend to ram
under Linux yet suspends successfully under Windows 7.

Under Windows 7, suspending results in the typical slowly blinking
power light, and the system wakes up correctly.

Under Linux (tested with 3.0.7 and 3.1.6), on entering suspend mode the
power light turns off and stays off, it does *not* blink. On attempting
to wake up, the power light turns on momentarily and the fans spin up,
the power light goes off again and the fans spin down, then the power
light/fans come on but nothing happens, the box is completely wedged,
not even the reset button works, requiring a hard power cycle to bring
back.

While working on the issue, I noticed the following suspicious ACPI
errors logged when doing a core test of STR:

Dec 28 14:28:41 htpc-lr kernel: ACPI: Preparing to enter system sleep
state S3
Dec 28 14:28:41 htpc-lr kernel: ACPI Error: [RAMB] Namespace lookup
failure, AE_NOT_FOUND (20110623/psargs-359)
Dec 28 14:28:41 htpc-lr kernel: ACPI Error: Method parse/execution
failed [\_PTS] (Node ffff88011e8a3a38), AE_NOT_FOUND
(20110623/psparse-536)

There is also an ACPI complaint during boot:

ACPI Error: [RAMB] Namespace lookup failure, AE_NOT_FOUND
(20110623/psargs-359)
ACPI Exception: AE_NOT_FOUND, Could not execute arguments for [RAMW]
(Region) (20110623/nsinit-349)

The core test worked fine with no issues. I'm pretty sure the root cause
of the problem is that the system is not correctly entering S3 due to
these ACPI issues (given the lack of the usual blinking power light).
I'm guessing there's something broken in the BIOS and have opened a
support request with Asus.

However, given it "works under Windows (tm)" 8-/, I don't anticipate a timely
response from Asus <sigh>.

Clearly Windows is working around whatever BIOS problem exists. If it's
not too ugly or distasteful, it would be nice if Linux could do so as
well, I hate it when Windows seems more robust ;). I would have normally
opened a bug, but as the kernel bugzilla is still down it seems the
recommendation is to post to the mailing list instead. I'm not
subscribed to the list, but if someone working on power
management/suspend code is interested in trying to get Linux working as
well as Windows on this hardware, I'd greatly appreciate being contacted
directly; or CC'd if there is any discussion on the list.

Thanks much...

