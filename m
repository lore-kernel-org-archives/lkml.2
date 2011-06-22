Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406Ab1FVLUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 07:20:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756840Ab1FVLUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 07:20:03 -0400
From: Stefan Assmann <sassmann@kpanic.de>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        tony.luck@intel.com, andi@firstfloor.org, mingo@elte.hu, hpa@zytor.com,
        rick@vanrein.org, rdunlap@xenotime.net, sassmann@kpanic.de
Subject: [PATCH v2 0/3] support for broken memory modules (BadRAM)
Date: Wed, 22 Jun 2011 13:18:51 +0200
Message-Id: <1308741534-6846-1-git-send-email-sassmann@kpanic.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following the RFC for the BadRAM feature here's the updated version with
spelling fixes, thanks go to Randy Dunlap. Also the code is now less verbose,
as requested by Andi Kleen.
v2 with even more spelling fixes suggested by Randy.
Patches are against vanilla 2.6.39.
Repost with LKML in Cc as suggested by Andrew Morton.

The idea is to allow the user to specify RAM addresses that shouldn't be
touched by the OS, because they are broken in some way. Not all machines have
hardware support for hwpoison, ECC RAM, etc, so here's a solution that allows to
use bitmasks to mask address patterns with the new "badram" kernel command line
parameter.
Memtest86 has an option to generate these patterns since v2.3 so the only thing
for the user to do should be:
- run Memtest86
- note down the pattern
- add badram=<pattern> to the kernel command line

The concerning pages are then marked with the hwpoison flag and thus won't be
used by the memory managment system.

Link to Ricks original patches and docs:
http://rick.vanrein.org/linux/badram/

  Stefan

Stefan Assmann (3):
  Add string parsing function get_next_ulong
  support for broken memory modules (BadRAM)
  Add documentation and credits for BadRAM

 CREDITS                             |    9 +
 Documentation/BadRAM.txt            |  370 +++++++++++++++++++++++++++++++++++
 Documentation/kernel-parameters.txt |    6 +
 include/linux/kernel.h              |    1 +
 lib/cmdline.c                       |   35 ++++
 mm/memory-failure.c                 |  100 ++++++++++
 6 files changed, 521 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/BadRAM.txt

-- 
1.7.4

