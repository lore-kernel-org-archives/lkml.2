Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab2DQAdw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 20:33:52 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:2537 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197Ab2DQAdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 20:33:50 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-127.messagelabs.com!1334622819!3267059!2
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 0/2] init: make sure syscall arguments are marked __user where needed
Date: Mon, 16 Apr 2012 17:33:23 -0700
User-Agent: KMail/1.9.9
CC: <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204161733.23830.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using syscall routines in the kernel, some of the arguments
should be user pointers but are missing the __user markup. This
produces a number of sparse warnings of the format:    
  
warning: incorrect type in argument 1 (different address spaces)
   expected char [noderef] <asn:1>*dev_name
   got char *name 

Wrap the syscall routines in the private do_mounts.h header so that
the appropriate __user markups are added for the init mount code.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Andrew Morton <akpm@linux-foundation.org>

init: introduce private syscall wrappers for non-user space pointers
init: use private syscall wrappers for non-user space pointers

 init/do_mounts.c        |   14 +++---
 init/do_mounts.h        |  107 ++++++++++++++++++++++++++++++++++++++++++++++-
 init/do_mounts_initrd.c |   28 ++++++------
 init/do_mounts_md.c     |    6 +-
 init/do_mounts_rd.c     |   22 +++++-----
 init/initramfs.c        |   54 ++++++++++++-----------
 init/noinitramfs.c      |    9 ++--
 7 files changed, 173 insertions(+), 67 deletions(-)
