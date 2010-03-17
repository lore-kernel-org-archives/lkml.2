Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab0CQM25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 08:28:57 -0400
Received: from ernst.netinsight.se ([194.16.221.21]:52008 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754722Ab0CQM2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 08:28:55 -0400
Date: Wed, 17 Mar 2010 13:28:49 +0100
From: Simon Kagstrom <simon.kagstrom@netinsight.net>
To: x86@kernel.org, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, alan@linux.intel.com,
       akpm@linux-foundation.org, hpa@zytor.com
Subject: [PATCH 0/2]: x86: Honor IO_DELAY IO port settings
Message-ID: <20100317132849.7d49939b@marrow.netinsight.se>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings!

The kernel can be configured to use IO port 0xed instead of port 0x80
for IO delay writes and some boards also require this to function
properly. These two patches fix two places where port 0x80 is hardcoded.

* Patch 1: Use native_io_delay for the serial/8250 driver instead of
  always using 0x80.

* Patch 2: Honor CONFIG_IO_DELAY_0XED if set for real-mode boot code


The board we have works fine with using 0x80, but we're debugging a
BIOS issue and are logging writes to port 0x80 (BIOS post codes).
Avoiding the extra port 0x80 writes makes it easier to weed out the
important information.

// Simon
