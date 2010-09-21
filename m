Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab0IUXxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 19:53:12 -0400
Received: from borg.medozas.de ([188.40.89.202]:53710 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413Ab0IUXxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 19:53:11 -0400
Date: Wed, 22 Sep 2010 01:53:09 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: hpa@linux.intel.com
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: "Glove box" BIOS patch causes boot flicker
Message-ID: <alpine.LNX.2.01.1009220135380.25692@obet.zrqbmnf.qr>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


some (long) time ago, I noticed a change whereby at the start of Linux 
(before any log messages are output) the monitor would do one reset on 
x86/VGA (the classic modes à la 80x25 - no fbdev stuff). It is only now 
that I found enough joy to revisit this.

Between 2.6.30 and 2.6.31, commit cf06de7b9cdd was introduced by you, 
which I have bisected the problem down to.

commit cf06de7b9cdd3efee7a59dced1977b3c21d43732
Author: H. Peter Anvin <hpa@linux.intel.com>
Date:   Wed Apr 1 18:20:11 2009 -0700

    x86, setup: "glove box" BIOS interrupts in the video code
    
    Impact: BIOS proofing
    
    "Glove box" off BIOS interrupts in the video code.

The exact artifacts caused by it are:

- a mode set from 80x25 to 80x25...
- cursor position is reset to the top-left corner, overwriting any 
logs from previous code such as BIOSes or bootloaders. Previously, the 
linux kernel log nicely followed these, now it is intersecting.

("glove box off" is a ventured description to me. Even the German 
translation gave no hint; an image search was required. Suggesting "seal 
off".)

Anyhow, the commit description lacks a bit of information to coders 
whose area of expertise is outside hardware (net/ is what I do), and why 
this commit is needed, given all I seemingly got from it was a 
degradation of my VGA console experience.

Could you elaborate on it, and/or what could be done to address the two 
issues?

thanks,
Jan
