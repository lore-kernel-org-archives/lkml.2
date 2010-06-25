Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab0FYDpe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 23:45:34 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:48338 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab0FYDpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 23:45:32 -0400
MIME-Version: 1.0
From: Kyle Moffett <kyle@moffetthome.net>
Date: Thu, 24 Jun 2010 23:45:11 -0400
Message-ID: <AANLkTinoWJR77N9C_We-_xD4ZeXjTx2naBUzCun6VoQv@mail.gmail.com>
Subject: of-flash: Unable to ioremap() both 128MB NOR flashes on 32-bit system 
	with 2GB+ RAM
To: linuxppc-embedded@lists.linuxppc.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've got a new P2020 (32bit mpc85xx family) board I'm working on a
port for that includes 2 NOR flashes (128MB each) and a removable
SO-RDIMM of 2GB or 4GB.  Unfortunately when I configure both flashes
in the device-tree off my elbc, Linux is completely unable to access
the second one because it attempts to ioremap() the entire virtual
address space of both FLASH chips.

Even with only one flash chip enabled, there's a bit of a noticeable
performance degradation because the mapping consumes almost all of my
available vmalloc space and forces bounce-buffering for all my
HIGHMEM.

It looks like the "of-flash" driver currently requires that the whole
chip be mapped in the kernel at once.  I would much rather have a 50%
performance penalty on flash accesses (which are already very slow)
and regain most of the vmap space.

So the question is, is there a way to convince the MTD layer to
iomap() only what it needs to access to do reads and writes?  If not,
what changes would need to be made to MTD and/or "of-flash" to create
such functionality?

Cheers,
Kyle Moffett
