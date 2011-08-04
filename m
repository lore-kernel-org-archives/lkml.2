Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab1HDPlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 11:41:17 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63714 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895Ab1HDPlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 11:41:14 -0400
Date: Thu, 4 Aug 2011 12:41:03 -0300 (BRT)
From: =?ISO-8859-15?Q?Fr=E9d=E9ric_L=2E_W=2E_Meunier?= 
	<fredlwm@fredlwm.net>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: X unusable rebooting with kexec
Message-ID: <alpine.LNX.2.00.1108040337090.9589@pervalidus.fredlwm.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
X-Archive: encrypt
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the first time I used kexec, and decided to test it to reboot from 
3.0.0 to 3.0.1-rc1. Apparently, all went well until startx. As soon as 
my window manager appeared, the graphics were so corrupt and didn't show 
any text, that the only solution was to reboot, after retrying startx a 
few times. I also tried kexec a second time, rebooting the same 
3.0.1-rc1 kernel, with no luck.

Doing a diff against both dmesg, I noticed the following changes:

MTRR variable ranges enabled:
...
-  2 disabled
+  2 base 00D0000000 mask FFF0000000 write-combining

pci 0000:01:00.0: Boot video device
-PCI: CLS 4 bytes, default 64
+PCI: CLS mismatch (4 != 32), using 64 bytes

What can I do, if anything, to find the cause of this corruption and 
make kexec work as expected ?

The video card is a Radeon HD 5450.
