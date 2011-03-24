Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab1CXLaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 07:30:52 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53790 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676Ab1CXLau convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 07:30:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=X/simaX5XN4YgSBKg477F4YprshFXphfl0E7FX76sfrvwFswP9VdVjSCaYYAlo930z
         1ATdNBK/zAwHKOHdHDP9k7LjT2s15H8DEc9Af9cuwaLKFaRDjUCMXaKsH8TUZbAemBEF
         Fb2ZMofdpGG5jIwhbW/7VefhK+2NPx7b3jeP0=
MIME-Version: 1.0
Date: Thu, 24 Mar 2011 12:30:49 +0100
Message-ID: <AANLkTimxnG56Q29CpKi7q0kiam2cDKHdB5OjV-vu4he9@mail.gmail.com>
Subject: regression: GM45 on Dell Latitude E6400 display from 1440x900 to
 1024x768 somewhere between 2.6.38-git2 and -git7
From: Alessandro Suardi <alessandro.suardi@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fedora 14 x86_64

[   375.231] (II) intel(0): Integrated Graphics Chipset: Intel(R) GM45
[   375.231] (--) intel(0): Chipset: "GM45"

startx yields:

 2.6.38-git2 and earlier: correct 1440x900 display
 2.6.38-git3 through -git6: not tested due to kernel build errors
 2.6.38-git7 through -git14: wrong 1024x768 display with black bands at sides

Once in wrong mode, xrandr --fb 1440x900 --output LVDS1 --mode 1440x900
 helps return the screen to correct display, but:

 - background image is drawn incorrectly (like a 1440x900 correct one with a
    superimposed 1024x768 starting from upper left corner)
 - mplayer in full screen mode does not actually go full screen, but 1024x768

comparative Xorg logs and dmesg output for 2.6.38-git2 and -git14 available
 upon request; lspci -v says:

00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series
Chipset Integrated Graphics Controller (rev 07) (prog-if 00 [VGA
controller])
	Subsystem: Dell Device 0233
	Flags: bus master, fast devsel, latency 0, IRQ 46
	Memory at f6c00000 (64-bit, non-prefetchable) [size=4M]
	Memory at e0000000 (64-bit, prefetchable) [size=256M]
	I/O ports at ef98 [size=8]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [d0] Power Management version 3
	Kernel driver in use: i915
	Kernel modules: i915

00:02.1 Display controller: Intel Corporation Mobile 4 Series Chipset
Integrated Graphics Controller (rev 07)
	Subsystem: Dell Device 0233
	Flags: bus master, fast devsel, latency 0
	Memory at f6b00000 (64-bit, non-prefetchable) [size=1M]
	Capabilities: [d0] Power Management version 3



thanks,

--alessandro

 "There's always a siren singing you to shipwreck"

   (Radiohead, "There There")
