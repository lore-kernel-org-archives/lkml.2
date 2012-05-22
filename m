Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab2EVGMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 02:12:31 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62384 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab2EVGM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 02:12:29 -0400
MIME-Version: 1.0
Date: Tue, 22 May 2012 11:42:28 +0530
Message-ID: <CANc+2y50jirP=_V0qBkDuVwkhcmJWo3tQ-rwnxOtw3GQ5gP3tQ@mail.gmail.com>
Subject: Why USB Link Power Management only for devices connected to root hub
From: prasannatsmkumar <prasannatsmkumar@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have started looking into USB stuff. In the EHCI driver code I could
see the comment that "we only support lpm device connected to root hub
yet" in drivers/usb/host/ehci-pci.c line 466 (3.4 kernel -
http://lxr.free-electrons.com/source/drivers/usb/host/ehci-pci.c#L466).
Is there any reason to not support lpm in devices connected to hub
(other than root hub)? Also inside ehci_lpm_check function in
drivers/usb/host/ehci-lpm.c (3.4 kernel -
http://lxr.free-electrons.com/source/drivers/usb/host/ehci-lpm.c) the
USB device is asked to go to LPM mode and there is a wait for 10ms. I
guess the LPM transition (L0 to L1 state transition) should take place
within some micro seconds then why should we wait for 10ms for ACK?

Thanks,
Prasanna Kumar T S M
