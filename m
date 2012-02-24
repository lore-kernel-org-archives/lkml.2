Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416Ab2BXA3h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 19:29:37 -0500
Received: from jonshouse.co.uk ([91.84.151.33]:54645 "EHLO
	mail.jonshouse.co.uk" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756114Ab2BXA3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 19:29:35 -0500
X-Greylist: delayed 1783 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Feb 2012 19:29:35 EST
Subject: Random process lockup on ARM board: alsa-lib-1.0.25,
 FUTEX_WAIT_PRIVATE
From: Jonathan Andrews <jon@jonshouse.co.uk>
Reply-To: jon@jonshouse.co.uk
To: linux-kernel@vger.kernel.org
In-Reply-To: <4F45167A.6080706@ladisch.de>
References: <1329393691.6830.20.camel@jonspc>
	 <1329512682.29051.1.camel@jonspc> <1329570128.6670.0.camel@jonspc>
	 <4F400BBF.9020707@ladisch.de> <1329603022.1089.57.camel@jonspc>
	 <4F41FC28.1070605@ladisch.de> <1329926198.22918.10.camel@jonspc>
	 <4F45167A.6080706@ladisch.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Feb 2012 00:29:57 +0000
Message-ID: <1330043397.4669.44.camel@jonspc>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using kernel 3.2.5 with alsa-lib 1.0.25, all compiled with generic
Debian arm-linux-gnueabi toolchain.

arm-linux-gnueabi-gcc (Debian 4.3.2-1.1) 4.3.2
Was used to build kernel, alsa-lib and application.

Changing gcc version, kernel version or alsa-lib version makes the
problem worse or better, but ALL versions seem to suffer this problem. I
have also seen it once on Intel (but only once so far).

Something seeks broken at a lower layer than im using.  I simply don't
have the skill to debug it.

The hardware is a USB cm109 audio adapter, but the problem seems to show
on more than this one driver.

The audio application writing to alsa will freezes at random intervals,
infrequent at the moment, last one was after runtime 20H 37M 29S.  Two
processes are running, one reading from the sound device and one writing
to the sound device. I am not using threading or anything very clever
just generic alsa functions.

This is the only diagnostic I can generate so far as running the
application under strace slows it to the point it no longer functions
enough to generate the problem.

ARM / # strace -p 417
Process 417 attached - interrupt to quit
futex(0x175734, FUTEX_WAIT_PRIVATE, 2, NULL^C <unfinished ...>
Process 417 detached

ARM / # uname -a
Linux (none) 3.2.5 #2 Wed Feb 22 17:11:52 GMT 2012 armv4tl GNU/Linux
ARM / # uptime
 22:36:19 up 22:36,  0 users,  load average: 0.15, 0.16, 0.18
ARM / # cat /proc/cpuinfo 
Processor       : ARM920T rev 0 (v4l)
BogoMIPS        : 199.06
Features        : swp half thumb crunch 
CPU implementer : 0x41
CPU architecture: 4T
CPU variant     : 0x1
CPU part        : 0x920
CPU revision    : 0


Any help welcome.

Thanks,
Jon


