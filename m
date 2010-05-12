Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042Ab0ELVb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 17:31:56 -0400
Received: from mail.gmx.net ([213.165.64.20]:46218 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757833Ab0ELVbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 17:31:53 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18nw/kDErQnRyb1VO1B6ZplOQwvx1NMbLPPCGCMEU
	AHYSPiL0AtQGSl
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: roger.quadros@nokia.com
Subject: Buildfailure for omap3_defconfig due to patch OMAP: RX51: Add LCD Panel support
Date: Wed, 12 May 2010 23:31:51 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.33.2; KDE/4.3.5; x86_64; ; )
Cc: tomi.valkeinen@nokia.com, roger.quadros@nokia.com, tony@atomide.com,
       khilman@deeprootsystems.com, paul@pwsan.com, jpihet@mvista.com,
       kalle.valo@iki.fi, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201005122331.51347.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

I just wanted to inform you that your Patch
OMAP: RX51: Add LCD Panel support (b499d77834ae292465f8d06bb0a88f1a647dfa1a) 
introduces a build failure for the omap3_defconfig.

You can see the error message here:
http://kisskb.ellerman.id.au/kisskb/buildresult/2601981/

This is due to the fact that omap3_defconfig has
CONFIG_MACH_NOKIA_RX51=y
set which enables the compilation of arch/arm/mach-omap2/board-rx51.c

board-rx51.c calls rx51_video_mem_init in arch/arm/mach-omap2/board-rx51-
video.c which is guarded by 
#if defined(CONFIG_FB_OMAP2) || defined(CONFIG_FB_OMAP2_MODULE)

Unfortunately none if them is set in the omap3_defconfig.

Would be nice if you could fix this :)

Thanks,
Peter

Reported-by: Peter Huewe <peterhuewe@gmx.de>
