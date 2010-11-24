Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367Ab0KXX5H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 18:57:07 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:49098 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510Ab0KXX5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 18:57:06 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6177"; a="64054567"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/2] Optimized inlining for ARM
Date: Wed, 24 Nov 2010 15:56:58 -0800
Message-Id: <1290643020-24558-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.3.2.245.g03276
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I know that Ingo deliberately introduced this option as x86
specific, but I'd like to introduce this for ARM as well. To
avoid useless copy paste, I've made the option generic so
any arch can support it.

In an effort to make a tiny crash kernel this option can shave a
few kb off the crash kernel size. It also helps a regular kernel
have a smaller icache footprint which should be benficial.
This option isn't on by default so there is no harm in adding it
besides giving the user a potentially dangerous option to enable.
If it's really experimental we can add an "if EXPERIMENTAL" in the
second patch. In the end, I'd like to get a wider range of testing with
this feature enabled on ARM so I'm posting it here in hopes that
people can respond back with Tested-by tags (or Naks if it crashes their
system).

Stephen Boyd (2):
  Make OPTIMIZE_INLINING a generic option
  arm: add optimized inlining

 arch/arm/Kconfig       |    1 +
 arch/x86/Kconfig       |    4 +---
 arch/x86/Kconfig.debug |   14 --------------
 init/Kconfig           |   18 ++++++++++++++++++
 4 files changed, 20 insertions(+), 17 deletions(-)

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

