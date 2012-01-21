Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab2AUKfL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 05:35:11 -0500
Received: from lo.gmane.org ([80.91.229.12]:37667 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754040Ab2AUKfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 05:35:08 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Lubos Kolouch <lubos.kolouch@gmail.com>
Subject: i915 wakes from suspend to RAM with blank screen after commit
 cd9dde44f47501394b9f0715b6a36a92aa74c0d0
Date: Sat, 21 Jan 2012 10:32:14 +0000 (UTC)
Message-ID: <jfe47e$5dn$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 188.122.213.132
User-Agent: Pan/0.135 (Tomorrow I'll Wake Up and Scald Myself with Tea; GIT
	30dc37b master)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

After upgrading kernel from 3.1.5 to 3.2.0 the notebook cannot wake from
suspend to RAM properly. The problem stays even with 3.3-rc1.

It wakes, but the screen is blank and computer needs to be rebooted.

When woken, computer is working otherwise (can ping it, ssh to it etc.)

I git bisected it to commit
cd9dde44f47501394b9f0715b6a36a92aa74c0d0 is the first bad commit
commit cd9dde44f47501394b9f0715b6a36a92aa74c0d0
Author: Adam Jackson <ajax@redhat.com>
Date:   Fri Oct 14 12:43:49 2011 -0400

    drm/i915/dp: Fix the math in intel_dp_link_required

    The previous code was confused about units, which is pretty reasonable
    given that the units themselves are confusing.

    Signed-off-by: Adam Jackson <ajax@redhat.com>
    Signed-off-by: Keith Packard <keithp@keithp.com>

:040000 040000 3c0a0f38fc6482a401340e03fa3fbd687d11eda4
294673b782b3ecc93540f46f7721d385bd30cfac M    drivers


Reproducible: Always

Steps to Reproduce:
1. suspend to RAM
2. start the computer
Actual Results:  
Screen is blank

Expected Results:  
Screen should be normal as before suspend

