Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932578Ab0KCPcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 11:32:19 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:40522 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932228Ab0KCPcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 11:32:15 -0400
Date: Wed, 3 Nov 2010 15:32:06 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-hams@vger.kernel.org, Simon Eatough <simon.eatough@gmail.com>
Subject: Unaligned accesses in AVR32 kernel
Message-ID: <20101103153206.GA20830@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans-Christian,

I received a bug report for some networking code from which it seems as
if the AVR32 kernel doesn't fixup exceptions caused by missaligned kernel
accesses either in software or hardware.  This is a problem as there in
the networking stack there is no general guarantee that all multi-byte
header fields such as ARP or IP headers will aligned.  Networking drivers
are supposed to make a decent attempt to place packets at a suitable
address but there is no guarantee.  The mkiss.c driver gets that wrong
which I'm fixing but fundamentally you want to add automated fixing of
unaligned exception to the AVR32 kernel.  See arch/mips/kernel/unaligned.c.

Cheers,

  Ralf
