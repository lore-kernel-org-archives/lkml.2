Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab1KQWRf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 17:17:35 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:56360 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab1KQWRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 17:17:34 -0500
Date: Thu, 17 Nov 2011 23:17:31 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: linux-kernel@vger.kernel.org
Subject: Impossible high cpu-time values for migration threads
Message-ID: <20111117221731.GA9229@x4.trippels.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just saw this for the first time:

  1  [||                                                          2.4%]     Tasks: 63, 31 thr, 54 kthr; 1 running
  2  [||                                                          1.7%]     Load average: 0.03 0.06 0.36 
  3  [||                                                          1.0%]     Uptime: 06:36:59
  4  [||                                                          1.0%]
  Mem[||||||||||||||||||||||||||||||||||                   1427/7977MB]
  Mem:7977M used:1427M buffers:0M cache:2604M 
  Swp[|                                                       0/2047MB]

  PID USER     PRI  NI  VIRT   RES   SHR S CPU% MEM%   TIME+  Command
   11 root      RT   0     0     0     0 S  0.0  0.0  5h38:27 migration/2
   14 root      RT   0     0     0     0 S  0.0  0.0  5h30:29 migration/3
 1476 root      20   0 97672 38928  5024 S  1.0  0.5  4:49.06 /usr/bin/X -nolisten tcp :0 -auth /home/markus/.serverauth.1459
 1281 markus    20   0  931M  317M 40592 S  0.0  4.0  4:19.17 firefox
 1538 markus    20   0  200M 34544 18848 S  0.0  0.4  2:43.89 konsole -e /home/markus/start_screen
  868 mpd       20   0  294M 20336  4868 S  0.0  0.2  2:04.88 mpd --no-daemon
...

As you can see the machine has an uptime of 06:36:59 and the two
migration threads both show greater than 5h30min cpu-time.

(Linux 3.2.0-rc2-00046-g317bfe8 on amd64)

-- 
Markus
