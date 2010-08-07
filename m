Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab0HGSKI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 14:10:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49162 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab0HGSKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 14:10:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=MttJWgLfESD3yMx1kViWeHRbYZ9JJp1XvhfYhmjn/dUEFyaC6WjQfgv3YyaujHtlRh
         eKkMqfquhOjY1nRpML9LO1guY5TYJVVTfREduNk94rMRpZa9Z3FHuBwn1R+aBhbBWNlI
         fNws2oCPqg+oThSP81Maozz/B5NrBTw5FkKd0=
From: Namhyung Kim <namhyung@gmail.com>
To: Len Brown <lenb@kernel.org>, linux-pm@lists.linux-foundation.org
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] intel_idle: add missing __percpu markup
Date: Sun,  8 Aug 2010 03:10:03 +0900
Message-Id: <1281204603-13406-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

intel_idle_cpuidle_devices is a percpu pointer but was missing __percpu markup.
Add it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/idle/intel_idle.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 54f0fb4..d86ce30 100755
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -85,7 +85,7 @@ static int (*choose_substate)(int);
 /* Reliable LAPIC Timer States, bit 1 for C1 etc.  */
 static unsigned int lapic_timer_reliable_states;
 
-static struct cpuidle_device *intel_idle_cpuidle_devices;
+static struct cpuidle_device __percpu *intel_idle_cpuidle_devices;
 static int intel_idle(struct cpuidle_device *dev, struct cpuidle_state *state);
 
 static struct cpuidle_state *cpuidle_state_table;
-- 
1.7.0.4

