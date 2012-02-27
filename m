Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab2B0Mzi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 07:55:38 -0500
Received: from wega.rz.tu-ilmenau.de ([141.24.4.159]:52247 "EHLO
	wega.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab2B0Mzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 07:55:37 -0500
Message-ID: <4F4B7CC6.1030307@tu-ilmenau.de>
Date: Mon, 27 Feb 2012 13:53:26 +0100
From: =?UTF-8?B?U3RlcGhhbiBCw6Ryd29sZg==?= 
	<stephan.baerwolf@tu-ilmenau.de>
Reply-To: stephan.baerwolf@tu-ilmenau.de
Organization: TU-Ilmenau
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120217 Thunderbird/10.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 00/10] scheduler-ticker > 1000Hz, nitromethane for linux ;-)
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

this is a not fully serious (this is why I only post it here without sendig it
directly via mail) patchset for:

        * tune the scheduler at configuration point
        * increase the ticker-frequency way above 1000Hz
        * tune the ticker-freq. from userspace during runtime

Of course this increases your systems overhead, but it enables you to have
more timer-triggered contexswitches per second and so (?)higher(?) interactivity.
(Of course after tuning some scheduler-parameters, min_gran, wakeup_gran ...)

An interesting feature might be the userspace controlling of the tickerfreq, too.
(Without disturbing HZ-dependend kernelcode, of course.)

I don't have very high hopes for an mainline integration ;-) but perhaps
there are people, who want to play with such stuff.
The Code is more or less an excerise and perhaps some reviewing would
be nice - so please contact me.
If (in the very unlikely case) there is enough interest in it, I can cleanup
the code and start maintaining it...

* The patch is diffed against 3.2.7
* The whole patchset is also downloadable as an bzipped archive at:
  http://www.matrixstorm.com/software/linux/nitromethane/linux-3.2.7-patches.tar.bz2

So now, please blame me "we don't need such s*it, it causes only overhead"... ;-)

regards Stephan

pub   4096R/FB9B12DB 2011-10-14 Stephan Bärwolf <stephan.baerwolf@tu-ilmenau.de>
 Primary key fingerprint: 2252 B41E 12DF 41AD 476F  7F36 084A 0911 FB9B 12DB



Stephan Baerwolf (10):
  menuconfig: implement new submenu for extended scheduler-options
  sched: implement the new menuconfig controlling of sched_tunables
  menuconfig: extend nitro-menu by responsiveness nitro options
  sched: implement the controlling of responsiveness-nitro-options
  menuconfig: extend nitro-menu by HZ-frequency Nitro
  hrtimer: implement the controlling of nitro-hzboost
  menuconfig: extend nitro-menu by priority-nitro
  sched: implement the controlling of priority-nitro
  menuconfig: extend nitro-menu by userspace-multiplier
  hrtimer/sysctl: implement the controlling of userspace multiplier

 arch/x86/Kconfig            |    4 +-
 include/linux/sched.h       |    8 ++
 kernel/Kconfig.hz           |    3 -
 kernel/Kconfig.sched        |  202 +++++++++++++++++++++++++++++++++++++++++++
 kernel/sched.c              |    9 ++
 kernel/sched_fair.c         |   58 +++++++++++--
 kernel/sysctl.c             |   16 ++++
 kernel/time/tick-common.c   |   33 +++++++
 kernel/time/tick-internal.h |   20 ++++
 kernel/time/tick-sched.c    |   51 +++++++++++
 10 files changed, 390 insertions(+), 14 deletions(-)
 create mode 100644 kernel/Kconfig.sched

-- 
1.7.3.4
