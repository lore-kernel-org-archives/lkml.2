Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab2DFHDX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 03:03:23 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:38531 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab2DFHDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 03:03:22 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6671"; a="179411558"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC/PATCH 0/3] static keys for debugobjects
Date: Fri,  6 Apr 2012 00:03:15 -0700
Message-Id: <1333695798-2917-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.10.rc3.3.g19a6c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building in debugobjects support without enabling debugobjects
by default is useful in test scenarios where recompiling isn't
an option. Moving this interface to static keys/jump labels should
allow us to always have this code compiled in without worrying about
performance overhead when it's disabled.

RFC because I don't have any numbers to back this up and it's debug
code. I took a stab at using perf but I don't think the x86 machine
I was using had good enough stuff to see i-cache misses or things
like that. Hints on what to do to actually prove this is useful are
appreciated.

This is based on the perf/jump-labels branch in the tip tree:

 git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf/jump-labels

Stephen Boyd (3):
  timer: Move debugobjects.h include to timer.c
  init: Initialize jump_labels before early parameters
  debugobjects: Use static keys for debug_objects_enabled

 include/linux/debugobjects.h |   94 +++++++++++++++++++++++++++++++++++++-----
 include/linux/timer.h        |    1 -
 init/main.c                  |    4 +-
 kernel/timer.c               |    1 +
 lib/debugobjects.c           |   73 ++++++++++++--------------------
 5 files changed, 113 insertions(+), 60 deletions(-)

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

