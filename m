Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab0DVJre (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 05:47:34 -0400
Received: from relay01.mx.bawue.net ([193.7.176.67]:42785 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631Ab0DVJrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 05:47:32 -0400
X-Greylist: delayed 459 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Apr 2010 05:47:32 EDT
Date: Thu, 22 Apr 2010 11:39:49 +0200
From: Nils Radtke <Nils.Radtke@Think-Future.de>
To: linux-kernel@vger.kernel.org
Subject: iwlagn + some accesspoint = hardlock
Message-ID: <20100422093949.GC16001@localhost>
Reply-To: Nils Radtke <Nils.Radtke@Think-Future.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://www.Think-Future.de
X-Editor: Vi it! http://www.vim.org
X-Bkp: p2mi
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello there,

 today a somewhat unprecise report:

When connecting to the local university's wireless APs, rather regularly 
presumably the kernel crashes.

So, connecting to one of those the system hardlocks. No panic LED blinking, no mouse cursor moving, 
no magic sysreq key working. Poweroff is the only way to revive the machine. Until the upcoming
lock-up.

What might serve as a hint: using knemo and kwifimanager (with wpa_supplicant in the bg) it feels like it is 
freezing more frequently. Not running kwifimanager seems to reduce the frequency w/o however eliminating it
completely. Sometimes iceweasel has been touched and then the crash occurred. 
Maybe some TX (or subsequent RX) provokes the crash? Some idea that also came up was that accessing iwlagn 
drivers isn't clean when it's happening from more that one place at the same time 
(->wpa_supplicant + kwifimanager)?

This behaviour is currently only known to happen in this exact place/location. So one assumption is that it
is somehow correlated to a particular type of access point, firmware respectively. Nonetheless, even
if there's some fw sending kill packets, the kernel should not crash, obviously.

The access points in range are of type:

- one 0:1d:8b PIRELLI BROADBAND SOLUTIONS 
- couple of those 0:40:96 Cisco Systems, Inc.
- one 0:1a:70 Cisco-Linksys

This notebook has no serial port, so we haven't been able to get a glimpse on what is happening at that 
precise moment. xconsole or dmesg haven't been helpful as the system just freezes and that's it.

Comments, ideas, fixes welcome...

Cheers,

  Nils

