Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab1EKPtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:49:25 -0400
Received: from perninha.conectiva.com.br ([187.115.55.249]:58243 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423Ab1EKPtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:49:21 -0400
Subject: DRM/I915 wrong monitor resolution
From: Alexandre Felipe Muller de Souza <alexandrefm@mandriva.com.br>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1304531944.6868.17.camel@localhost.localdomain>
References: <1304531944.6868.17.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Organization: Conectiva
Date: Wed, 11 May 2011 11:47:37 -0300
Message-ID: <1305125257.26111.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3-1.1mdv2010.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
We encountered a lot of X problems with current Kernel in this specific
hardware:

00:02.0 VGA compatible controller: Intel Corporation Pineview Integrated
Graphics Controller (rev 02) (prog-if 00 [VGA controller])
        Subsystem: Elitegroup Computer Systems Device 2267
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 43
        Region 0: Memory at feb00000 (32-bit, non-prefetchable)
[size=512K]
        Region 1: I/O ports at dc00 [size=8]
        Region 2: Memory at d0000000 (32-bit, prefetchable) [size=256M]
        Region 3: Memory at fea00000 (32-bit, non-prefetchable)
[size=1M]
        Expansion ROM at <unassigned> [disabled]
        Capabilities: <access denied>
        Kernel driver in use: i915
        Kernel modules: i915

The xrandr shows 2 monitors, when only exists 1 (the device even doesn't
have HDMI or TV). The X also can use only bad resolutions for the main
monitor.

I tested <= 2.6.36 kernel and it was ok, and kernel >= 2.6.37 was not
ok.

So, I made a git bisect to discover exactly what commit broked the
driver and I made a fix reverting the commit:
44834a67c0082e2cf74b16be91e4910
Description:
drm/i915: Use the VBT from OpRegion when available (v3)

I think it will be bad to maintain the patch in our kernel, and rediff
it every time we made a kernel update. So I decided to report it, to
know if someone knows how to maintain the commit and fix the problem.

Or it could be a bad (with bugs) hardware?


Thanks a lot
Alexandre

