Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab2FUMHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 08:07:23 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:51747 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757123Ab2FUMHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 08:07:22 -0400
From: Borislav Petkov <bp@amd64.org>
To: X86-ML <x86@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH -v2 0/2] x86, microcode: Reload ucode only per-system
Date: Thu, 21 Jun 2012 14:07:15 +0200
Message-Id: <1340280437-7718-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.11.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Ok, here's the second version with all review comments addressed. I've
dropped the stable tag since this has been that way (and b0rked) since
forever so stable rules don't apply.

We can probably do single backports if distros want it.



Changelog:

-v1:

Once upon a time there was this microcode reloading interface
/sys/devices/system/cpu/cpuX/microcode/reload, where X is an online
cpu on the system, which allowed the loading of microcode in a per-cpu
manner.

This had problems like having different ucode revisions on an otherwise
homogeneous system and needed O(n^2) overhead when tracking minimum
microcode revision per-core.

So make this interface per-system so that it does microcode reloading on
the whole system only.

Single commit messages have more info too.

The first patch has a stable tag which I'd like to see in stable but
since it is not fixing a direct regression, I'd like to not push it
upstream now but have it get tested in linux-next and go upstream during
the next merge window from where it can trickle slowly to stable.

Patches have been tested on all AMD families, it wouldn't hurt if it saw
some Intel testing too, although it should just work.

Holler if you see regressions/problems with it.

Thanks.
