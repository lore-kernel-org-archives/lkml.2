Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716Ab0GWBPS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 21:15:18 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:36865 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756947Ab0GWBPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 21:15:16 -0400
Date: Fri, 23 Jul 2010 10:15:14 +0900
From: Norbert Preining <preining@logic.at>
To: linux-kernel@vger.kernel.org
Subject: changing the default cpufreq governor freezes laptop on suspend
Message-ID: <20100723011514.GD19985@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

(please Cc)

some time ago I switched from 2.6.35-rc1 to -rc2 and about the same time
I regularly got problems with suspend to ram. I first thought that this
is a graphics card issue 
(see http://marc.info/?l=linux-kernel&m=127582534931581&w=2)
but it turned out that using echo mem > /sys/power/state works very
reliable.

I finally got around to check the scripts of pm-utils managing the
suspend process here on Debian/sid, and I found that one of the
scripts, before going to sleep, changes the default cpufreq governor
to performance, doing in principle:
	cat /sys/devices/system/cpu/cpuN/cpufreq/scaling_governor > savedstate
	echo "performance" > /sys/.....
Interestingly, as soon as I disabled these two line the suspend process
became again as stable as before using pm-utils, and as stable as the
echo mem method.

My laptop is intel core2:
Intel(R) Core(TM)2 Duo CPU     P9500  @ 2.53GHz
running Debian/sid, on self compiled git kernels pulled from Linus' repo.

Please let me know what further information I can provide, or how to help

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
CLOVIS (q.v.)
One who actually looks forward to putting up the Christmas decorations
in the office.
			--- Douglas Adams, The Meaning of Liff
