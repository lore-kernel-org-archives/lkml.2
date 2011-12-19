Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598Ab1LSWRy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 17:17:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922Ab1LSWRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 17:17:52 -0500
Date: Mon, 19 Dec 2011 17:11:05 -0500
From: Jason Baron <jbaron@redhat.com>
To: greg@kroah.com
Cc: jim.cromie@gmail.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org
Message-Id: <cover.1324318997.git.jbaron@redhat.com>
Subject: [PATCH 00/16] dynamic debug: ehancements and cleanups
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Mostly cleanups and minor feature ehancements for dynamic debug. I haven't
included the module parameter feature, since its implementation is still
being worked out, but I wanted to get some of Jim's patches included, since
I've got so many. These have already been through several review iterations.
Patches are against Linus's latest tree.

Thanks,

-Jason

Jim Cromie (16):
  dynamic_debug: fix whitespace complaints from scripts/cleanfile
  dynamic_debug: drop enabled field from struct _ddebug, use _DPRINTK_FLAGS_PRINT
  dynamic_debug: make dynamic-debug supersede DEBUG ccflag
  dynamic_debug: change verbosity at runtime
  dynamic_debug: replace strcpy with strlcpy, in ddebug_setup_query()
  dynamic_debug: pr_err() call should not depend upon verbosity
  dynamic_debug: drop explicit !=NULL checks
  dynamic_debug: describe_flags with '=[pmflt_]*'
  dynamic_debug: tighten up error checking on debug queries
  dynamic_debug: early return if _ddebug table is empty
  dynamic_debug: reduce lineno field to a saner 18 bits
  dynamic_debug: chop off comments in ddebug_tokenize
  dynamic_debug: enlarge command/query write buffer
  dynamic_debug: add trim_prefix() to provide source-root relative paths
  dynamic_debug: factor vpr_info_dq out of ddebug_parse_query
  dynamic_debug: process multiple debug-queries on a line

 Documentation/dynamic-debug-howto.txt |   30 ++---
 include/linux/device.h                |    8 +-
 include/linux/dynamic_debug.h         |   19 ++-
 include/linux/netdevice.h             |    8 +-
 include/linux/printk.h                |    8 +-
 lib/dynamic_debug.c                   |  270 +++++++++++++++++++++++----------
 6 files changed, 222 insertions(+), 121 deletions(-)

-- 
1.7.7.3

