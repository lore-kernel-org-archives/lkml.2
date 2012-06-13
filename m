Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393Ab2FMUUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 16:20:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:31269 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732Ab2FMUUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 16:20:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="157260954"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, eranian@google.com, peterz@infradead.org
Subject: Updated microcode tracking and PEBS workaround patchkit
Date: Wed, 13 Jun 2012 13:20:38 -0700
Message-Id: <1339618842-26636-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I addressed (most) of the review comments. The printk for mismatching
ucode is still there. And it's still walking all CPUs, but since that
happens in parallel it's not really exponentially longer delay.

There's a check now for mismatching model numbers and the
minimum ucode tracking is disabled for this case.

Also I implemented CPU loading earlier in the CPU notifier
for the microcode driver.

Also this actually fixes the code, it didn't work before for
hotplugged CPUs and didn't update the microcodes there.

-Andi

