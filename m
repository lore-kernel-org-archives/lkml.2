Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383Ab1I2Mui (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 08:50:38 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49650 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756370Ab1I2Muh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 08:50:37 -0400
Date: Thu, 29 Sep 2011 13:50:36 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Long stalls during boot with -next
Message-ID: <20110929125035.GA2085@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Cookie: Whip it, whip it good!
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since Tuesday I've been experiencing stalls on boot with -next kernels.
The boot appears to proceed normally but there appears to be a good ten
second delay somewhere around the late_initcall() stage with no
indication in the logs:

[    3.110000] regulator_init_complete: PVDD_1V2: disabling
[    3.120000] input: gpio-keys as /devices/platform/gpio-keys.0/input/input5
[    3.120000] wm831x-rtc wm831x-rtc.10: hctosys: unable to read the hardware clock
[   13.690000] kjournald starting.  Commit interval 5 seconds
[   13.690000] EXT3-fs (mmcblk0p2): warning: maximal mount count reached, running e2fsck is recommended

(which happens before or at about the time console output starts
appearing, I'd expect it to appear much earlier).  I've had a poke
around and I didn't spot anything yet, none of the development I've
noticed going on recently looks suspicious.
