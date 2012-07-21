Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab2GUA1f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 20:27:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45132 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178Ab2GUA1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 20:27:33 -0400
Date: Fri, 20 Jul 2012 17:25:29 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kay Sievers <kay@vrfy.org>, Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 0/4] KDB: Fix dmesg command
Message-ID: <20120721002529.GA20567@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The dmesg command appears to be broken after the printk rework. The old
logic in the kdb code makes no sense in terms of current printk/logging
storage format, and KDB simply hangs forever upon entering 'dmesg'
command.

The first patch revives the command by switching to kmsg_dumper iterator.
As a side-effect, the code is now much more simpler.

A few changes were needed in the printk.c: we needed unlocked variant
of the kmsg_dumper iterator, but these can surely wait for 3.6.

It's probably too late even for the first patch to go to 3.5, but
I'll try to convince otherwise. :-) Here we go:

- The current code is broken for sure, and has no hope to work at
  all. It is a regression;
- The new code works for me, and probably works for everyone else;
- If it compiles (and I urge everyone to compile-test it on your
  setup), it hardly can make things worse.

Thanks!

--
 include/linux/kmsg_dump.h      |   16 +++++++
 kernel/debug/kdb/kdb_main.c    |   91 +++++++++++++++-------------------------
 kernel/debug/kdb/kdb_private.h |    1 -
 kernel/printk.c                |   83 +++++++++++++++++++++++-------------
 4 files changed, 104 insertions(+), 87 deletions(-)

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
