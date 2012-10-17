Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab2JQGGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 02:06:40 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:49047 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754205Ab2JQGGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 02:06:38 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 00/23] printk: refactoring
Date: Tue, 16 Oct 2012 23:06:04 -0700
Message-Id: <cover.1350449851.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make printk a bit more readable.

Joe Perches (23):
  printk: Move to separate directory for easier modification
  printk: Add console_cmdline.h
  printk: Move braille console support into separate braille.[ch] files
  printk: Use pointer for console_cmdline indexing
  printk: rename struct log to struct printk_log
  printk: Rename log_buf and __LOG_BUF_LEN
  printk: Rename log_first and log_next variables
  printk: Rename log_<foo> variables and functions
  printk: Rename enum log_flags to printk_log_flags
  printk: Rename log_wait to printk_log_wait
  printk: Rename logbuf_lock to printk_logbuf_lock
  printk: Rename clear_seq and clear_idx variables
  printk: Remove static from printk_ variables
  printk: Rename LOG_ALIGN to PRINTK_LOG_ALIGN
  printk: Add and use printk_log.h
  printk: Add printk_log.c
  printk: Make wait_queue_head_t printk_log_wait extern
  printk: Rename and move 2 #defines to printk_log.h
  printk: Move devkmsg bits to separate file
  printk: Prefix print_time and msg_print_text with printk_
  printk: Move functions printk_print_time and printk_msg_print_text
  printk: Add printk_syslog.c and .h
  printk: Move kmsg_dump functions to separate file

 drivers/accessibility/braille/braille_console.c |    9 +-
 fs/proc/kmsg.c                                  |    4 +-
 kernel/Makefile                                 |    3 +-
 kernel/printk.c                                 | 2820 -----------------------
 kernel/printk/Makefile                          |    6 +
 kernel/printk/braille.c                         |   48 +
 kernel/printk/braille.h                         |   48 +
 kernel/printk/console_cmdline.h                 |   14 +
 kernel/printk/devkmsg.c                         |  309 +++
 kernel/printk/kmsg_dump.c                       |  328 +++
 kernel/printk/printk.c                          | 1515 ++++++++++++
 kernel/printk/printk_log.c                      |  263 +++
 kernel/printk/printk_log.h                      |  123 +
 kernel/printk/printk_syslog.c                   |  354 +++
 kernel/printk/printk_syslog.h                   |   12 +
 15 files changed, 3031 insertions(+), 2825 deletions(-)
 delete mode 100644 kernel/printk.c
 create mode 100644 kernel/printk/Makefile
 create mode 100644 kernel/printk/braille.c
 create mode 100644 kernel/printk/braille.h
 create mode 100644 kernel/printk/console_cmdline.h
 create mode 100644 kernel/printk/devkmsg.c
 create mode 100644 kernel/printk/kmsg_dump.c
 create mode 100644 kernel/printk/printk.c
 create mode 100644 kernel/printk/printk_log.c
 create mode 100644 kernel/printk/printk_log.h
 create mode 100644 kernel/printk/printk_syslog.c
 create mode 100644 kernel/printk/printk_syslog.h

-- 
1.7.10.4

