Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287Ab0KIDNr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 22:13:47 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:47965 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab0KIDNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 22:13:46 -0500
Subject: PROBLEM: brcm80211 unable to survive suspend/resume cycle
From: Jon Masters <jonathan@jonmasters.org>
To: devel <devel@linuxdriverproject.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: World Organi[sz]ation of Broken Dreams
Date: Mon, 08 Nov 2010 22:13:57 -0500
Message-ID: <1289272437.3916.440.camel@constitution.bos.jonmasters.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks,

I reported this before, but let me open up a new thread for this now
that this driver has landed in 2.6.37-rc1 and been out for a while. I am
able to use this driver (more or less) for daily use on my netbook, but
it is unable survive a suspend/resume cycle without being unloaded and
then reloaded again on resume. That actually seems to work quite well.

I believe the problem is firmware related:

[  553.355497] wl0: wlc_coreinit: ucode did not self-suspend!
[  554.040495] wl0: wlc_suspend_mac_and_wait: waited 83000 uS and
MI_MACSSPNDD is still not on.
[  554.040517] wl0: psmdebug 0x000f8773, phydebug 0x00000000, psm_brc
0x0000
[  554.154625] wl0: wlc_suspend_mac_and_wait: waited 83000 uS and
MI_MACSSPNDD is still not on.
[  554.154647] wl0: psmdebug 0x000f8773, phydebug 0x00000000, psm_brc
0x0000
[  554.270438] wl0: wlc_suspend_mac_and_wait: waited 83000 uS and
MI_MACSSPNDD is still not on.
[  554.270459] wl0: psmdebug 0x000f8773, phydebug 0x00000000, psm_brc
0x0000
[  554.384569] wl0: wlc_suspend_mac_and_wait: waited 83000 uS and
MI_MACSSPNDD is still not on.

After the "ucode did not self-suspend", I then get the subsequent two
line warnings repeated forever until I reload the driver. Sure, it's
probably a firmware issue, but isn't there something the driver can do
to kick it into a full reset if it doesn't come back? It's able to do it
on module load initially...

Jon.


