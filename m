Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933649Ab1J2RqQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 13:46:16 -0400
Received: from ackle.nomi.cz ([81.31.33.35]:56912 "EHLO ackle.nomi.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933496Ab1J2RqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 13:46:15 -0400
X-Greylist: delayed 1816 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 Oct 2011 13:46:14 EDT
Date: Sat, 29 Oct 2011 19:15:54 +0200
From: =?utf-8?B?VG9tw6HFoSBKYW5vdcWhZWs=?= <tomi@nomi.cz>
To: linux-kernel@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        linux-wireless@vger.kernel.org
Subject: iwlagn: memory corruption with WPA enterprise
Message-ID: <20111029171554.GA16596@nomi.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

ever since I got this ThinkPad T420, I've been having strange issues, which I
figured are caused by the iwlwifi driver. What happens is that when I'm
connected to a WPA enterprise (not PSK) access point, sooner or later things
start crashing -- sometimes the web browser goes down, and when I run some
heavy task like kernel compilation, I can be almost sure it will fail.

Some more information is provided by other people in this launchpad ticket:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/815148

I'm not a Ubuntu user, though, I'm running Debian with upstream kernels I
compile myself, and the issue still persists. I was able to reproduce it with
3.0.0 from Debian package, with upstream 3.0.4, with 3.1 and even with todays
davem/net-next merged into 3.1 (didn't try current Linus' tree, but that I
guess might be unnecessary).

Also, I tried two versions of uCode: 17.168.5.1 from Debian package and
17.168.5.3 from the intellinuxwireless webpage. None helps.

My reproduction steps are a bit different from what's in that launchpad
ticket, so I spell them here:

1. Connect to a WPA-EAP (enterprise) network.
2. Do some networking (torrent is a safe bet).
3. Run make -j4 on the kernel tree.
4. Wait until the compiler reports an internal error, segfaults, or does some
   other weird thing it shouldn't do.
5. When this happens, things start to really go crazy -- if you for example
   run 10 gccs in parallel again and again, and continue to do some
   networking, it will fail every few seconds. Disconnecting from the network
   and connecting again brings you to step 4 again, having to wait until
   something somewhere goes wrong and thing start crashing.

Step 4 is a bit tricky and might sometimes take more than an hour (causing you
to repeat step 3). I've had great success accelerating it by telling my
friends that I just found a configuration which seems to work okay. This,
however, might not really help you reproduce the issue, but it did save me a
couple of tenminutes, I am sure.

Is there anything I can do to track this down? Perhaps try some experimental
uCode or something?

Thanks,
-- 
Tomáš Janoušek, a.k.a. Liskni_si, http://work.lisk.in/
