Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750900Ab2HaEZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 00:25:38 -0400
Received: from infernal.debian.net ([176.28.9.132]:36804 "EHLO
	infernal.debian.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab2HaEZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 00:25:37 -0400
X-Greylist: delayed 1232 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 Aug 2012 00:25:37 EDT
Date: Fri, 31 Aug 2012 06:05:00 +0200
From: Andreas Bombe <aeb@debian.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [REGRESSION] Xorg doesn't like 4e8b14526 "time: Improve sanity
 checking of timekeeping inputs"
Message-ID: <20120831040500.GA6090@amos.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have recently started to get problems with X simply shutting itself
down and returning to the login screen. In the X logs I find:

> [  1492.936] 
> Fatal server error:
> [  1492.936] WaitForSomething(): select: Invalid argument

No messages whatsoever is found in the kernel logs. This error happens
randomly without any correlation to user input, but with a high
likelihood (within a few minutes at most) when a video is playing. It
doesn't matter if the video is in Flash in a browser window or in a
video player playing a local file.

With that somewhat easy test I bisected it down to 4e8b14526 "time:
Improve sanity checking of timekeeping inputs". The latest Linus git
(155e36d40) with a revert of the bisected commit does not show the
problem.

Video is Radeon HD 6950 with open source drivers. Xorg version is the
one currently in Debian unstable (xserver-xorg-core: 2:1.12.3.902-1,
xserver-xorg-video-radeon: 1:6.14.4-5, libdrm: 2.4.33-3).

-- 
Andreas Bombe
