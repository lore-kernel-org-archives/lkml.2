Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933515Ab0HJWEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 18:04:44 -0400
Received: from kroah.org ([198.145.64.141]:45014 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933458Ab0HJWAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 18:00:41 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: John Villalovos <jvillalo@redhat.com>,
        John Villalovos <john.l.villalovos@intel.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 53/68] serial: fix missing bit coverage of ASYNC_FLAGS
Date: Tue, 10 Aug 2010 14:59:15 -0700
Message-Id: <1281477570-18944-53-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100810214425.GB17385@kroah.com>
References: <20100810214425.GB17385@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Villalovos <jvillalo@redhat.com>

It seems that currently ASYNC_FLAGS is one bit short of covering all the
bits of the ASYNC user flags.  In particular it does not cover the
ASYNC_AUTOPROBE bit.

ASYNCB_LAST_USER and ASYNCB_AUTOPROBE are both equal to 15.

Therefore:
ASYNC_AUTOPROBE = 1000 0000 0000 0000
ASYNC_FLAGS     = 0111 1111 1111 1111

So ASYNC_FLAGS is not covering the ASYNC_AUTOPROBE bit.

This patch fixes the issue and with the patch the values will be:
ASYNC_AUTOPROBE = 1000 0000 0000 0000
ASYNC_FLAGS     = 1111 1111 1111 1111

As a side note, doing a "git grep" I didn't find any use of
ASYNC_AUTOPROBE or ASYNCB_AUTOPROBE in the kernel, besides this include
file.

Signed-off-by: John Villalovos <john.l.villalovos@intel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/serial.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/serial.h b/include/linux/serial.h
index c8613c3..c3b45ad 100644
--- a/include/linux/serial.h
+++ b/include/linux/serial.h
@@ -151,7 +151,7 @@ struct serial_uart_config {
 #define ASYNC_BUGGY_UART	(1U << ASYNCB_BUGGY_UART)
 #define ASYNC_AUTOPROBE		(1U << ASYNCB_AUTOPROBE)
 
-#define ASYNC_FLAGS		((1U << ASYNCB_LAST_USER) - 1)
+#define ASYNC_FLAGS		((1U << (ASYNCB_LAST_USER + 1)) - 1)
 #define ASYNC_USR_MASK		(ASYNC_SPD_HI|ASYNC_SPD_VHI| \
 		ASYNC_CALLOUT_NOHUP|ASYNC_SPD_SHI|ASYNC_LOW_LATENCY)
 #define ASYNC_SPD_CUST		(ASYNC_SPD_HI|ASYNC_SPD_VHI)
-- 
1.7.2

