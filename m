Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab2EBMp7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 08:45:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51182 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab2EBMp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 08:45:56 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-serial@vger.kernel.org
Cc: horms@verge.net.au, arnd@arndb.de, linux-sh@vger.kernel.org,
        gregkh@linuxfoundation.org, swarren@wwwdotorg.org,
        linux-kernel@vger.kernel.org, rjw@sisk.pl,
        paul.gortmaker@windriver.com, lethal@linux-sh.org, olof@lixom.net,
        Magnus Damm <magnus.damm@gmail.com>, dan.j.williams@intel.com,
        alan@linux.intel.com
Date: Wed, 02 May 2012 21:46:42 +0900
Message-Id: <20120502124642.30480.41373.sendpatchset@w520>
Subject: [PATCH 00/06] serial8250: DLL/DLM rework, Emma Mobile UART driver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

serial8250: DLL/DLM rework, Emma Mobile UART driver

[PATCH 01/06] serial8250: Add dl_read()/dl_write() callbacks
[PATCH 02/06] serial8250: Use dl_read()/dl_write() on Alchemy
[PATCH 03/06] serial8250: Use dl_read()/dl_write() on RM9K
[PATCH 04/06] serial8250: Clean up default map and dl code
[PATCH 05/06] serial8250: Introduce serial8250_register_8250_port()
[PATCH 06/06] serial8250-em: Add Emma Mobile UART driver

This series cleans up and adjusts the 8250 code base to allow
hooking in a driver for the UART in Emma Mobile SoCs.

In short:
- Patch 1-4 tie in 8250-specific dl_read()/dl_write() callbacks.
- Patch 5 adds a new register function to use new callbacks.
- Patch 6 adds a new driver that makes use of the above.

I'd be happy to rework the above patches if needed. The
main challenge for Emma Mobile UART support is the non-
standard offsets for DLL and DLM registers.

Note that there is no DT support included at this point,
but it boils down to a 10 line change. The boot loader on
my board does not do DT so I'd like to use kexec for DT
development (as usual), but to use kexec I first need to
get a non-DT kernel working. Which is basically this. =)

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 Builds on top of linux-next 20120501.

 drivers/tty/serial/8250/8250.c    |  373 ++++++++++++++++++-------------------
 drivers/tty/serial/8250/8250.h    |   14 +
 drivers/tty/serial/8250/8250_em.c |  179 +++++++++++++++++
 drivers/tty/serial/8250/Kconfig   |    8 
 drivers/tty/serial/8250/Makefile  |    1 
 include/linux/serial_8250.h       |    1 
 6 files changed, 392 insertions(+), 184 deletions(-)

