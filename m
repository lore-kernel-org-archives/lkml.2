Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677Ab2JRXQF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 19:16:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41446 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab2JRXQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 19:16:03 -0400
Date: Thu, 18 Oct 2012 16:16:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/23] printk: refactoring
Message-Id: <20121018161601.c47c50c8.akpm@linux-foundation.org>
In-Reply-To: <cover.1350449851.git.joe@perches.com>
References: <cover.1350449851.git.joe@perches.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2012 23:06:04 -0700
Joe Perches <joe@perches.com> wrote:

> Make printk a bit more readable.
> 
> Joe Perches (23):
>   printk: Move to separate directory for easier modification
>   printk: Add console_cmdline.h
>   printk: Move braille console support into separate braille.[ch] files
>   printk: Use pointer for console_cmdline indexing
>   printk: rename struct log to struct printk_log
>   printk: Rename log_buf and __LOG_BUF_LEN
>   printk: Rename log_first and log_next variables
>   printk: Rename log_<foo> variables and functions
>   printk: Rename enum log_flags to printk_log_flags
>   printk: Rename log_wait to printk_log_wait
>   printk: Rename logbuf_lock to printk_logbuf_lock
>   printk: Rename clear_seq and clear_idx variables
>   printk: Remove static from printk_ variables
>   printk: Rename LOG_ALIGN to PRINTK_LOG_ALIGN
>   printk: Add and use printk_log.h
>   printk: Add printk_log.c
>   printk: Make wait_queue_head_t printk_log_wait extern
>   printk: Rename and move 2 #defines to printk_log.h
>   printk: Move devkmsg bits to separate file
>   printk: Prefix print_time and msg_print_text with printk_
>   printk: Move functions printk_print_time and printk_msg_print_text
>   printk: Add printk_syslog.c and .h
>   printk: Move kmsg_dump functions to separate file

OK, nobody's allowed to change the printk code for two months.

>  drivers/accessibility/braille/braille_console.c |    9 +-
>  fs/proc/kmsg.c                                  |    4 +-
>  kernel/Makefile                                 |    3 +-
>  kernel/printk.c                                 | 2820 -----------------------
>  kernel/printk/Makefile                          |    6 +
>  kernel/printk/braille.c                         |   48 +
>  kernel/printk/braille.h                         |   48 +
>  kernel/printk/console_cmdline.h                 |   14 +
>  kernel/printk/devkmsg.c                         |  309 +++
>  kernel/printk/kmsg_dump.c                       |  328 +++
>  kernel/printk/printk.c                          | 1515 ++++++++++++
>  kernel/printk/printk_log.c                      |  263 +++
>  kernel/printk/printk_log.h                      |  123 +
>  kernel/printk/printk_syslog.c                   |  354 +++
>  kernel/printk/printk_syslog.h                   |   12 +

It wouldn't hurt to describe the design here a bit.  How was the code
partitioned and what is the role of each file?

That's reasonably obvious from the names, but some might wonder about
the difference between printk_log and printk_syslog and how that
division was decided upon.


