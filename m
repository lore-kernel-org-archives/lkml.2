Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab1AYAYr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 19:24:47 -0500
Received: from smtp-out.google.com ([74.125.121.67]:59815 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab1AYAYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 19:24:46 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=DTE0gr6q0CUknPU6wDl4gheiW0EEkziP85TjE0KvM5T5Ijgdtyjah7BO5Xal6GxMu
	rGtXCgslpqCCA2wRQQ+1Q==
Subject: [PATCH v1 0/6] google firmware support
To: Greg KH <greg@kroah.com>, torvalds@linux-foundation.org
From: Mike Waychison <mikew@google.com>
Cc: San Mehat <san@google.com>, Aaron Durbin <adurbin@google.com>,
        Duncan Laurie <dlaurie@google.com>, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>
Date: Mon, 24 Jan 2011 16:24:34 -0800
Message-ID: <20110125002433.12637.51091.stgit@mike.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset applies to v2.6.38-rc2.

The following series implements support for interfaces exposed by
google's servers' firmware.

We'd like to have these small drivers included as they are required for
proper use of the kernel in our infrastructure.  They may not seem like
much, but a lot of our health automation as well as our human debugging
efforts are dependent on the functionality herein.

I'm pretty happy with the way this patchset looks and would like to ask
that they be merged at some point if there aren't any big objections.
Getting these in the public Linux tree would bring us closer to being
able to easily test kernels as they are released.

I wasn't certain who to send these patches to, please advise if I should
be CCing anyone else.

Thanks,

Patchset summary
================

[1] and [5] are the only ones that touch the 'core' kernel.


   - [1] adds a notifier_block that is called on Oops.

   - [2] introduces CONFIG_GOOGLE_FIRMWARE which all Google firmware
     drivers can depend upon.

   - [3] and [4] are drivers we use that are ready for inclusion.  [3]
     communicates with our EFI images via an SMI handshake.  [4] works
     with our older BIOSes to construct a log of reboot reasons.

   - [5] prepares for [6] by introducing prepend_to_dmesg() which
     allows drivers to prepend pre-kernel messages to the dmesg at
     bootup.

   - [6] uses the bits in [5].  It discovers the BIOSes memory log and
     prepends it to the dmesg during bootup.

Diffstat
========

 drivers/firmware/Kconfig             |   10 
 drivers/firmware/Makefile            |    2 
 drivers/firmware/google/Kconfig      |   39 +
 drivers/firmware/google/Makefile     |    4 
 drivers/firmware/google/bootlog.c    |  884 +++++++++++++++++++++++++++++++++
 drivers/firmware/google/gsmi.c       |  931 +++++++++++++++++++++++++++++++++++
 drivers/firmware/google/memconsole.c |  136 +++++
 fs/compat_ioctl.c                    |    7 
 include/linux/gsmi.h                 |  120 ++++
 include/linux/kernel.h               |    3 
 include/linux/miscdevice.h           |    1 
 include/linux/notifier.h             |    3 
 include/linux/printk.h               |    5 
 kernel/panic.c                       |   15 
 kernel/printk.c                      |   55 ++
 15 files changed, 2214 insertions(+), 1 deletion(-)

ChangeLog:
==========
- v1
   - Initial public send-out.
