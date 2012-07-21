Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693Ab2GUKl7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 06:41:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48408 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab2GUKl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 06:41:57 -0400
From: Joe Millenbach <jmillenbach@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: team-fjord@googlegroups.com, Joe Millenbach <jmillenbach@gmail.com>
Subject: [PATCH 0/7] x86/boot: Shrink the decompression stub: conditionally exclude cmdline processing
Date: Sat, 21 Jul 2012 03:41:44 -0700
Message-Id: <1342867304-30777-1-git-send-email-jmillenbach@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch set that progressively allows more of the decompression command
line processing code to be removed if it can't be used.  This can shrink the
compressed kernel image by over 2k.  The quiet and debug flags been switched to
use the pre-existing CONFIG_X86_VERBOSE_BOOT compile flag instead.  And when
not compiled with earlyprintk debugging, the command-line processing code now
has nothing to configure, so exclude it entirely.

Gokul Caushik (1):
  x86/boot: Exclude cmdline.c if you can't use it

Joe Millenbach (6):
  x86/boot: Removed quiet flag and switched quiet output to debug flag
  x86/boot: Wrap debug printing in a new debug_putstr function
  x86/boot: Changed error putstr path to match new debug_putstr format
  x86/boot: Switch output functions from command-line flags to
    conditional compilation
  x86/boot: Removed unused debug flag and set code
  x86/boot: Exclude early_serial_console.c if can't use it.

 arch/x86/boot/compressed/cmdline.c              |    4 +++
 arch/x86/boot/compressed/early_serial_console.c |    4 +++
 arch/x86/boot/compressed/misc.c                 |   31 ++++++-----------------
 arch/x86/boot/compressed/misc.h                 |   27 +++++++++++++++++---
 4 files changed, 40 insertions(+), 26 deletions(-)

-- 
1.7.9.5

