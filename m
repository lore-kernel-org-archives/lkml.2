Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932679Ab2EVWle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 18:41:34 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:56779 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753360Ab2EVWlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 18:41:31 -0400
Message-ID: <4FBC1618.5010408@fold.natur.cuni.cz>
Date: Wed, 23 May 2012 00:41:28 +0200
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120517 Firefox/12.0 SeaMonkey/2.9.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, khlebnikov@openvz.org,
        markus@trippelsdorf.de, hughd@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, oleg@redhat.com
Subject: 3.4-rc7: BUG: Bad rss-counter state mm:ffff88040b56f800 idx:1 val:-59
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,
  while shutting down my laptop (Dell Vostro 3550 with 16GB RAM, core i7) with 3.4-rc7 I got:

May 23 00:07:54 vostro kernel: [352687.968267] BUG: Bad rss-counter state mm:ffff88040b56f800 idx:1 val:-59
May 23 00:07:54 vostro kernel: [352687.968312] BUG: Bad rss-counter state mm:ffff88040b56f800 idx:2 val:59
May 23 00:07:55 vostro acpid: exiting
May 23 00:07:55 vostro syslog-ng[2838]: syslog-ng shutting down; version='3.3.4'

  I found by Google the below thread and thought that maybe it is related?
http://comments.gmane.org/gmane.linux.kernel.mm/76459

  Please forward this to the right person and Cc: me if I should provide more details (some lines form dmesg?).
I am a plain user and it is time to sleep here.

Actually, searching /var/log/messages backwards gives me few more hits on previous shutdowns:

May 14 18:36:11 vostro kernel: [548780.511951] xhci_hcd 0000:0b:00.0: Cached old ring, 1 ring cached
May 14 18:36:11 vostro kernel: [548780.511953] xhci_hcd 0000:0b:00.0: Cached old ring, 2 rings cached
May 14 18:36:11 vostro kernel: [548780.512034] xhci_hcd 0000:0b:00.0: // Ding dong!
May 14 18:36:11 vostro kernel: [548780.512042] xhci_hcd 0000:0b:00.0: get port status, actual port 0 status  = 0x2a0
May 14 18:36:11 vostro kernel: [548780.512043] xhci_hcd 0000:0b:00.0: Get port status returned 0x2a0
May 14 18:36:11 vostro kernel: [548780.536242] BUG: Bad rss-counter state mm:ffff88040bf760c0 idx:1 val:-1
May 14 18:36:11 vostro kernel: [548780.536245] BUG: Bad rss-counter state mm:ffff88040bf760c0 idx:2 val:1
May 14 18:36:11 vostro kernel: [548780.551350] xhci_hcd 0000:0b:00.0: get port status, actual port 0 status  = 0x2a0
May 14 18:36:11 vostro kernel: [548780.551363] xhci_hcd 0000:0b:00.0: Get port status returned 0x2a0
May 14 18:36:11 vostro kernel: [548780.591424] xhci_hcd 0000:0b:00.0: get port status, actual port 0 status  = 0x2a0
May 14 18:36:11 vostro kernel: [548780.591427] xhci_hcd 0000:0b:00.0: Get port status returned 0x2a0
May 14 18:36:11 vostro kernel: [548780.631208] xhci_hcd 0000:0b:00.0: get port status, actual port 0 status  = 0x2a0
May 14 18:36:11 vostro kernel: [548780.631217] xhci_hcd 0000:0b:00.0: Get port status returned 0x2a0
May 14 18:36:11 vostro kernel: [548780.671254] xhci_hcd 0000:0b:00.0: get port status, actual port 0 status  = 0x2a0
May 14 18:36:11 vostro kernel: [548780.671256] xhci_hcd 0000:0b:00.0: Get port status returned 0x2a0
May 14 18:36:11 vostro kernel: [548780.671259] hub 4-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x2a0
May 14 18:36:11 vostro kernel: [548781.093467] BUG: Bad rss-counter state mm:ffff88040954ec40 idx:1 val:-1
May 14 18:36:11 vostro kernel: [548781.093470] BUG: Bad rss-counter state mm:ffff88040954ec40 idx:2 val:1

My older logs show it appeared first in 3.4.0-rc6. Or is it that because I changed my .config
at that time? Can't say at the moment. What type of config variable should I look for?

Best regards,
Martin
