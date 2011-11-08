Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab1KHDtB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 22:49:01 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32076 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280Ab1KHDsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 22:48:55 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6523"; a="135611801"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        Christine Chan <cschan@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCHv2 0/3] Catching del_timer_sync() on uninitialized timers
Date: Mon,  7 Nov 2011 19:48:25 -0800
Message-Id: <1320724108-20788-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.8.rc0.46.g5ae0f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are an update for previous patches sent by Christine. I've
reworked them to hopefully address Thomas' comments. The new
patch is the first patch, which tries to actually use debugobjects
code to print the warning instead of relying on users of the API
to do so (as suggested by Thomas).

Christine Chan (2):
  debugobjects: Extend to assert that an object is initialized
  kernel/timer.c: Use debugobjects to catch deletion of uninitialized
    timers

Stephen Boyd (1):
  debugobjects: Be smarter about static objects

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Christine Chan <cschan@codeaurora.org>
Cc: Andrew Morton <akpm@linux-foundation.org>

 Documentation/DocBook/debugobjects.tmpl |   50 +++++++++++++++++++++++++
 include/linux/debugobjects.h            |    6 +++
 kernel/timer.c                          |   62 ++++++++++++++++++++++++++++---
 lib/debugobjects.c                      |   53 ++++++++++++++++++++++++--
 4 files changed, 161 insertions(+), 10 deletions(-)

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

