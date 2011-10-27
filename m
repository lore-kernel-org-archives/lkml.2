Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab1J0CXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 22:23:15 -0400
Received: from smtp-out.google.com ([74.125.121.67]:15170 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab1J0CXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 22:23:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:organization;
	b=AVCzP1aPvMOuPwEKEI47oH4CdOxXRkbc00mWLT21QEHqjJZdrvH/6TnHBiwCoQvwP
	Zab/ysIPkPc12ZNAog9jg==
From: David Decotigny <david.decotigny@google.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Randy Dunlap <rdunlap@xenotime.net>,
        Michal Schmidt <mschmidt@redhat.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        David Decotigny <david.decotigny@google.com>
Subject: [PATCH v1 0/3] param: configurable /sys/module/*/paramaters
Date: Wed, 26 Oct 2011 19:22:24 -0700
Message-Id: <cover.1319679966.git.david.decotigny@google.com>
X-Mailer: git-send-email 1.7.3.1
Organization: Google, Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These changes allow to compile kernels with sysfs but without
/sys/module/*/paramaters/. This should allow:
 - on small systems: no memory pressure caused by unneeded sysfs
   attributes.
 - on large systems: more modules could be converted to have their
   perm != 0 in module_param(): better for audit, debug, etc. For
   example, on my copy, 1658 module attributes have perm == 0,
   presumably to spare some memory, but it can be interesting to have
   access to those at runtime.

By default, /sys/module/*/paramaters/ is enabled, but can be disabled
in expert mode (CONFIG_SYSFS_MODULE_PARAM is not set).

David Decotigny (3):
  param: make destroy_params() private
  param: simple refactoring
  param: allow to selectively enable /sys/module/MOD/paramaters nodes

 fs/sysfs/Kconfig            |   15 ++++++-
 include/linux/moduleparam.h |   14 +-----
 kernel/module.c             |    9 ++++
 kernel/params.c             |  108 +++++++++++++++++++++----------------------
 4 files changed, 77 insertions(+), 69 deletions(-)

-- 
1.7.3.1

