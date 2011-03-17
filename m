Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941Ab1CQB1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 21:27:35 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:13789 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757209Ab1CQB0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 21:26:42 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: linux-serial@vger.kernel.org, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca
Cc: David Daney <ddaney@caviumnetworks.com>
Subject: [RFC PATCH 0/2] serial: Hack up 8520.c for evil device tree hookin.
Date: Wed, 16 Mar 2011 18:26:05 -0700
Message-Id: <1300325167-26433-1-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.3
X-OriginalArrivalTime: 17 Mar 2011 01:26:16.0083 (UTC) FILETIME=[4F5F9630:01CBE442]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wanted to get some feedback on my attempts to control my serial
device registration with device tree data.

It was suggested by Grant Likely that I could use of_serial.c for my
purposes.  However I think it is simpler to do my own registration
code, because I need to set my own device type, required port flags,
and I/O functions, instead of using general purpose ones.  Adding this
to of_serial.c would be quite ugly, so I would like to keep it with my
chip/board code.

This leads to a problem: You cannot call serial8250_register_port()
until the 8250.c driver is registered.  of_serial.c is lucky that it
comes after 8250.c in the make file so that the device initcall order
is correct.  When I put the code in my board's serial.c file, I am not
so lucky.  To get the initialization order correct, I add a notifier
chain to 8250.c

What say you all to this approach?

David Daney (2):
  serial: 8250: Add a notifier chain for driver registration.
  MIPS: Octeon: Use device tree to register serial ports.

 arch/mips/cavium-octeon/serial.c |  140 ++++++++++++++++----------------------
 drivers/tty/serial/8250.c        |   20 ++++++
 include/linux/serial_8250.h      |   21 ++++++
 3 files changed, 101 insertions(+), 80 deletions(-)

-- 
1.7.2.3

